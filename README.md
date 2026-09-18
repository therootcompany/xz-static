# XZ Utils (mirror + builds)

This is a mirror of `xz` for the purpose of publishing standalone, static builds
and fulfilling the responsibility to provide access to the corresponding source code.

# Install (xz + unxz)

[Webi](https://webinstall.dev) installs `xz` and `unxz` to `~/.local/bin/` (adding it to your PATH if it is not present)
and does not modify system settings or require sudo / Admin privileges. See [webinstall.dev/xz](https://webinstall.dev/xz).

Mac, Linux:

```sh
curl -sS https://webi.sh/xz | sh
```

Windows 10:

```sh
curl.exe -A MS https://webi.ms/xz | powershell
```

# Manual Install

If you install manually you need to update your `PATH` or install into a system location.

Mac:

```sh
b_ver="5.8.4"
curl -L -o ./xz-"${b_ver}".tar.gz https://github.com/therootcompany/xz-static/releases/download/v"${b_ver}"/xz-"${b_ver}"-darwin-x86_64.tar.gz
tar xvf ./xz-"${b_ver}".tar.gz

sudo mv xz-*/*xz /usr/local/bin/
```

Linux:

```sh
b_ver="5.8.4"
curl -L -o ./xz-"${b_ver}".tar.gz https://github.com/therootcompany/xz-static/releases/download/v"${b_ver}"/xz-"${b_ver}"-linux-x86_64.tar.gz
tar xvf ./xz-"${b_ver}".tar.gz

sudo mv ./xz-*/*xz /usr/local/bin/
```

Windows 10:

The release republishes the upstream Windows build as two architecture-specific
archives with unambiguous names:

```powershell
curl.exe -o xz-5.8.4-windows-amd64.zip https://github.com/therootcompany/xz-static/releases/download/v5.8.4/xz-5.8.4-windows-amd64.zip
mkdir xz-5.8.4
pushd xz-5.8.4
tar.exe xvf ../xz-5.8.4-windows-amd64.zip
move bin_x86-64\xz.exe ..\
move bin_x86-64\xzdec.exe ..\unxz.exe
```

The matching `xz-5.8.4-windows-i686.zip` archive contains `bin_i686-sse2/`.
Both archives include the matching `liblzma.dll` and `include/lzma.h` headers.

You then need to move `xz.exe` and `unxz.exe` from the Downloads folder to a folder in your PATH, such as `C:\`

```powershell
move %UserProfile%\Downloads\xz.exe  %SystemRoot%\
move %UserProfile%\Downloads\unxz.exe  %SystemRoot%\
```

# Release Build Process

Release `v5.8.4` contains binaries for macOS Intel/arm64, Alpine Linux
amd64/arm64, and Windows amd64/i686. POSIX archives also contain the PIC static
`liblzma.a`, headers, and `liblzma.pc` for consumers such as Python. Windows
archives include the matching `liblzma.dll` and public headers.

Build the Linux targets in Alpine containers:

```sh
# arm64 on Apple Silicon
container run --arch arm64 alpine:3.22 ...

# amd64 on Apple Silicon (requires Rosetta)
container run --arch amd64 --rosetta alpine:3.22 ...
```

Use these configure/build options for a POSIX target:

```sh
CFLAGS=-fPIC ./configure --disable-shared --enable-static --disable-nls --disable-doc
make LDFLAGS=-all-static
make DESTDIR=/stage install
```

Build macOS Intel with Xcode using `-arch x86_64 -mmacosx-version-min=10.15`.
Build macOS arm64 with `-arch arm64 -mmacosx-version-min=11.0`.

Repackage the upstream Windows archive into clean, architecture-specific ZIPs:

```sh
scripts/repackage-windows.sh 5.8.4 xz-5.8.4-windows.zip release/
```

The script produces `xz-5.8.4-windows-amd64.zip` and
`xz-5.8.4-windows-i686.zip`, each containing only `bin/` and `include/`.

The source archive is generated from the same `xz-static` commit as the binary
artifacts. `checksums.txt` covers every release asset.

# Original Source

Aside from this README.md,
this repository is an identical mirror of the official repository,
which can be found at:

```sh
git clone https://git.tukaani.org/xz.git
```

This repo can be cleanly rebased to make up-to-date with the original, like so:

```sh
git fetch https://git.tukaani.org/xz.git
git pull --rebase https://git.tukaani.org/xz.git master
```

# License

The distributable code is licensed LGPLv2.1+ (**commercially safe** and NOT copyleft restricted at the project level).

The Mac and Linux builds here **DO NOT** contain any GPL code.

Furthermore, since these are static builds, the restrictions that apply to shared libraries and linked code do not apply.

Some of the build process and scripts are GPL-licensed, but they are not included in the distributable `tar` files.
