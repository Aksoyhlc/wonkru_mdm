#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
mobile="$root/wonkru_mdm_mobil"
assets="$root/wonkru_mdm_server/assets/agent"

if (( $# > 1 )); then
  echo "Usage: bash deploy/prepare-agent-apk.sh [signed-apk]" >&2
  exit 1
fi
if (( $# == 0 )); then
  (
    cd "$mobile"
    WONKRU_REQUIRE_RELEASE_SIGNING=true flutter build apk --release \
      --dart-define=WONKRU_PUBLIC_AGENT=true
  )
fi
apk="${1:-$mobile/build/app/outputs/flutter-apk/app-release.apk}"

python3 - "$apk" "$assets" <<'PY'
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

apk = Path(sys.argv[1])
assets = Path(sys.argv[2])
sdk = Path(
    os.environ.get("ANDROID_HOME")
    or os.environ.get("ANDROID_SDK_ROOT")
    or Path.home() / "Library/Android/sdk"
)
override = os.environ.get("ANDROID_BUILD_TOOLS")
tools = Path(override) if override else max(
    (
        path
        for path in (sdk / "build-tools").glob("*")
        if re.fullmatch(r"\d+\.\d+\.\d+", path.name)
        and (path / "aapt").is_file()
        and (path / "apksigner").is_file()
    ),
    key=lambda path: tuple(map(int, path.name.split("."))),
    default=None,
)
if tools is None:
    raise SystemExit("Android SDK build tools with aapt and apksigner are required.")

badging = subprocess.check_output([tools / "aapt", "dump", "badging", apk], text=True)
signature = subprocess.check_output(
    [tools / "apksigner", "verify", "--print-certs", apk], text=True
)
package = re.search(
    r"^package: name='([^']+)' versionCode='(\d+)' versionName='([^']+)'",
    badging,
    re.MULTILINE,
)
certificates = re.findall(r"certificate SHA-256 digest: ([0-9a-fA-F]{64})", signature)
if not package or package[1] != "com.wonkrumdm" or int(package[2]) < 1:
    raise SystemExit("Expected a versioned com.wonkrumdm APK.")
if len(certificates) != 1 or "CN=Android Debug" in signature:
    raise SystemExit("Expected a release APK with one non-debug signing certificate.")

def sdk_version(field):
    match = re.search(rf"^{field}:'(\d+)'", badging, re.MULTILINE)
    return int(match[1]) if match else None

digest = hashlib.sha256()
with apk.open("rb") as source:
    for chunk in iter(lambda: source.read(1024 * 1024), b""):
        digest.update(chunk)
metadata = {
    "packageName": package[1],
    "versionCode": int(package[2]),
    "versionName": package[3],
    "minSdkVersion": sdk_version("sdkVersion"),
    "targetSdkVersion": sdk_version("targetSdkVersion"),
    "certificateSha256": certificates[0].lower(),
    "sha256": digest.hexdigest(),
}
assets.mkdir(parents=True, exist_ok=True)
with tempfile.TemporaryDirectory(dir=assets) as staging:
    staging = Path(staging)
    shutil.copyfile(apk, staging / "wonkru-mdm.apk")
    (staging / "wonkru-mdm-apk.json").write_text(
        json.dumps(metadata, indent=2) + "\n", encoding="utf-8"
    )
    for name in ("wonkru-mdm.apk", "wonkru-mdm-apk.json"):
        os.replace(staging / name, assets / name)
print(f"Prepared Wonkru MDM {package[3]} ({package[2]}) in {assets}")
PY
