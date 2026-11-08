#!/system/bin/sh
# Reversible v1.1 OTA isolation. No firmware package is installed.
set -eu
case "$(getprop ro.bootloader)" in G955F*) ;; *) echo 'Wrong target'; exit 1;; esac
for pkg in com.oplus.ota com.oplus.sau com.oplus.sauhelper; do
    if pm path "$pkg" 2>/dev/null | grep -q "^package:"; then
        pm disable-user --user 0 "$pkg"
        am force-stop --user 0 "$pkg"
    fi
done
# These are the exact updater paths inspected on this donor. A suffix leaves
# originals intact while preventing APK discovery and init service loading.
mount -o remount,rw /
trap 'sync; mount -o remount,ro /' EXIT
[ "$(getprop init.svc.cotad)" != running ] || stop cotad
[ "$(getprop init.svc.cotad-boot)" != running ] || stop cotad-boot
for path in \
 /system/system_ext/etc/init/cotad.rc \
 /system/system_ext/bin/cotad \
 /system/system_ext/bin/bspFwUpdate \
 /system/system_ext/app/OTA/OTA.apk \
 /system/system_ext/app/SystemAppUpdateService/SystemAppUpdateService.apk \
 /system/system_ext/app/SAUHelper/SAUHelper.apk; do
    if [ -f "$path" ] && [ ! -e "$path.disabled-v1.1" ]; then
        mv "$path" "$path.disabled-v1.1"
        echo "Isolated $path"
    elif [ ! -e "$path.disabled-v1.1" ]; then
        echo "Missing expected file: $path"; exit 1
    fi
done
echo 'OPPO OTA packages and native update entry points isolated.'
