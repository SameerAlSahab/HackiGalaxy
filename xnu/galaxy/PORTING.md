# SM8450 (S22/S22+) vs sweet (SM7150) - what must change in the XNU patches
| Area | sweet | SM8450 | Patch to adapt |
| --- | --- | --- | --- |
| CPU/SMP | 6x A55 via PSCI | 1xX2+3xA710+4xA510, PSCI | 0018, 0065, 0078 |
| GIC | v3 @17a00000 | v3 @17100000, stride 0x40000 | 0016, 0017 (virt timer IRQ) |
| UFS | host @1d84000 | same base, newer HCI/PHY (Gear4/5) | 0028, 0030, 0034, 0069 |
| Display | simple FB 1080x2400 | Samsung FB, 1080x2340 | 0003, 0010, 0046, 0056, 0079 |
| Touch | Goodix over GENI | Samsung/STM touch, different bus | 0060, 0062, 0063, 0071 |
| USB | DWC3 | DWC3 (SM8450 uses QMP combo PHY) | 0072-0077, 0081 |
| Identity | "D22AP/xiaomi,sweet" | board-id/model for r0q/g0q | 0059, 0061, tools/mkadt.py |
Nothing above has been done yet; the shim is the only part that builds today.
