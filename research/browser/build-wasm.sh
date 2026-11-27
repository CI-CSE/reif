#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 3 || ! -f "$2/Makefile.SH" ]]; then
    echo "Usage: $0 {hello|ecb} F_code output-directory" >&2
    exit 2
fi
target=$1
case "$target" in
    hello|ecb) ;;
    *) echo "Unsupported target: $target" >&2; exit 2 ;;
esac

browser_dir=$(cd "$(dirname "$0")" && pwd)
source_dir=$(cd "$browser_dir/../../Src" && pwd)
generated=$(cd "$2" && pwd)
mkdir -p "$3"
output=$(cd "$3" && pwd)
build=$(mktemp -d "${TMPDIR:-/tmp}/reif-wasm.XXXXXX")
trap 'rm -r -- "$build"' EXIT
runtime="$build/C"

cp -R "$source_dir/C" "$runtime"
cp -R "$generated" "$build/F_code"
find "$runtime" "$build/F_code" -type f \
    \( -name '*.o' -o -name '*.a' \) -delete
find "$build/F_code/E1" -maxdepth 1 -type f \
    \( -name eoffsets.h -o -name estructure.h -o -name esize.c -o -name eskelet.c \) -delete
export EIFFEL_SRC="$source_dir" ISE_LIBRARY="$source_dir"

# The wasm32 data model has 32-bit pointers and longs and 8-byte alignment
# for 64-bit types. Never use the host x2c or runtime for these objects.
cd "$runtime"
cp CONFIGS/linux-x86 config.sh
cat >>config.sh <<'CONFIG'
cc=emcc
cpp=em++
ld=emcc
ar=emar
ccflags=-D_GNU_SOURCE
cppflags=$ccflags
ccldflags=
optimize=-O2
alignbytes=8
eif_arch=EIF_ARCH_WASM32
eif_pointer_display='"lX"'
CONFIG
./Configure -S
make -C run-time -j "${JOBS:-4}" libfinalized.a
"${HOST_CC:-cc}" -I. -Irun-time -Irun-time/include -Iidrs \
    -ffunction-sections -Wl,--gc-sections \
    run-time/x2c.c run-time/offset.c run-time/error.c -o "$build/x2c"

link_flags='-sALLOW_MEMORY_GROWTH=1 -sEXIT_RUNTIME=1'
external_objects=
studio="$source_dir/Delivery/studio"
if [[ $target == ecb ]]; then
    make -C bench -j "${JOBS:-4}" libcompiler.a
    make -C platform -j "${JOBS:-4}" libplatform.a
    emcc -O2 -c "$browser_dir/getdtablesize.c" -o "$build/getdtablesize.o"
    external_objects="\"$runtime/bench/libcompiler.a\" \"$runtime/platform/libplatform.a\" \"$build/getdtablesize.o\""

    data="$build/eiffel"
    mkdir -p "$data/library" "$data/studio"
    cp -R "$source_dir/library/"{base,encoding} "$data/library/"
    cp -R "$studio/"{built_ins,config,eifinit,help} "$data/studio/"
    link_flags+=" --pre-js \"$browser_dir/compiler-pre.js\" --preload-file \"$data@/eiffel\""

    # The finalized compiler only references the C libraries listed above.
    # Skip the desktop include probe in its generated makefiles.
    find "$build/F_code" -name Makefile.SH -exec \
        sed -i 's@ `[^ `]*vision2-gtk-config --include_path`@@g' {} +
fi

cd "$build/F_code"
cat >config.sh <<CONFIG
spitshell=cat
eunicefix=:
cc=emcc
cpp=em++
ar=emar
make=make
cp=cp
rm=rm
ld=emcc
optimize=-O2
ccflags="-I$runtime -I$runtime/run-time/include -I$runtime/idrs"
cppflags=\$ccflags
rt_include=$runtime/run-time
rt_lib=$runtime/run-time
prefix=lib
eiflib=finalized
suffix=.a
shared_suffix=.so
x2c=$build/x2c
rt_templates=$source_dir/Delivery/studio/config/unix/templates
libs=-lm
CONFIG
sh Makefile.SH
# Emscripten chooses the JavaScript launcher from the output suffix.
sed -i "s/ -o $target / -o $target.js /" Makefile
make -j "${JOBS:-4}" "$target" EXTERNALS="$external_objects" CCLDFLAGS="$link_flags"
cp "$target.js" "$target.wasm" "$output/"
if [[ $target == ecb ]]; then
    cp ecb.data "$browser_dir/compiler-worker.js" "$output/"
else
    cp "$browser_dir/smoke/"{index.html,worker.js} "$output/"
fi
