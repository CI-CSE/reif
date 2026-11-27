# Headless REIF in WebAssembly

REIF compiles Eiffel and translates it to Boogie in a browser worker. Boogie runs on the .NET WebAssembly runtime and sends SMT queries to a Z3 worker. REIF produces the usual AutoProof report and reads counterexample models from Z3.

## Build and test

Generate finalized C using the native AutoProof batch target in [autoproof.ecf](../extension/autoproof/autoproof.ecf). Use Emscripten 4.0.10, the .NET 8 SDK with `wasm-tools`, Node with npm, and Python Playwright with Chromium.

```sh
research/browser/build-wasm.sh ecb path/to/EIFGENs/batch/F_code /tmp/reif-browser
research/browser/build-boogie.sh /tmp/reif-browser/boogie
python3 research/browser/test_browser.py proof /tmp/reif-browser
```

Serve the bundle with `Cross-Origin-Opener-Policy: same-origin` and `Cross-Origin-Embedder-Policy: require-corp`. Import `verifyProject(files, args, {signal, timeoutMs})` from `verify-project.mjs`. Pass filenames and source text in `files`, including the ECF. The result contains the compiler output and timings for each Boogie call.

Use `test_browser.py ecb` to check type diagnostics. Use the `hello` target and `smoke/hello.ecf` to test the Eiffel runtime, including generic arrays and exception recovery. Run `benchmark.py` with native `apb` in a fresh copy of `smoke/` to compare new invocations with the `-loop` process after edits.
