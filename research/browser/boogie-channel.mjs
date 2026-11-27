// One slot is enough to stream the report, including large counterexamples.
const empty = 0;
const chunk = 1;
const lastChunk = 2;
const headerBytes = 2 * Int32Array.BYTES_PER_ELEMENT;

export function createBoogieReply() {
    return new SharedArrayBuffer(headerBytes + 64 * 1024);
}

export function readBoogieReply(buffer, deadlineMs = Infinity) {
    const header = new Int32Array(buffer, 0, 2);
    const bytes = new Uint8Array(buffer, headerBytes);
    const decoder = new TextDecoder();
    const parts = [];
    for (;;) {
        if (Atomics.wait(header, 0, empty, Math.max(0, deadlineMs - performance.now())) === "timed-out") {
            throw new Error("Boogie did not return a result before the deadline.");
        }
        const final = Atomics.load(header, 0) === lastChunk;
        const size = Atomics.load(header, 1);
        parts.push(decoder.decode(Uint8Array.from(bytes.subarray(0, size)), {stream: !final}));
        Atomics.store(header, 0, empty);
        Atomics.notify(header, 0);
        if (final) return JSON.parse(parts.join(""));
    }
}

export function writeBoogieReply(buffer, report) {
    const header = new Int32Array(buffer, 0, 2);
    const slot = new Uint8Array(buffer, headerBytes);
    const bytes = new TextEncoder().encode(JSON.stringify(report));
    for (let offset = 0; offset < bytes.length; offset += slot.length) {
        const pending = Atomics.load(header, 0);
        if (pending !== empty && Atomics.wait(header, 0, pending, 30_000) === "timed-out") {
            throw new Error("REIF stopped reading the Boogie report.");
        }
        const batch = bytes.subarray(offset, offset + slot.length);
        slot.set(batch);
        Atomics.store(header, 1, batch.length);
        Atomics.store(header, 0, offset + batch.length === bytes.length ? lastChunk : chunk);
        Atomics.notify(header, 0);
    }
}
