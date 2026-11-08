"""Package the experimental candidate locally. Does not contact the phone."""
import hashlib
import json
import pathlib
import zipfile

root = pathlib.Path(__file__).resolve().parents[1]
paths = {name: root / f'work/donor/{name}.img' for name in ('system','vendor','product')}
paths['boot'] = root / 'output/UNTESTED-dream2lte-coloros16-boot.img'
expected = {'system':8913391616, 'vendor':629145600, 'product':943718400, 'boot':36126736}
for name, path in paths.items():
    if path.stat().st_size != expected[name]:
        raise ValueError(f'{name}: extraction incomplete or input changed')
script = (root/'scripts/alpha-update-binary.sh').read_text()
for name, size in expected.items():
    script = script.replace('@'+name.upper()+'_BYTES@', str(size))
script = script.replace('@STAGING_KIB@',str((sum(expected.values())+1023)//1024+524288))
notes = '''EXPERIMENTAL FIRST-BOOT CANDIDATE — NOT A FINISHED PORT
Target: SM-G955F / dream2lte only.
ColorOS donor: ColorOS_16.0.4_8895_v2.zip supplied by user.
Kernel/DTB: hlong kernel_20260804-1643-dream2lte.img.
Startup files: original ColorOS donor ramdisk.
System, vendor and product: unchanged donor images.
Vendor model identifiers remain dreamlte. Device-specific blobs are NOT validated.
Camera, radio/calls, display, touch, charging, sensors, NFC and security behavior untested.
Battery and OTA patches are NOT integrated.
Installer checks model, partition capacity, mount state and image hashes before writing.
Does NOT repartition, format data, install recovery or reboot.
Current inspected phone layout has a 6500 MiB system partition and is too small.
Do not repartition or flash until the test plan and recovery backups are ready.
No claim of near-native functionality or successful boot is made.
'''
output=root/'output/ColorOS16-dream2lte-EXPERIMENTAL-alpha0.zip'
hashes={}
with zipfile.ZipFile(output,'w',compression=zipfile.ZIP_STORED,allowZip64=True) as z:
    for name,path in paths.items():
        h=hashlib.sha256()
        with path.open('rb') as src,z.open(f'images/{name}.img','w',force_zip64=True) as dst:
            while chunk:=src.read(8*1024*1024):
                h.update(chunk);dst.write(chunk)
        hashes[name]=h.hexdigest()
        print('Packaged',name,flush=True)
    z.writestr('SHA256SUMS',''.join(f'{h}  images/{n}.img\n' for n,h in hashes.items()))
    z.writestr('META-INF/com/google/android/update-binary',script)
    z.writestr('META-INF/com/google/android/updater-script','# logic in update-binary\n')
    z.writestr('READ-ME-FIRST.txt',notes)
(root/'output/READ-ME-FIRST.txt').write_text(notes)
(root/'reports/alpha-manifest.json').write_text(json.dumps({'images':hashes,'sizes':expected,'status':'UNTESTED'},indent=2))
print('Written',output,flush=True)
