# XZ Utils (mirror + builds)

This is a mirror of `xz` for the purpose of publishing standalone, static builds
and fulfilling the responsibility to provide access to the corresponding source code.

# Install (xz + unxz)

[Webi](https://webinstall.dev) installs `xz` and `unxz` to `~/.local/bin/` (adding it to your PATH if it is not present)
and does not modify system settings or require sudo / Admin privileges. See [webinstall.dev/xz](https://webinstall.dev/xz).

Mac, Linux:

```bash
curl -sS https://webinstall.dev/xz | bash
```

Windows 10:

```bash
curl.exe -A MS https://webinstall.dev/xz | powershell
```

# Manual Install

If you install manually you need to update your `PATH` or install into a system location.

Mac:

```bash
curl -L -o xz-5.2.5.tar.gz https://github.com/therootcompany/xz-static/releases/download/v5.2.5/xz-5.2.5-darwin-x86_64.tar.gz
tar xvf xz-5.2.5.tar.gz
sudo mv xz-*/*xz /usr/local/bin/
```

Linux:

```bash
curl -L -o xz-5.2.5.tar.gz https://github.com/therootcompany/xz-static/releases/download/v5.2.5/xz-5.2.5-linux-x86_64.tar.gz
tar xvf xz-5.2.5.tar.gz
sudo mv xz-*/*xz /usr/local/bin/
```

Windows 10:

```powershell
curl.exe -o xz-5.2.5-windows.zip https://tukaani.org/xz/xz-5.2.5-windows.zip
mkdir xz-5.2.5
pushd xz-5.2.5
tar.exe xvf ../xz-5.2.5-windows.zip
move bin_x86-64\xz.exe ..\
move bin_x86-64\xzdec.exe ..\unxz.exe
```

You then need to move `xz.exe` and `unxz.exe` from the Downloads folder to a folder in your PATH, such as `C:\`

```powershell
move %UserProfile%\Downloads\xz.exe  %SystemRoot%\
move %UserProfile%\Downloads\unxz.exe  %SystemRoot%\
```

# Static Bulid Process

Here's how each of the static builds here were made:

## Mac

```bash
wget https://tukaani.org/xz/xz-5.2.5.tar.gz
tar xvf xz-5.2.5.tar.gz
pushd ./xz-5.2.5/
    ./configure --disable-debug --disable-dependency-tracking --disable-silent-rules --disable-shared --disable-nls
    make

    mkdir ./xz-5.2.5-darwin-x86_64
    rsync -av ./src/xz/xz ./xz-5.2.5-darwin-x86_64/
    rsync -av ./src/xzdec/xzdec ./xz-5.2.5-darwin-x86_64/
    #ln -s xz ./xz-5.2.5-darwin-x86_64/unxz
    tar cvf ./xz-5.2.5-darwin-x86_64.tar.gz ./xz-5.2.5-darwin-x86_64
popd
```

## Linux

```bash
wget https://tukaani.org/xz/xz-5.2.5.tar.gz
tar xvf xz-5.2.5.tar.gz
pushd ./xz-5.2.5/
    ./configure --disable-debug --disable-dependency-tracking --disable-silent-rules --disable-shared --disable-nls
    make

    mkdir ./xz-5.2.5-linux-x86_64
    rsync -av ./src/xz/xz ./xz-5.2.5-linux-x86_64/
    rsync -av ./src/xzdec/xzdec ./xz-5.2.5-linux-x86_64/
    #ln -s xz ./xz-5.2.5-linux-x86_64/unxz
    tar cvf ./xz-5.2.5-linux-x86_64.tar.gz ./xz-5.2.5-linux-x86_64
popd
```

## Windows 10

The Windows 10 build is taken from <https://tukaani.org/xz/>,
specifically <https://tukaani.org/xz/xz-5.2.5-windows.zip>.

# Original Source

Aside from this README.md,
this repository is an identical mirror of the official repository,
which can be found at:

```bash
git clone https://git.tukaani.org/xz.git
```

This repo is rebased regularly, like so:

```bash
git fetch https://git.tukaani.org/xz.git
git pull --rebase https://git.tukaani.org/xz.git master
```

# License

The distributabed code is licensed LGPLv2.1+ (**commercially safe** and NOT copyleft restricted at the project level).

The Mac and Linux builds here **DO NOT** contain any GPL code.

Furthermore, since these are static builds, the restrictions that apply to shared libraries and linked code do not apply.

Some of the build process and scripts are GPL-licensed, but they are not included in the distributable `tar` files.
