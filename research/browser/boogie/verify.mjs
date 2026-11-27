import {dotnet} from "./_framework/dotnet.js";
import {createBoogieReply, readBoogieReply} from "../boogie-channel.mjs";

const solver = new Worker(new URL("z3-worker.js", import.meta.url));
const runtime = await dotnet.create();
let z3Ms;
function exchange(kind, context, commands) {
    const reply = createBoogieReply();
    solver.postMessage({kind, context, commands, reply});
    const report = readBoogieReply(reply);
    if (report.failure) throw new Error(report.failure);
    return report.value;
}
runtime.setModuleImports("reif-z3", {
    open: () => exchange("open"),
    evaluate(context, commands) {
        const start = performance.now();
        try {
            return exchange("evaluate", context, commands);
        } finally {
            z3Ms += performance.now() - start;
        }
    },
    close: context => exchange("close", context),
});
const {BoogieBrowser} = await runtime.getAssemblyExports(runtime.getConfig().mainAssemblyName);

export function verify(program, filename, timeoutSeconds = 0, seed = -1) {
    z3Ms = 0;
    const [code, output, error, model] = BoogieBrowser.Verify(program, filename, timeoutSeconds, seed);
    return {code: Number(code), output, error, model, z3Ms};
}
