#!/bin/bash
# Galaxy overlay for the ios-sweet XNU tree. Usage: xnu/galaxy/apply.sh <xnu-tree> [sm8450]
# Approach: keep ARM64_BOARD_CONFIG_SWEET (all 81 patches in ../patches keep applying) and add
# -DGALAXY_SM8450 so Galaxy-specific code can be #if'd in. UNTESTED against a real xnu tree.
set -euo pipefail; T=${1:?xnu tree}; SOC=${2:-sm8450}; D=$(echo $SOC | tr a-z A-Z)
for p in "$(dirname "$0")"/../patches/*.patch; do git -C "$T" apply --check "$p" 2>/dev/null && git -C "$T" apply "$p" || echo "skip/fail: $p"; done
sed -i "s/^\(MACHINE_FLAGS_ARM64_SWEET *= *\)/\1-DGALAXY_$D /" "$T/makedefs/MakeInc.def"
grep -n "GALAXY_$D" "$T/makedefs/MakeInc.def"
