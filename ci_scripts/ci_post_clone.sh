#!/bin/sh

set -eu

REPO_ROOT="${CI_WORKSPACE:-$(cd "$(dirname "$0")/.." && pwd)}"
CONFIG_DIR="$REPO_ROOT/Saion/Resource"

require_env() {
  name="$1"
  value="$(printenv "$name" || true)"

  if [ -z "$value" ]; then
    echo "error: Missing required environment variable: $name" >&2
    exit 1
  fi

  printf "%s" "$value"
}

escape_xcconfig_value() {
  printf "%s" "$1" | sed "s,://,:/\$()/,g"
}

BASE_URL_VALUE="$(escape_xcconfig_value "$(require_env BASE_URL)")"
KAKAO_NATIVE_APP_KEY_VALUE="$(require_env KAKAO_NATIVE_APP_KEY)"

mkdir -p "$CONFIG_DIR"

for config in ConfigDebug.xcconfig ConfigRelease.xcconfig; do
  {
    echo "BASE_URL = $BASE_URL_VALUE"
    echo "KAKAO_NATIVE_APP_KEY = $KAKAO_NATIVE_APP_KEY_VALUE"
  } > "$CONFIG_DIR/$config"
done
