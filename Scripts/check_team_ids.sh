#!/bin/bash
set -euo pipefail

allowed_team_id="TEAMID0000"
grep_mode=()

case "${1:-}" in
	"")
		;;
	--cached)
		grep_mode=(--cached)
		;;
	*)
		echo "usage: $0 [--cached]" >&2
		exit 2
		;;
esac

repository_root="$(git rev-parse --show-toplevel)"
cd "${repository_root}"

matches="$(
	git grep "${grep_mode[@]}" -nI -E \
		-e 'DEVELOPMENT_TEAM[[:space:]]*=[[:space:]]*"?[A-Z0-9]{10}"?[[:space:]]*;' \
		-e '<(key|string)>[A-Z0-9]{10}(\.|</(key|string)>)' \
		-- . 2>/dev/null || true
)"

violations="$(printf '%s\n' "${matches}" | grep -v "${allowed_team_id}" || true)"

if [[ -z "${violations}" ]]; then
	echo "Apple Team ID check passed."
	exit 0
fi

echo "error: Found a hard-coded Apple Team ID:" >&2
printf '%s\n' "${violations}" >&2
echo >&2
echo "Use ${allowed_team_id} for Jailbreak placeholders or DEVELOPMENT_TEAM from Configuration/Signing.xcconfig." >&2
exit 1
