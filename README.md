# HackiGalaxy

iOS (XNU) (experimental) for Samsung Galaxy devices.

> ## ⚠️ EXPERIMENTAL — TRY AT YOUR OWN RISK
> This is early code, **not a usable ROM**. It can brick your phone, erase `userdata`, trip Knox (permanently, on most devices) and void your warranty. It has **not been booted on any Galaxy yet**. Back up everything. You are fully responsible for what you flash.

## What this is
A Galaxy adaptation of [ios-sweet](https://github.com/dipa-studio/ios-sweet) (Apple XNU port + boot shim, originally for Redmi Note 10 Pro).

- `shim/` – bare-metal boot shim (GICv3, UFS, framebuffer console, XNU loader). Hardware addresses now come from `devices/<codename>/device.h` instead of being hard-coded for `sweet`.
- `platform/` + `objectives/` – SoC and per-device profiles (ArcadeX layout), turned into `shim/device.h` by `build.sh`. `r0q` (Galaxy S22) and `g0q` (Galaxy S22+), both Snapdragon 8 Gen 1 (SM8450). `template` is for new devices.
- `xnu/`, `tools/` – kernel patches and root/payload tooling from ios-sweet (still target `sweet`'s machine config; they need the same port for each SoC).
- `tools/galaxy-probe.sh` – run on the phone under Android (root) to dump the addresses needed for `device.h`.

## Build
```
sudo apt install gcc-aarch64-linux-gnu cpio   # mkbootimg.py is vendored in tools/mkbootimg/ (AOSP)
./build.sh r0q   # or g0q   [xnu-payload.bin]
```
Outputs `out/<device>/Image` (and `boot.img` + `AP_*.tar.md5` if `mkbootimg` is installed).

## Status
| Item | State |
| --- | --- |
| Shim builds for r0q / g0q | ✅ compiles |
| UFS / GIC / IMEM addresses | ✅ match mainline sm8450.dtsi; ❌ framebuffer + PSHOLD still guessed |
| Boot via `fastboot boot` (header v4) | ❌ untested |
| XNU for SM8450 | ❌ see `xnu/galaxy/PORTING.md` (overlay script untested) |
| iOS userland | ❌ not included; you must supply your own legally obtained files |
| GPU, Wi-Fi, modem, Knox | ❌ none |


## Notes
- Needs an unlocked bootloader (Knox trips). `fastboot` / `adb sideload` work as on Xiaomi.
- No Apple binaries are distributed. XNU is under Apple's APSL; check each upstream's license before redistributing.

## Tools
- `tools/fetch-iphonex.py` – fetches only the needed files (OS + cryptex DMGs, DeviceTree) from the iPhone X IPSW (default 16.7.16 / 20H392) via range requests. Untested here (no access to ipsw.me from my sandbox).
- `./booter.sh boot r0q` – RAM-boot the built image with `fastboot boot`; `root` flashes the iOS root to userdata (wipes Android).
- `xnu/galaxy/` – SM8450 overlay + porting checklist.
