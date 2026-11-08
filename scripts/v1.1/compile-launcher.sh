#!/system/bin/sh
# Targeted experiment retained after a short transition comparison.
set -eu
case "$(getprop ro.bootloader)" in G955F*) ;; *) exit 1;; esac
cmd package compile -m speed -f com.android.launcher
# The next normal launcher restart/reboot loads the generated code.
pm art dump com.android.launcher
