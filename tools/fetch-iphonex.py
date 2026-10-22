#!/usr/bin/env python3
"""Download only what HackiGalaxy needs from Apple's iPhone X (iPhone10,3 / 10,6) IPSW,
via HTTP range requests (tools/remotezip.py) - the multi-GB IPSW is never saved whole.
  fetch-iphonex.py [--build 20H392] [--model iPhone10,3] [--out ipsw-x]
Pulls: BuildManifest.plist, OS dmg, SystemOS + AppOS cryptex dmgs, DeviceTree (d22ap).
For personal use; do not redistribute Apple files. Then: tools/mkiosroot.sh OS SYSTEMOS APPOS out.img"""
import argparse, json, os, plistlib, subprocess, sys, urllib.request
ap = argparse.ArgumentParser()
ap.add_argument('--build', default='20H392'); ap.add_argument('--model', default='iPhone10,3')
ap.add_argument('--out', default='ipsw-x'); a = ap.parse_args()
here = os.path.dirname(os.path.abspath(__file__))
rz = lambda url, pat: subprocess.run([sys.executable, f'{here}/remotezip.py', url, pat, a.out], check=True)
info = json.load(urllib.request.urlopen(f'https://api.ipsw.me/v4/device/{a.model}?type=ipsw'))
fw = [f for f in info['firmwares'] if f['buildid'] == a.build]
if not fw: sys.exit(f"build {a.build} not listed for {a.model}; available 16.x: " +
                    ', '.join(f['buildid'] for f in info['firmwares'] if f['version'].startswith('16.')))
url = fw[0]['url']; print('IPSW:', url, fw[0]['version'])
os.makedirs(a.out, exist_ok=True)
rz(url, 'BuildManifest.plist')
bm = plistlib.load(open(f'{a.out}/BuildManifest.plist', 'rb'))
m = bm['BuildIdentities'][0]['Manifest']
for key in ('OS', 'Cryptex1,SystemOS', 'Cryptex1,AppOS'):
    p = m[key]['Info']['Path']; print('->', key, p); rz(url, p)
rz(url, 'DeviceTree.d22ap.im4p')
print('done. Next: tools/mkiosroot.sh', *[f"{a.out}/{m[k]['Info']['Path']}" for k in ('OS','Cryptex1,SystemOS','Cryptex1,AppOS')], 'root.img')
