#!/usr/bin/env bash
set -euo pipefail

mode="fast"
project_root="."
module="app"
variant="Debug"
serial=""
package_name=""

usage() {
  cat <<'EOF'
Usage: scripts/android_emulator_sync.sh [options]

Options:
  --mode fast|strict     Build mode. strict runs clean + assemble. (default: fast)
  --project-root PATH    Android project root that contains gradlew. (default: .)
  --module NAME          Gradle module name without leading colon. (default: app)
  --variant NAME         Build variant with case-sensitive suffix. (default: Debug)
  --serial ID            Emulator/device serial. Auto-detected when omitted.
  --package NAME         Optional applicationId for install verification.
  -h, --help             Show help.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode)
      mode="${2:-}"
      shift 2
      ;;
    --project-root)
      project_root="${2:-}"
      shift 2
      ;;
    --module)
      module="${2:-}"
      shift 2
      ;;
    --variant)
      variant="${2:-}"
      shift 2
      ;;
    --serial)
      serial="${2:-}"
      shift 2
      ;;
    --package)
      package_name="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ "$mode" != "fast" && "$mode" != "strict" ]]; then
  echo "Invalid --mode value: $mode (expected fast|strict)" >&2
  exit 1
fi

if ! command -v adb >/dev/null 2>&1; then
  echo "adb is required but not found in PATH." >&2
  exit 1
fi

gradlew="$project_root/gradlew"
if [[ ! -f "$gradlew" ]]; then
  echo "gradlew not found at: $gradlew" >&2
  exit 1
fi

if [[ ! -x "$gradlew" ]]; then
  chmod +x "$gradlew"
fi

module_task="${module#:}"
variant_lc="$(printf '%s' "$variant" | tr '[:upper:]' '[:lower:]')"
assemble_task=":${module_task}:assemble${variant}"

if [[ "$mode" == "strict" ]]; then
  "$gradlew" -p "$project_root" clean "$assemble_task"
else
  "$gradlew" -p "$project_root" "$assemble_task"
fi

module_dir="${module_task##*:}"
expected_apk="$project_root/$module_dir/build/outputs/apk/$variant_lc/${module_dir}-${variant_lc}.apk"
apk_path=""

if [[ -f "$expected_apk" ]]; then
  apk_path="$expected_apk"
else
  apk_path="$(find "$project_root" -type f -path "*/build/outputs/apk/*" -name "*.apk" | sort | tail -n 1)"
fi

if [[ -z "$apk_path" || ! -f "$apk_path" ]]; then
  echo "No APK found after build in $project_root." >&2
  exit 1
fi

if [[ -z "$serial" ]]; then
  serial="$(adb devices | awk '/^emulator-[0-9]+[[:space:]]+device$/{print $1; exit}')"
fi

if [[ -z "$serial" ]]; then
  echo "No running emulator found. Start an emulator or pass --serial." >&2
  exit 1
fi

adb -s "$serial" install -r "$apk_path"

if [[ -n "$package_name" ]]; then
  if ! adb -s "$serial" shell pm list packages | grep -Fq "package:$package_name"; then
    echo "Installed package could not be verified: $package_name" >&2
    exit 1
  fi
fi

echo "Mode: $mode"
echo "APK: $apk_path"
echo "Emulator: $serial"
if [[ -n "$package_name" ]]; then
  echo "Package verified: $package_name"
fi
