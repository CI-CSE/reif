import argparse
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
import json
from pathlib import Path
from threading import Thread

from playwright.sync_api import sync_playwright

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
    parser.add_argument("target", choices=["hello", "ecb"])
    parser.add_argument("directory", type=Path)
    parser.add_argument("--browser-executable")
    args = parser.parse_args()
    fixture = Path(__file__).with_name("smoke")
    handler = partial(SimpleHTTPRequestHandler, directory=args.directory.resolve())
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
                else:
                    check_compiler(page, fixture)
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


if __name__ == "__main__":
    main()
