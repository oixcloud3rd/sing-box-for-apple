#!/bin/bash
set -euo pipefail

if [[ -z "${DEVELOPMENT_TEAM:-}" ]]; then
	echo "error: DEVELOPMENT_TEAM is missing; configure Configuration/Signing.xcconfig" >&2
	exit 1
fi

source_plist="${SCRIPT_INPUT_FILE_0}"
destination_plist="${SCRIPT_OUTPUT_FILE_0}"
mach_service_name="${DEVELOPMENT_TEAM}.${BASE_PACKAGE_IDENTIFIER}.helper"

mkdir -p "$(dirname "${destination_plist}")"
cp "${source_plist}" "${destination_plist}"
/usr/libexec/PlistBuddy -c "Delete :MachServices" "${destination_plist}"
/usr/libexec/PlistBuddy -c "Add :MachServices dict" "${destination_plist}"
/usr/libexec/PlistBuddy -c "Add :MachServices:${mach_service_name} bool true" "${destination_plist}"
