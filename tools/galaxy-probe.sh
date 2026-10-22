#!/system/bin/sh
# Run on the Galaxy under Android (root/adb shell). Prints hardware facts needed for devices/<codename>/device.h
D=/proc/device-tree; [ -d $D ] || D=/sys/firmware/devicetree/base
hx(){ od -An -tx1 -v "$1" 2>/dev/null | tr -d ' \n'; echo; }
echo "model: $(cat $D/model 2>/dev/null)  codename: $(getprop ro.product.device)"
for n in $(ls $D/soc | grep -E '^(ufshc|interrupt-controller|qcom,msm-imem|reset|restart)'); do echo "[$n] reg=$(hx $D/soc/$n/reg)"; done
echo "[fb] $(wm size 2>/dev/null)"; grep -iE 'splash|framebuffer|display' /proc/iomem 2>/dev/null
echo "[ddr]"; grep -i 'system ram' /proc/iomem
echo "[boot] $(getprop ro.boot.bootloader) hdr=$(getprop ro.boot.vbmeta.device_state)"
