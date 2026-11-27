from pathlib import Path
import re
import statistics
import subprocess
from time import monotonic, sleep

source = Path("number_source.e")
original = source.read_text()
compiler = ["stdbuf", "-o0", "-e0", "apb", "-config", "hello.ecf", "-target", "hello"]
marker = re.compile(r"Degree -?\d+:|System Recompiled\.")
samples = {}

def record(group, events, elapsed):
    assert any("System Recompiled." in text for _, text in events), events
    samples.setdefault(group, []).append(elapsed)
    print(f"{group} {elapsed:.4f}s", flush=True)
    for elapsed, text in events:
        print(f"  +{elapsed:.4f}s {text.strip()}", flush=True)

def edit(before, after):
    sleep(1.05)  # Eiffel project file timestamps have second granularity.
    current = source.read_text()
    assert before in current
    source.write_text(current.replace(before, after))

def fresh(group):
    start = monotonic()
    events = []
    with subprocess.Popen(compiler + ["-batch", "-melt"], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True) as proc:
        for line in proc.stdout:
            if marker.search(line):
                events.append((monotonic() - start, line))
        assert proc.wait() == 0, proc.returncode
    record(group, events, monotonic() - start)

def until_prompt(proc, start):
    events = []
    lines = bytearray()
    prompt = b"Command => "
    suffix = bytearray()
    while True:
        byte = proc.stdout.read(1)
        if not byte:
            raise RuntimeError(lines.decode(errors="replace"))
        lines.extend(byte)
        suffix.extend(byte)
        del suffix[:-len(prompt)]
        if suffix == prompt:
            return events
        if byte == b"\n":
            line = lines.decode(errors="replace")
            lines.clear()
            if marker.search(line):
                events.append((monotonic() - start, line))

try:
    fresh("cold")
    for _ in range(5):
        edit("Result := 21", "Result := 22")
        fresh("new process")
        edit("Result := 22", "Result := 21")
        fresh("new process")
    with subprocess.Popen(compiler + ["-loop"], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, bufsize=0) as proc:
        until_prompt(proc, monotonic())
        proc.stdin.write(b"i\n")
        until_prompt(proc, monotonic())
        for i in range(11):
            if i:
                edit("Result := 21" if i % 2 else "Result := 22", "Result := 22" if i % 2 else "Result := 21")
            start = monotonic()
            proc.stdin.write(b"l\n")
            events = until_prompt(proc, start)
            record("session first" if not i else "same process", events, monotonic() - start)
        proc.stdin.write(b"q\n")
    for group, values in samples.items():
        print(f"MEDIAN {group} {statistics.median(values):.4f}s (n={len(values)})")
finally:
    source.write_text(original)
