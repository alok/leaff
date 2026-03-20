#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

output="$(./runleaff.sh Test.Test test test2)"
printf '%s\n' "$output"

grep -Fqx 'Found differences:' <<<"$output"
grep -Fqx '@@ Test.Test @@' <<<"$output"
grep -Fqx '+ added sada' <<<"$output"
grep -Fqx '! defToLemma changed from def to thm' <<<"$output"
grep -Fqx '! renamed bloop1 → bloop2' <<<"$output"
grep -Fqx '! renamed bloop → b' <<<"$output"
grep -Fqx '! proof changed for c' <<<"$output"

if grep -Fq 'collision when hashing' <<<"$output"; then
  echo "unexpected hash-collision debug output in sample diff" >&2
  exit 1
fi
