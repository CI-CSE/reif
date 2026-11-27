Module.preRun ??= [];
Module.preRun.push(() => {
    ENV.ISE_EIFFEL = "/eiffel";
    ENV.ISE_LIBRARY = "/eiffel";
    ENV.ISE_PLATFORM = "linux-x86";
    ENV.HOME = "/home";
    FS.mkdirTree("/home");
    FS.mkdirTree("/eiffel/studio/spec/linux-x86/bin");
    FS.mkdirTree("/work");
    FS.chdir("/work");
    for (const [name, contents] of Object.entries(Module.projectFiles ?? {})) {
        FS.writeFile(name, contents);
    }
});
