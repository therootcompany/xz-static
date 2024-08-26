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
b_ver="5.2.5"
curl -L -o ./xz-"${b_ver}".tar.gz https://github.com/therootcompany/xz-static/releases/download/v"${b_ver}"/xz-"${b_ver}"-darwin-x86_64.tar.gz
tar xvf ./xz-"${b_ver}".tar.gz

sudo mv xz-*/*xz /usr/local/bin/
```

Linux:

```sh
b_ver="5.2.5"
curl -L -o ./xz-"${b_ver}".tar.gz https://github.com/therootcompany/xz-static/releases/download/v"${b_ver}"/xz-"${b_ver}"-linux-x86_64.tar.gz
tar xvf ./xz-"${b_ver}".tar.gz

sudo mv ./xz-*/*xz /usr/local/bin/
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

```sh
b_ver="5.2.5"
wget https://tukaani.org/xz/xz-"${b_ver}".tar.gz
tar xvf xz-"${b_ver}".tar.gz
(
    cd ./xz-"${b_ver}"/ || exit 1
    ./configure --disable-debug --disable-dependency-tracking --disable-silent-rules --disable-shared --disable-nls
    make

    mkdir ./xz-"${b_ver}"-darwin-x86_64
    rsync -av ./src/xz/xz ./xz-"${b_ver}"-darwin-x86_64/
    rsync -av ./src/xzdec/xzdec ./xz-"${b_ver}"-darwin-x86_64/
    #ln -s xz ./xz-"${b_ver}"-darwin-x86_64/unxz
    tar cvf ./xz-"${b_ver}"-darwin-x86_64.tar.gz ./xz-"${b_ver}"-darwin-x86_64
)
```

## Linux

```sh
b_ver="5.2.5"
wget https://tukaani.org/xz/xz-"${b_ver}".tar.gz
tar xvf xz-"${b_ver}".tar.gz
(
    cd ./xz-"${b_ver}"/ || exit 1
    ./configure --disable-debug --disable-dependency-tracking --disable-silent-rules --disable-shared --disable-nls
    make

    mkdir ./xz-"${b_ver}"-linux-x86_64
    rsync -av ./src/xz/xz ./xz-"${b_ver}"-linux-x86_64/
    rsync -av ./src/xzdec/xzdec ./xz-"${b_ver}"-linux-x86_64/
    #ln -s xz ./xz-"${b_ver}"-linux-x86_64/unxz
    tar cvf ./xz-"${b_ver}"-linux-x86_64.tar.gz ./xz-"${b_ver}"-linux-x86_64
)
```

## Windows 10

The Windows 10 build is taken from <https://tukaani.org/xz/>,
specifically <https://tukaani.org/xz/xz-5.2.5-windows.zip>.

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
