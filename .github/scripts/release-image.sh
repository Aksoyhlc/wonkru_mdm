#!/usr/bin/env bash
set -euo pipefail

TAG_PATTERN='^v(0|[1-9][0-9]{0,8})\.(0|[1-9][0-9]{0,8})\.(0|[1-9][0-9]{0,8})$'

fail() { printf '%s\n' "$*" >&2; exit 1; }

registry_index() {
  local result
  if result="$(docker buildx imagetools inspect --raw "$1" 2>&1)"; then
    printf '%s\n' "$result"
  elif [[ "$result" == *'not found'* || "$result" == *'manifest unknown'* ]]; then
    return 3
  else
    printf '%s\n' "$result" >&2
    return 1
  fi
}

github_release() {
  local result
  if result="$(gh api "repos/$GITHUB_REPOSITORY/releases/$1" 2>&1)"; then
    printf '%s\n' "$result"
  elif [[ "$result" == *'HTTP 404'* ]]; then
    return 3
  else
    printf '%s\n' "$result" >&2
    return 1
  fi
}

verify_release_index() {
  local agent_sha256
  agent_sha256="$(jq -er '.sha256' wonkru_mdm_server/assets/agent/wonkru-mdm-apk.json)"
  jq -e --arg revision "$revision" --arg version "$RELEASE_TAG" --arg agent_sha256 "$agent_sha256" '
    .annotations["org.opencontainers.image.revision"] == $revision and
    .annotations["org.opencontainers.image.version"] == $version and
    .annotations["io.wonkrumdm.agent.sha256"] == $agent_sha256 and
    ([.manifests[].platform | select(.os == "linux") | .architecture] | unique)
      == ["amd64", "arm64"]
  ' >/dev/null || fail "$IMAGE:$RELEASE_TAG does not match release commit $revision, its APK and both architectures."
}

version_at_least() {
  [[ "$(printf '%s\n' "$1" "$2" | LC_ALL=C sort -V | tail -n1)" == "$1" ]]
}

[[ "$RELEASE_TAG" =~ $TAG_PATTERN ]] || fail 'Choose an existing vX.Y.Z release tag.'
revision="$(git rev-parse HEAD)"

case "$1" in
  check)
    if index="$(registry_index "$IMAGE:$RELEASE_TAG")"; then
      verify_release_index <<< "$index"
      printf 'build=false\n' >> "$GITHUB_OUTPUT"
    else
      [[ $? == 3 ]] || exit 1
      release="$(gh release view "$RELEASE_TAG" --json isDraft,isPrerelease)"
      if jq -e '.isDraft == false' <<< "$release" >/dev/null; then
        fail 'A published release already uses this tag, but its image is missing. Restore that image before rerunning.'
      fi
      printf 'build=true\n' >> "$GITHUB_OUTPUT"
    fi
    ;;
  publish)
    registry_index "$IMAGE:$RELEASE_TAG" | verify_release_index

    github_latest=''
    if release="$(github_release latest)"; then
      github_latest="$(jq -er '.tag_name' <<< "$release")"
      [[ "$github_latest" =~ $TAG_PATTERN ]] || fail 'The current latest GitHub Release must use a vX.Y.Z tag.'
    else
      [[ $? == 3 ]] || exit 1
    fi

    docker_latest=''
    if index="$(registry_index "$IMAGE:latest")"; then
      docker_latest="$(jq -er '.annotations["org.opencontainers.image.version"]' <<< "$index")" ||
        fail 'The existing Docker Hub latest image is missing its version annotation.'
      [[ "$docker_latest" =~ $TAG_PATTERN ]] || fail 'The Docker Hub latest image must use a vX.Y.Z version annotation.'
    else
      [[ $? == 3 ]] || exit 1
    fi

    promote=false
    if { [[ -z "$github_latest" ]] || version_at_least "$RELEASE_TAG" "$github_latest"; } &&
       { [[ -z "$docker_latest" ]] || version_at_least "$RELEASE_TAG" "$docker_latest"; }; then
      promote=true
    fi

    release="$(gh release view "$RELEASE_TAG" --json isDraft,isPrerelease)"
    jq -e '.isPrerelease == false' <<< "$release" >/dev/null ||
      fail "GitHub Release $RELEASE_TAG is a prerelease."

    if [[ "$promote" == true && "$docker_latest" != "$RELEASE_TAG" ]]; then
      docker buildx imagetools create --tag "$IMAGE:latest" "$IMAGE:$RELEASE_TAG"
    fi

    if jq -e '.isDraft == true' <<< "$release" >/dev/null; then
      gh release edit "$RELEASE_TAG" --draft=false --latest="$promote"
    elif [[ "$promote" == true && "$github_latest" != "$RELEASE_TAG" ]]; then
      gh release edit "$RELEASE_TAG" --latest
    fi
    ;;
  *) fail 'Usage: release-image.sh check|publish' ;;
esac
