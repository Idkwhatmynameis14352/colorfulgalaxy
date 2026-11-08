"""Prepare an OFFLINE, UNTESTED legacy Samsung boot candidate. Never flashes."""
import hashlib
import json
import pathlib
import struct

ROOT = pathlib.Path(__file__).resolve().parents[1]

def split(path):
    data = path.read_bytes()
    if data[:8] != b'ANDROID!':
        raise ValueError('Not an Android boot image')
    fields = struct.unpack_from('<10I', data, 8)
    page = fields[7]
    if page != 2048 or fields[4] != 0:
        raise ValueError('Unexpected legacy boot layout')
    offset = page
    parts = []
    for size in (fields[0], fields[2], fields[4], fields[8]):
        part = data[offset:offset + size]
        if len(part) != size:
            raise ValueError('Truncated boot component')
        parts.append(part)
        offset += (size + page - 1) // page * page
    return data[:page], parts, data

donor = ROOT / 'work/donor/boot.img'
replacement = ROOT / 'source/kernel_20260804-1643-dream2lte.img'
header, donor_parts, donor_bytes = split(donor)
new_header, new_parts, replacement_bytes = split(replacement)
# Preserve replacement load addresses; retain donor OS metadata and startup files.
header = bytearray(new_header)
header[44:48] = donor_bytes[44:48]
parts = [new_parts[0], donor_parts[1], b'', new_parts[3]]
if b'\xd0\x0d\xfe\xed' not in parts[3] or b'dream2' not in parts[3].lower():
    raise ValueError('S8+ hardware description not identified')
cmdline = b'androidboot.hardware=samsungexynos8895 androidboot.device=dream2lte'
header[64:576] = cmdline.ljust(512, b'\0')
header[608:1632] = bytes(1024)
for offset, part in zip((8, 16, 24, 40), parts):
    struct.pack_into('<I', header, offset, len(part))
digest = hashlib.sha1()
for part in parts:
    digest.update(part)
    digest.update(struct.pack('<I', len(part)))
header[576:608] = digest.digest().ljust(32, b'\0')
image = bytes(header)
for part in parts:
    image += part + bytes((-len(part)) % 2048)
image += b'SEANDROIDENFORCE'
if len(image) > 40 * 1024 * 1024:
    raise ValueError('Candidate exceeds observed boot partition')
out = ROOT / 'output/UNTESTED-dream2lte-coloros16-boot.img'
out.write_bytes(image)
_, verified, _ = split(out)
assert verified == parts, 'Round-trip component verification failed'
report = {
    'status': 'OFFLINE ONLY: not boot-tested; vendor compatibility unverified',
    'candidate': out.name,
    'bytes': len(image),
    'sha256': hashlib.sha256(image).hexdigest(),
    'donor_sha256': hashlib.sha256(donor_bytes).hexdigest(),
    'replacement_sha256': hashlib.sha256(replacement_bytes).hexdigest(),
    'components': ['S8+ kernel', 'ColorOS donor ramdisk', 'empty second stage', 'S8+ DTB'],
    'limitations': ['Legacy boot ID regenerated; bootloader acceptance untested',
                    'Vendor modules, hardware services and system configuration still require inspection',
                    'No ROM installer built; no phone modifications performed'],
}
(ROOT / 'reports/boot-candidate.json').write_text(json.dumps(report, indent=2))
print(json.dumps(report, indent=2))
