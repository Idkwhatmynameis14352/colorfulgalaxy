Active version: v1.1 (in testing). Preserve the original v1 snapshot.

Read CHANGELOG.md and docs/v1.1.md. Retained changes: reversible OPPO OTA isolation, missing keyboard selection repair, targeted launcher AOT compilation. Settings AOT experiment was reverted. Reboot and keyboard persistence passed. Hardware acceleration/HWC are active. No graphics flags, animation scales, CPU frequency, thermal or memory settings changed; no unrelated services removed.

Next: collect owner feedback on keyboard across apps/password fields, real home/app transitions, camera/audio, Wi-Fi, SIM calls/data, suspend and longer-session temperatures. Current short transition test improved but still shows stutter. Do not call this daily-use stable yet. The phone had no SIM during diagnostics.

Use focused measurements and incremental changes. Avoid repeated large hashes, noisy polling and unnecessary updates. Do not publish raw diagnostics, user data, firmware or device backups.
