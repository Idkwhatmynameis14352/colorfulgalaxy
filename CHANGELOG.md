# Changelog

## v1.1 — Unreleased
- 2026-11-08: Investigated GPU/HWC, CPU scaling, temperatures, memory activity, ART state and keyboard selection before tuning.
- Disabled and reversibly isolated official OPPO OTA/COTA updater components; no official firmware flashed.
- Restored a missing default keyboard selection; passed three Settings-search appearances.
- Retained targeted launcher AOT compilation after an initial transition test improved; no graphics/animation, CPU-frequency, thermal or memory tuning applied.
- Reverted a Settings compilation experiment whose benefit was not reproducible.
- Added apply/rollback scripts and detailed measurements/limits in docs/v1.1.md.
- Daily-use validation remains in progress; v1 remains preserved.

## v1 — 2026-11-07
- Prepared an S8+ boot candidate using hlong's dream2lte kernel and hardware description with the ColorOS donor startup files.
- Packaged the donor system, vendor and product with the adapted boot image.
- Added target-model, capacity, mount-state and staged-image checks to the experimental installer.
- Backed up device-specific partitions privately, enlarged system to 13500 MiB, formatted internal storage, and restored moved Samsung partitions.
- Flashed system/vendor/product/boot, prepared cache and started the first boot.
- Owner confirmed successful boot. Other features remain untested.
- Saved the exact installed build locally in versions/v1.
