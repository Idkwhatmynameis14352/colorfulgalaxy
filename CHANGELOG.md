# Changelog

## v1.1 — Unreleased
- Reserved for the next smoothing and bug-fix session.
- No changes implemented yet.

## v1 — 2026-11-07
- Prepared an S8+ boot candidate using hlong's dream2lte kernel and hardware description with the ColorOS donor startup files.
- Packaged the donor system, vendor and product with the adapted boot image.
- Added target-model, capacity, mount-state and staged-image checks to the experimental installer.
- Backed up device-specific partitions privately, enlarged system to 13500 MiB, formatted internal storage, and restored moved Samsung partitions.
- Flashed system/vendor/product/boot, prepared cache and started the first boot.
- Owner confirmed successful boot. Other features remain untested.
- Saved the exact installed build locally in versions/v1.
