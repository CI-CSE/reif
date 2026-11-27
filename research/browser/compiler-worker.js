self.addEventListener("unhandledrejection", ({reason}) => {
    self.postMessage({failure: reason?.stack || String(reason)});
});

self.onmessage = async ({data: {files, args, deadlineMs = 120_000}}) => {
    const {createBoogieReply, readBoogieReply} = await import("./boogie-channel.mjs");
    const start = performance.now();
    const lines = [];
    const phases = [];
    const solverRuns = [];
    const print = line => {
        lines.push(line);
        if (line.startsWith("Degree ")) {
            phases.push({name: line, milliseconds: performance.now() - start});
        }
    };
    self.Module = {
        arguments: args,
        projectFiles: files,
        print,
        printErr: print,
        runBoogie(source, filename, timeout, seed) {
            const reply = createBoogieReply();
            self.postMessage({ kind: "boogie", source, filename, timeout, seed, reply });
            const report = readBoogieReply(reply, start + deadlineMs);
            if (report.failure) throw new Error(report.failure);
            solverRuns.push(report.timings);
            phases.push({name: "Boogie and Z3", milliseconds: performance.now() - start});
            return report;
        },
        onAbort: reason => self.postMessage({failure: String(reason), lines, phases}),
        onExit: code => self.postMessage({
            code,
            lines,
            phases,
            solverRuns,
            milliseconds: performance.now() - start,
        }),
    };
    try {
        importScripts("./ecb.js");
    } catch (error) {
        self.postMessage({failure: error.stack || String(error), lines, phases});
    }
};
