let startup;
async function loadZ3() {
    importScripts("./z3/z3-built.js");
    return globalThis.initZ3({
        locateFile: filename => new URL("z3/" + filename, self.location.href).href,
        mainScriptUrlOrBlob: new URL("./z3/z3-built.js", self.location.href).href,
    });
}

self.onmessage = async ({data: {kind, context, commands, reply}}) => {
    const {writeBoogieReply} = await import("../boogie-channel.mjs");
    try {
        const z3 = await (startup ??= loadZ3());
        let value;
        switch (kind) {
            case "open": {
                const config = z3._Z3_mk_config();
                value = z3._Z3_mk_context(config);
                z3._Z3_del_config(config);
                z3._set_noop_error_handler(value);
                break;
            }
            case "evaluate":
                value = await z3.async_call(() => z3.ccall(
                    "async_Z3_eval_smtlib2_string", "void", ["number", "string"], [context, commands],
                ));
                break;
            case "close":
                z3._Z3_del_context(context);
                break;
            default:
                throw new Error("Unknown Z3 operation.");
        }
        writeBoogieReply(reply, {value});
    } catch (error) {
        writeBoogieReply(reply, {failure: String(error)});
    }
};
