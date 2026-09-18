#!/bin/sh
# Repackage the upstream Windows ZIP into one archive per architecture.

set -Cue

if test "$#" -lt 2 || test "$#" -gt 3; then
	printf 'usage: %s VERSION UPSTREAM_WINDOWS_ZIP [OUTPUT_DIR]\n' "$0" >&2
	exit 2
fi

for b_cmd in unzip zip; do
	if ! command -v "$b_cmd" >/dev/null 2>&1; then
		printf 'error: required command not found: %s\n' "$b_cmd" >&2
		exit 1
	fi
done

g_version=$1
g_src_zip=$2
g_out_dir=${3:-.}
g_work_dir=$(mktemp -d)

fn_cleanup() {
	rm -rf "$g_work_dir"
}

trap fn_cleanup EXIT

if ! test -f "$g_src_zip"; then
	printf 'error: source ZIP not found: %s\n' "$g_src_zip" >&2
	exit 1
fi

mkdir -p "$g_out_dir"
g_out_dir=$(cd "$g_out_dir" && pwd)
unzip -q "$g_src_zip" -d "$g_work_dir/upstream"

if ! test -f "$g_work_dir/upstream/include/lzma.h"; then
	printf '%s\n' 'error: source ZIP has no include/lzma.h' >&2
	exit 1
fi

fn_repackage() {
	b_arch=$1
	b_upstream_bin=$2
	b_stage="$g_work_dir/$b_arch"
	b_output="$g_out_dir/xz-$g_version-windows-$b_arch.zip"

	if ! test -d "$g_work_dir/upstream/$b_upstream_bin"; then
		printf 'error: source ZIP has no %s\n' "$b_upstream_bin" >&2
		exit 1
	fi
	if ! test -f "$g_work_dir/upstream/$b_upstream_bin/xz.exe"; then
		printf 'error: %s has no xz.exe\n' "$b_upstream_bin" >&2
		exit 1
	fi
	if ! test -f "$g_work_dir/upstream/$b_upstream_bin/liblzma.dll"; then
		printf 'error: %s has no liblzma.dll\n' "$b_upstream_bin" >&2
		exit 1
	fi

	mkdir -p "$b_stage/bin" "$b_stage/include"
	cp -R "$g_work_dir/upstream/$b_upstream_bin/." "$b_stage/bin/"
	cp -R "$g_work_dir/upstream/include/." "$b_stage/include/"

	rm -f "$b_output"
	(
		cd "$b_stage"
		zip -qr "$b_output" bin include
	)
	printf 'created %s\n' "$b_output"
}

fn_repackage amd64 bin_x86-64
fn_repackage i686 bin_i686-sse2
