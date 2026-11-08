#!/system/bin/sh
# Repair an empty selection without replacing an existing user choice.
set -eu
current=$(settings --user 0 get secure default_input_method)
case "$current" in ""|null)
 ime enable --user 0 com.sohu.inputmethod.sogouoem/.SogouIME
 ime set --user 0 com.sohu.inputmethod.sogouoem/.SogouIME
 ;; *) echo "Existing keyboard selection retained";; esac
