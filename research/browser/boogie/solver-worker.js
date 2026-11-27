self.onmessage = async ({data: {source, filename, timeout, seed, reply}}) => {
    const {writeBoogieReply} = await import("../boogie-channel.mjs");
    try {
        const start = performance.now();
        const {verify} = await import("./verify.mjs");
        const loaded = performance.now();
        const report = verify(source, filename, timeout, seed);
        const timings = {
            loadMs: loaded - start,
            verifyMs: performance.now() - loaded,
            z3Ms: report.z3Ms,
            modelBytes: new TextEncoder().encode(report.model).length,
        };
        if (report.code !== 0 || !report.output.includes("Boogie program verifier finished")) {
            throw new Error(report.error || report.output || "Boogie failed to run.");
        }
        writeBoogieReply(reply, {...report, timings});
    } catch (error) {
        writeBoogieReply(reply, {failure: String(error)});
    }
};
