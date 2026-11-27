// Execute REIF and its solver in separate workers so the page stays responsive.
export function verifyProject(files, args, {signal, timeoutMs = 120_000} = {}) {
    return new Promise((resolve, reject) => {
        if (signal?.aborted) {
            reject(signal.reason);
            return;
        }
        if (!globalThis.crossOriginIsolated) {
            reject(new Error("Browser verification needs a cross-origin isolated page."));
            return;
        }
        const compiler = new Worker(new URL("compiler-worker.js", import.meta.url));
        let solver;
        const finish = (callback, value) => {
            clearTimeout(timer);
            signal?.removeEventListener("abort", cancel);
            compiler.terminate();
            solver?.terminate();
            callback(value);
        };
        const cancel = () => finish(reject, signal.reason);
        const timer = setTimeout(() => finish(reject, new Error("Verification timed out.")), timeoutMs);
        const failed = event => finish(reject, new Error(event.message));
        signal?.addEventListener("abort", cancel, {once: true});
        compiler.onerror = failed;
        compiler.onmessage = ({data}) => {
            if (data.kind === "boogie") {
                if (!solver) {
                    solver = new Worker(new URL("boogie/solver-worker.js", import.meta.url));
                    solver.onerror = failed;
                }
                solver.postMessage(data);
            } else if (data.failure) {
                finish(reject, new Error(data.failure));
            } else if (data.code !== undefined) {
                finish(resolve, data);
            }
        };
        compiler.postMessage({files, args, deadlineMs: timeoutMs});
    });
}
