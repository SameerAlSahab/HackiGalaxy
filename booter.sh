#!/bin/bash
# HackiGalaxy booter.  Needs unlocked bootloader. Samsung fastboot/adb as on Xiaomi.
#   ./booter.sh boot <codename>              RAM-boot out/<codename>/boot.img (nothing flashed)
#   ./booter.sh root <root.img> --i-have-backups   flash the iOS root to userdata (ERASES Android data)
#   ./booter.sh sideload <zip>               adb sideload a recovery zip
#   ./booter.sh backup                       pull partition list + warn; back up with your own tool first
set -euo pipefail; cd "$(dirname "$0")"
echo "!! HackiGalaxy is EXPERIMENTAL - you do this at your own risk (bricks, data loss, Knox)."
case "${1:-}" in
 boot) img=out/${2:?codename}/boot.img; [ -f $img ] || { echo "build first: ./build.sh $2"; exit 1; }
       adb reboot bootloader 2>/dev/null || true; fastboot devices | grep -q . || { echo "no fastboot device"; exit 1; }
       fastboot boot $img ;;
 root) [ -f "${2:?root.img}" ] && [ "${3:-}" = "--i-have-backups" ] || { echo "need root.img and --i-have-backups"; exit 1; }
       read -rp "Type ERASE to wipe userdata: " a; [ "$a" = ERASE ]; fastboot flash userdata "$2" ;;
 sideload) adb sideload "${2:?zip}" ;;
 backup) adb shell 'ls -l /dev/block/by-name' ; echo "Back up efs, modem, persist, boot, vendor_boot, userdata yourself before flashing." ;;
 *) sed -n '2,7p' "$0"; exit 1 ;;
esac
