# Snapdragon 8 Gen 1 (SM8450 "waipio") - S22 / S22+. Values from mainline sm8450.dtsi
# (UFS, GIC, IMEM verified there); PSHOLD and FB marked VERIFY: confirm with tools/galaxy-probe.sh.
SOC=sm8450
UFS_BASE=0x01d84000UL
GICD_BASE=0x17100000UL
GICR_BASE=0x17180000UL
GICR_SIZE=0x200000UL
GICR_PE_SIZE=0x40000UL          # redistributor-stride in DT
IMEM_RESTART_REASON=0x146aa65cUL # sram@146aa000 + 0x65c
PSHOLD=0x0c264000UL             # VERIFY
CPUS="1x Cortex-X2 + 3x A710 + 4x A510"
