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
grep -Fqx '! definition changed for c' <<<"$output"

if grep -Fq 'collision when hashing' <<<"$output"; then
  echo "unexpected hash-collision debug output in sample diff" >&2
  exit 1
fi

type_output="$(./runleaff.sh --printChangedTypes Test.TypeChange test test2)"
printf '%s\n' "$type_output"

grep -Fq '! type changed for foo' <<<"$type_output"
grep -Fq 'old: Nat' <<<"$type_output"
grep -Fq 'new: Int' <<<"$type_output"

proof_output="$(./runleaff.sh Test.ProofKinds test test2)"
printf '%s\n' "$proof_output"

grep -Fq '! definition changed for changedDef' <<<"$proof_output"
grep -Fq '! proof changed for changedProof' <<<"$proof_output"

hidden_output="$(./runleaff.sh --hideProofChanges Test.ProofKinds test test2)"
printf '%s\n' "$hidden_output"

grep -Fq '! definition changed for changedDef' <<<"$hidden_output"
if grep -Fq '! proof changed for changedProof' <<<"$hidden_output"; then
  echo "proof-change output was not hidden" >&2
  exit 1
fi
