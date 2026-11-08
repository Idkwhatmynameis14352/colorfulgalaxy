# OPPO OTA isolation — v1.1

The official OPPO firmware is incompatible with this Samsung port. The owner requested disabling its updater and background checks.

Applied disable-oppo-ota.sh on the rooted development device. It disables OTA/SAU/SAUHelper for user 0, stops cotad, and reversibly isolates their three APKs, cotad, bspFwUpdate and cotad.rc using .disabled-v1.1 suffixes. It returns the system mount to read-only. Original files stay intact for development rollback.

After reboot, none of the three packages is discoverable, cotad has no loaded service, and no OTA/SAU jobs were found. No official OTA was installed. This block must be preserved in future ROM builds; reflashing an unpatched image can restore the updater.

restore-oppo-ota.sh is a development rollback script, not a normal-user recommendation: it restores the incompatible updater files and requires a reboot plus package-state restoration if needed.
