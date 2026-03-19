
#!/usr/bin/env bash

set -euo pipefail

# this script is used to run Leaff on a pair of directories

# usage: runleaff.sh module olddir newdir

# module is the module to run Leaff on
# olddir and newdir are the directories to run Leaff on
# olddir is the directory with the old project
# newdir is the directory with the new project

# example: runleaff.sh Mathlib ../test-mathlib/ ../test-mathlib2/

if [ $# -ne 3 ]; then
	echo "usage: runleaff.sh module olddir newdir"
	exit 1
fi

module="$1"
olddir="$2"
newdir="$3"

# Build the requested module in each checkout so the necessary oleans exist.
lake --dir "$olddir" build "$module" >/dev/null
lake --dir "$newdir" build "$module" >/dev/null

old_lean_path="$(lake --dir "$olddir" env printenv LEAN_PATH)"
new_lean_path="$(lake --dir "$newdir" env printenv LEAN_PATH)"

lake exe leaff \
	"$module" \
	"$(tr ':' ',' <<<"$old_lean_path")" \
	"$(tr ':' ',' <<<"$new_lean_path")"
