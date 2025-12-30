## Tickrate Enabler for TF2

### Description

A simple Valve Server Plugin (VSP) that enables the "-tickrate" switch to be used from the command line to set the TF2 server's tickrate.

This is a standalone VSP and does not require SourceMod or any other dependencies.

### Building

#### Requirements
- AMBuild 2.2+
- Metamod:Source
- HL2SDK for TF2

#### Docker Build
```bash
docker build -t tickrate-enabler .
docker run --rm tickrate-enabler cat /app/TickrateEnabler-linux.zip > TickrateEnabler-linux.zip
```

#### Manual Build
```bash
mkdir build && cd build
python3 ../configure.py --enable-optimize --hl2sdk-manifest-path=/path/to/hl2sdk-manifests --mms-path=/path/to/metamod-source --targets=x86
ambuild
```

### Installation

1. Place `tickrate_enabler.so` (Linux) or `tickrate_enabler.dll` (Windows) in your server's `addons/tickrate_enabler` folder.
2. Place `tickrate_enabler.vdf` in your server's `addons` folder.
3. Add `-tickrate <desired_tickrate>` to your server's launch parameters, e.g., `-tickrate 100`
4. Set the following convar settings in server.cfg:
   ```
   sv_maxupdaterate 100  
   sv_maxcmdrate 100
   ```

### Credits

Parts of this project contain GPLv3 code adapted from SourceMod (Allied Modders L.L.C.) and Tickrate Enabler for L4D/L4D2 (Michael "ProdigySim" Busby).
