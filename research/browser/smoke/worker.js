const start = performance.now();
var Module = {
    print: line => self.postMessage({line}),
    onExit: code => self.postMessage({code, milliseconds: performance.now() - start}),
};
importScripts("./hello.js");
