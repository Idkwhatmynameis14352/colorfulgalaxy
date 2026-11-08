#!/system/bin/sh
# Development rollback only. Restores incompatible OPPO updater components.
set -eu
case "$(getprop ro.bootloader)" in G955F*) ;; *) exit 1;; esac
mount -o remount,rw /
trap 'sync; mount -o remount,ro /' EXIT
for path in \
 /system/system_ext/etc/init/cotad.rc \
 /system/system_ext/bin/cotad \
 /system/system_ext/bin/bspFwUpdate \
 /system/system_ext/app/OTA/OTA.apk \
 /system/system_ext/app/SystemAppUpdateService/SystemAppUpdateService.apk \
 /system/system_ext/app/SAUHelper/SAUHelper.apk; do
    [ ! -e "$path.disabled-v1.1" ] || mv "$path.disabled-v1.1" "$path"
done
echo 'Files restored. Reboot, then restore package enable states if required.'
