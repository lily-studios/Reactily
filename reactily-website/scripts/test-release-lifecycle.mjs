import assert from "node:assert/strict";
import { compareReleaseNumbers, highestNumberedReleaseTag, isSupersededRelease, parseReleaseNumbers } from "../src/lib/release-lifecycle.ts";

assert.equal(compareReleaseNumbers("v2.1.0", "v2.0.0"), 1);
assert.equal(compareReleaseNumbers("v2.10", "v2.9"), 1);
assert.equal(compareReleaseNumbers("v1", "v1.0.0"), 0);
assert.equal(compareReleaseNumbers("release", "nightly"), null);
assert.deepEqual(parseReleaseNumbers("v.2.1.1-experimental"), ["2", "1", "1"]);
assert.deepEqual(parseReleaseNumbers("2026-release-2"), ["2"]);

for (const tag of ["v2", "v2.0.0", "v2.1", "v2.1.0", "v2.1.1", "v2.9.9", "v.2.99"]) {
  assert.equal(isSupersededRelease(tag, "v2.1.0"), false, tag + " must not be deprecated within major 2");
}
for (const tag of ["v1", "v1.1", "v1.9.9", "v.1.9", "v0.99"]) {
  assert.equal(isSupersededRelease(tag, "v2.1.0"), true, tag + " must be deprecated after stable major 2");
}
assert.equal(isSupersededRelease("v3.0.0", "v2.1.0"), false);
assert.equal(isSupersededRelease("v2.1.1", "v3.0.0"), true);
assert.equal(isSupersededRelease("nightly", "v2.1.0"), false);
assert.equal(isSupersededRelease("v1.0.0", null), false);

const stable = ["v2.1.0", "v2.0.0", "v1.1.0"];
assert.equal(highestNumberedReleaseTag(stable), "v2.1.0");
assert.equal(isSupersededRelease("v2.0.0", "v2.1.0"), false);
assert.equal(isSupersededRelease("v1.1.0", "v2.1.0"), true);
assert.equal(isSupersededRelease("v2.1.0", "v2.1.0"), false);
assert.equal(isSupersededRelease("v2.1.1", "v2.1.0"), false);
assert.equal(highestNumberedReleaseTag(["nightly", "experimental"]), null);
console.log("[release lifecycle] PASS — v2.1.0 Latest, v2.0.0 Stable, v1.1.0 Deprecated; experimental unaffected.");
