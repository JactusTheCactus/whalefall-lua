#!/usr/bin/env bash
set -euo pipefail
exec > README.md
echo Thoughts?
declare -A files
files[.sh]=sh
files[Makefile]=makefile
files[data.env]=env
FILES=(
	data.env
	.sh
	Makefile
)
for i in "${FILES[@]}"
	do printf '# `%s`\n```%s\n%s\n```\n' \
		"$i" \
		"${files[$i]}" \
		"$(<$i)"
done
