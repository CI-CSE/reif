import argparse
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
import json
from pathlib import Path
from threading import Thread

from playwright.sync_api import sync_playwright

class IsolatedHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
        self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
        super().end_headers()


RUN_WORKER = """
({script, payload}) => new Promise((resolve, reject) => {
    const worker = new Worker(script);
    const lines = [];
    const finish = callback => value => {
        worker.terminate();
        callback(value);
    };
    worker.onerror = event => finish(reject)(new Error(event.message));
    worker.onmessage = ({data}) => {
        if (data.line !== undefined) lines.push(data.line);
        if (data.code !== undefined) finish(resolve)({lines, ...data});
    };
    if (payload !== null) worker.postMessage(payload);
})
"""


def main():
    parser = argparse.ArgumentParser(description="Run the REIF Wasm prototype in Chromium.")
    parser.add_argument("target", choices=["hello", "ecb", "proof"])
    parser.add_argument("directory", type=Path)
    parser.add_argument("--browser-executable")
    args = parser.parse_args()
    fixture = Path(__file__).with_name("smoke")
    handler = partial(IsolatedHandler, directory=args.directory.resolve())
    with ThreadingHTTPServer(("127.0.0.1", 0), handler) as server:
        Thread(target=server.serve_forever, daemon=True).start()
        try:
            with sync_playwright() as playwright:
                browser = playwright.chromium.launch(executable_path=args.browser_executable)
                page = browser.new_page()
                page.goto(f"http://127.0.0.1:{server.server_port}/")
                if args.target == "hello":
                    result = page.evaluate(RUN_WORKER, {"script": "worker.js", "payload": None})
                    assert result["code"] == 0 and result["lines"] == ["42", "rescued"], result
                    print(json.dumps(result))
                elif args.target == "ecb":
                    check_compiler(page, fixture)
                else:
                    check_proofs(page, fixture)
        finally:
            server.shutdown()


def check_compiler(page, fixture):
    files = {path.name: path.read_text() for path in fixture.glob("*.e*")}
    args = ["-batch", "-melt", "-stop", "-config", "hello.ecf", "-target", "hello"]
    for valid in (True, False):
        if not valid:
            original = files["number_source.e"]
            files["number_source.e"] = original.replace("Result := 21", 'Result := "wrong type"')
        result = page.evaluate(RUN_WORKER, {
            "script": "compiler-worker.js",
            "payload": {"files": files, "args": args},
        })
        diagnostic = "\n".join(result.pop("lines"))
        if valid:
            assert result["code"] == 0 and "System Recompiled." in diagnostic, diagnostic
        else:
            assert result["code"] != 0 and "Error code: VJAR" in diagnostic, diagnostic
            assert "Class: NUMBER_SOURCE" in diagnostic and "Feature: value" in diagnostic, diagnostic
        print(json.dumps(dict(result, valid=valid)))


def check_proofs(page, fixture):
    ecf = (fixture / "hello.ecf").read_text().replace(
        '<root class="APPLICATION" feature="make"/>', '<root all_classes="true"/>'
    )
    source = """class HELLO_WORLD
create
    make
feature
    make
        do
            check {condition} end
        end
end
"""
    args = ["-batch", "-stop", "-config", "hello.ecf", "-autoproof", "-html", "-timeout", "10"]
    for condition, expected in (("True", [3, 0]), ("False", [3, 2])):
        files = {"hello.ecf": ecf, "hello_world.e": source.format(condition=condition)}
        result = page.evaluate(r"""async ({files, args}) => {
            const {verifyProject} = await import("./verify-project.mjs");
            const report = await verifyProject(files, args);
            const html = new DOMParser().parseFromString(report.lines.join("\n"), "text/html");
            const rows = [...html.querySelectorAll("tbody tr")];
            report.proofs = [rows.length, rows.filter(row =>
                row.style.backgroundColor !== "rgb(221, 255, 221)").length];
            return report;
        }""", {"files": files, "args": args})
        assert result["code"] == 0 and result["proofs"] == expected, result
        assert result["solverRuns"], result
        if condition == "False":
            assert any(run["modelBytes"] > 0 for run in result["solverRuns"]), result
        del result["lines"]
        print(json.dumps(dict(result, condition=condition)), flush=True)


if __name__ == "__main__":
    main()
