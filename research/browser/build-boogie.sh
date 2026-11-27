#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 1 ]]; then
    echo "Usage: $0 output-directory" >&2
    exit 2
fi
browser_dir=$(cd "$(dirname "$0")" && pwd)
mkdir -p "$1"
output=$(cd "$1" && pwd)
build=$(mktemp -d "${TMPDIR:-/tmp}/reif-boogie.XXXXXX")
trap 'rm -r -- "$build"' EXIT

# Keep the Boogie version used by native AutoProof.
revision=35cc0323f812f5eb385455472fa350816d9adc8c
git init -q "$build/boogie"
git -C "$build/boogie" fetch -q --depth=1 https://github.com/boogie-org/boogie.git "$revision"
git -C "$build/boogie" checkout -q --detach FETCH_HEAD
git -C "$build/boogie" apply "$browser_dir/boogie/browser.patch"
cp "$browser_dir/boogie/BrowserSolver.cs" "$build/boogie/Source/Provers/SMTLib/"
mkdir "$build/bridge"
cp "$browser_dir/boogie/"{BoogieBrowser.cs,BoogieBrowser.csproj,verify.mjs} "$build/bridge/"

dotnet publish "$build/bridge/BoogieBrowser.csproj" -c Release
bundle="$build/bridge/bin/Release/net8.0/browser-wasm/AppBundle"
cp -R "$bundle/_framework" "$bundle/verify.mjs" "$output/"
cp "$browser_dir/boogie/"{solver-worker.js,z3-worker.js} "$output/"
cp "$build/boogie/LICENSE.txt" "$output/Boogie-LICENSE.txt"

mkdir -p "$output/z3"
archive=$(npm pack z3-solver@5.4.1 --ignore-scripts --pack-destination "$build" --silent)
tar -xf "$build/$archive" -C "$output/z3" --strip-components=2 package/build/z3-built.js package/build/z3-built.wasm
tar -xf "$build/$archive" -C "$output/z3" --strip-components=1 package/LICENSE.txt
