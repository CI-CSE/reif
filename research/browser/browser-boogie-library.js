addToLibrary({
    reif_browser_boogie__deps: ["$FS", "$UTF8ToString"],
    reif_browser_boogie(input, output, model, timeout, seed) {
        const filename = UTF8ToString(input);
        const source = FS.readFile(filename, {encoding: "utf8"});
        const report = Module.runBoogie(source, filename, timeout, seed);
        FS.writeFile(UTF8ToString(output), report.output + report.error);
        const modelPath = UTF8ToString(model);
        if (report.model) {
            FS.writeFile(modelPath, report.model);
        } else if (FS.analyzePath(modelPath).exists) {
            FS.unlink(modelPath);
        }
    },
});
