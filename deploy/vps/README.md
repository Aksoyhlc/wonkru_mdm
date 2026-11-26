# Wonkru MDM deployment

## Install the published image

Follow [Install](https://docs.wonkrumdm.com/deployment/self-hosting/) or the
[Turkish guide](https://docs.wonkrumdm.com/tr/deployment/self-hosting/). On Ubuntu or Debian,
the installer defaults to `/opt/wonkru-mdm`. It saves `install.sh` in that directory for
updates. Restrict access to the API and panel until the first administrator is configured.

```bash
curl -fsSL https://wonkrumdm.com/install.sh | sudo bash
```

On first install, the script asks for missing settings when you run it from a terminal.
For unattended installation, pass `--non-interactive` after `sudo bash -s --`.

Use the guide for HTTPS, macOS, and backups. The image and install files come from the same
GitHub release. The Compose project name is `wonkru-mdm-image`.

## Recover an admin account

The server image also carries an operator CLI for password and 2FA recovery. It connects to
the database directly and never opens the API or web ports, so it is safe while the server
runs.

```bash
cd /opt/wonkru-mdm
docker compose exec server ./bin/server admin passwd --email you@example.com
docker compose exec server ./bin/server admin passwd --email you@example.com --clear-totp
docker compose exec server ./bin/server admin list
```

Add `--create` when the account does not exist yet and `--grant-admin` when the auth user
exists without a panel profile. The password is prompted with echo disabled, or read from
stdin with `--password-stdin` (add `-T` to `docker compose exec` in scripts); it is never
accepted as a command line argument. Active sessions are revoked unless `--keep-sessions`
is passed. If the container is stopped, use
`docker compose run --rm --no-deps --entrypoint ./bin/server server admin ...`.

## Build from source

From the local project root, send your checkout to the VPS. Prepare
`/opt/wonkru-mdm-source/deploy/vps/.env` on the server first.

```bash
./deploy/vps/deploy.sh root@SERVER_IP
```

The script uses the signed APK already prepared locally or fetches it from the latest GitHub
Release. Set `WONKRU_AGENT_TAG` to fetch from a specific release. It builds the panel locally
and uses `docker-compose.build.yaml` to build the server image on the VPS. Use the existing
path explicitly when updating an older source deployment in `/opt/wonkru-mdm`. The source
Compose project name is `wonkru-mdm`.

## Publish a release

Export the committed changes to the public `Aksoyhlc/wonkru_mdm` repository. Ensure the
`wonkrumdm/wonkrumdm` Docker Hub repository is public and configure `DOCKERHUB_USERNAME`
and `DOCKERHUB_TOKEN` as Actions secrets in the public GitHub repository.

From a checkout of the release commit, configure `wonkru_mdm_mobil/android/key.properties`
and run `bash deploy/prepare-agent-apk.sh`. The script builds and verifies the release APK.
Create a draft GitHub Release for the stable `vX.Y.Z` tag and attach `wonkru-mdm.apk` and
`wonkru-mdm-apk.json` from `wonkru_mdm_server/assets/agent/`. Keep the keystore and its
passwords on the signing machine. Push the tag and run **Release Docker image** for that tag
if the workflow ran before the assets were available. The workflow packages the same verified
APK into both image architectures and publishes the draft after the images are available.
