# Headless REIF in WebAssembly

The prototype runs the finalized REIF batch compiler in a Chromium Web Worker. It can check Eiffel source and report compiler diagnostics. It ships EiffelBase and the compiler resources needed for the sample project.

## Build and test

Use a native REIF build to generate finalized C. Generate the batch target from [AutoProof's ECF](../extension/autoproof/autoproof.ecf) for the compiler, or use the `smoke/hello.ecf` project for the runtime test.

On Linux with Emscripten 4.0.10 active and Python Playwright with Chromium installed, run from the REIF root.

```sh
research/browser/build-wasm.sh ecb path/to/EIFGENs/batch/F_code /tmp/reif-ecb
python3 research/browser/test_browser.py ecb /tmp/reif-ecb

research/browser/build-wasm.sh hello path/to/EIFGENs/hello/F_code /tmp/reif-hello
python3 research/browser/test_browser.py hello /tmp/reif-hello
```

The compiler test checks a two-class project and expects `VJAR` after an incompatible assignment. The runtime test exercises generic arrays and exception recovery. The worker prototype covers the Eiffel compilation phase. AutoProof's Boogie process and the native C toolchain still need browser integration.

## Measure incremental compilation

Run `benchmark.py` from a fresh copy of `smoke/` with native `apb` on the path. It compares a new invocation with the existing `-loop` process after edits. Configure the same EiffelBase precompile in both runs when benchmarking the CodeForge VM.
