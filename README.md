# colorfulgalaxy — ColorOS 16 for Samsung Galaxy S8+

Experimental ColorOS 16 port for the European Exynos Galaxy S8+ (SM-G955F / dream2lte).

## Status
Version **v1** successfully boots on the owner's phone, confirmed 7 November 2026. Other hardware functions and smoothness still need testing. The next version is **v1.1**.

## v1 composition
- System, vendor and product: user-supplied ColorOS_16.0.4_8895_v2 donor.
- Kernel and hardware description: hlong kernel_20260804-1643-dream2lte.img.
- Startup files: ColorOS donor ramdisk, with dream2lte boot command line.
- System partition: 13500 MiB. Installed using a clean data format.
- Supplied battery and OTA patches have not been applied.

This repository tracks project notes and preparation scripts. Proprietary firmware images, ROM archives, account data and device-specific backups are excluded. No downloadable ROM release is included.

## Local preparation layout
The scripts expect source/ for the supplied kernel and donor archives, work/donor/ for extracted boot/system/vendor/product images, reports/ for manifests, and output/ for generated files. Run from the project root using Python. Inputs are not distributed here; obtain them from their original maintainers.

## Credits
ColorOS/OPPO and Samsung for original firmware components; MakrSus and the ColorOS S8 port maintainers for the supplied donor; hlong/UN1GAGA and upstream UN1CA contributors for the kernel and hardware base. This is an unofficial personal porting project. Firmware/component rights remain with their respective owners. No new license is asserted over upstream material.

## Continuing work
Preserve v1 as the booting baseline. Record future fixes and validation in CHANGELOG.md under v1.1, with one focused commit per change. Start with the owner's observed issues; do not assume untested features work.

## Installation status
The included installer is experimental and destructive when invoked: it writes boot, system, vendor and product. It does not repartition or format storage. There is no general installation guide yet. The already-flashed development phone has the required custom layout; do not rerun a repartitioner on it casually.
