self.onmessage = ({data: {files, args}}) => {
    const start = performance.now();
    const lines = [];
    const phases = [];
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
        onExit: code => self.postMessage({
            code,
            lines,
            phases,
            milliseconds: performance.now() - start,
        }),
    };
    importScripts("./ecb.js");
};
