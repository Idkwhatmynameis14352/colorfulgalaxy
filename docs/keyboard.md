# Keyboard selection repair — v1.1

Observed intermittent missing keyboard and an empty default_input_method / enabled_input_methods setting while Sogou was installed. Restored com.sohu.inputmethod.sogouoem/.SogouIME using Android input-method commands. OPPO security keyboard remains installed.

The keyboard appeared in three consecutive Settings-search tests and again after reboot; selection persisted. This fixes the observed missing selection, not every possible IME issue. Test other apps and password fields before declaring the intermittent issue resolved.

restore-keyboard-selection.sh repairs only an empty selection and preserves an existing user choice. Original settings are saved privately in the development workspace for rollback.
