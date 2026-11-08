#!/sbin/sh
# Experimental first-boot package. No repartitioning or formatting.
OUTFD=$2
ZIP=$3
ui_print() { printf 'ui_print %s\nui_print\n' "$1" > /proc/self/fd/"$OUTFD"; }
abort() { ui_print "ABORT: $1"; exit 1; }
ui_print 'ColorOS 16 / SM-G955F experimental alpha 0'
ui_print 'Not validated for daily use. Hardware compatibility remains untested.'
case "$(getprop ro.bootloader)" in G955F*) ;; *) abort 'Only SM-G955F bootloaders accepted';; esac
case "$(getprop ro.product.device)" in dream2lte) ;; *) abort 'Recovery must identify dream2lte';; esac
for tool in unzip sha256sum blockdev dd awk df readlink; do
    command -v "$tool" >/dev/null 2>&1 || abort "Missing tool: $tool"
done
BASE=/dev/block/platform/11120000.ufs/by-name
check_size() {
    [ -b "$BASE/$1" ] || abort "Missing partition: $1"
    size=$(blockdev --getsize64 "$BASE/$1") || abort 'Cannot read partition size'
    [ "$size" -ge "$2" ] || abort "$1 too small; no partitions have been written"
}
check_size BOOT @BOOT_BYTES@
check_size SYSTEM @SYSTEM_BYTES@
check_size VENDOR @VENDOR_BYTES@
check_size PRODUCT @PRODUCT_BYTES@
# Fail if any target is mounted, including aliases.
for label in BOOT SYSTEM VENDOR PRODUCT; do
    target=$(readlink -f "$BASE/$label") || abort 'Cannot resolve target'
    while read -r src mountpoint rest; do
        resolved=$(readlink -f "$src" 2>/dev/null)
        [ "$resolved" != "$target" ] || abort "$label is mounted; unmount it in recovery"
    done < /proc/mounts
done
awk '$2=="/data" {found=1} END {exit !found}' /proc/mounts || abort '/data must be mounted'
free=$(df -Pk /data | awk 'END {print $4}')
[ "$free" -ge @STAGING_KIB@ ] || abort 'Insufficient space to stage and verify all four images'
WORK=/data/local/tmp/coloros-dream2lte-alpha0
[ ! -e "$WORK" ] || abort 'Previous staging folder exists; inspect it before retrying'
mkdir -p "$WORK" || abort 'Cannot create staging folder'
ui_print 'Extracting and verifying all images before partition writes'
unzip -o "$ZIP" 'images/*' 'SHA256SUMS' -d "$WORK" >/dev/null 2>&1 || abort 'Extraction failed; no writes performed'
cd "$WORK" || abort 'Cannot access staging folder'
sha256sum -c SHA256SUMS >/dev/null 2>&1 || abort 'Image checksum failed; no writes performed'
ui_print 'Writing verified images; keep USB and power connected'
# Write boot last so a preceding failure leaves the old boot image intact.
for pair in system:SYSTEM vendor:VENDOR product:PRODUCT boot:BOOT; do
    name=${pair%%:*}
    label=${pair##*:}
    ui_print "Writing $label"
    dd if="images/$name.img" of="$BASE/$label" bs=4194304 conv=fsync || abort "Write failed for $label; remain in recovery"
done
sync
ui_print 'Images written. No data formatting or reboot was performed.'
ui_print 'Staged images retained for inspection. Boot and hardware remain untested.'
exit 0
