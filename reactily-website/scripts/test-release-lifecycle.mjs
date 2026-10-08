import assert from "node:assert/strict";
import {
  compareReleaseNumbers,
  highestNumberedReleaseTag,
  isSupersededRelease,
  parseReleaseNumbers,
} from "../src/lib/release-lifecycle.ts";

const examples = [
  { older: "v1", newer: "v2" },
  { older: "v1.1", newer: "v1.2" },
  { older: "v1.1.9", newer: "v1.2" },
  { older: "v1.9", newer: "v2.0" },
  { older: "v2.1.0", newer: "v2.1.1" },
  { older: "v2.1.1", newer: "v3" },
  { older: "v.2.1.1", newer: "v.2.1.2" },
  { older: "2.0.0-beta", newer: "3.0.0" },
  { older: "2026-release-2", newer: "2026-release-3" },
];
for (const { older, newer } of examples) {
  assert.equal(compareReleaseNumbers(older, newer), -1, older + " should be superseded by " + newer);
  assert.equal(isSupersededRelease(older, newer), true);
  assert.equal(isSupersededRelease(newer, older), false);
}

assert.equal(compareReleaseNumbers("v1", "v1.0.0"), 0);
assert.equal(compareReleaseNumbers("v2.01", "v2.1.0"), 0);
assert.equal(compareReleaseNumbers("v2.10", "v2.9"), 1);
assert.equal(compareReleaseNumbers("release", "nightly"), null);
assert.deepEqual(parseReleaseNumbers("v.2.1.1-experimental"), ["2", "1", "1"]);
assert.equal(highestNumberedReleaseTag(["v2.0.0", "v1.1.0", "v2.1.1", "v2.1.0"]), "v2.1.1");
assert.equal(highestNumberedReleaseTag(["nightly", "experimental"]), null);

const actualReleaseTags = ["v2.1.1", "v2.1.0", "v2.0.0", "v1.1.0"];
const newest = highestNumberedReleaseTag(actualReleaseTags);
assert.equal(newest, "v2.1.1");
for (const tag of actualReleaseTags.slice(1)) {
  assert.equal(isSupersededRelease(tag, newest), true, tag + " should be Deprecated");
}
assert.equal(isSupersededRelease(newest, newest), false);
assert.equal(isSupersededRelease("nightly", newest), false);
console.log("[release lifecycle] PASS — numeric version ordering, partial tags, named formats, release channels, and deprecation labels.");
