/* ============================================================
 * Reactily · Lily Studios
 * Production Browser Smoke Tests (Chrome DevTools Protocol)
 * No external npm dependencies.
 * ============================================================ */

import { setTimeout as sleep } from "node:timers/promises";

const debuggerAddress = process.env.CHROME_DEBUG_ADDRESS ?? "http://127.0.0.1:9222";
const baseUrl = process.env.REACTILY_PREVIEW_URL ?? "http://127.0.0.1:4173/Reactily/";

const routes = [
  ["", "React-style UI structure."],
  ["api", "Reactily API"],
  ["docs/intro", "What is Reactily?"],
  ["docs/getting-started", "Install Reactily"],
];

async function discoverPage() {
  for (let attempt = 0; attempt < 60; attempt += 1) {
    try {
      const response = await fetch(`${debuggerAddress}/json/list`);

      if (response.ok) {
        const targets = await response.json();
        const page = targets.find((target) => target.type === "page");

        if (page?.webSocketDebuggerUrl) {
          return page.webSocketDebuggerUrl;
        }
      }
    } catch {
      // Browser is still starting.
    }

    await sleep(250);
  }

  throw new Error("Chrome DevTools did not become available.");
}

function connectCdp(url) {
  const socket = new WebSocket(url);
  const pending = new Map();
  const failures = [];
  let nextId = 0;

  socket.addEventListener("message", ({ data }) => {
    const message = JSON.parse(data);

    if (message.id !== undefined) {
      const command = pending.get(message.id);

      if (!command) {
        return;
      }

      pending.delete(message.id);

      if (message.error) {
        command.reject(new Error(JSON.stringify(message.error)));
      } else {
        command.resolve(message.result);
      }

      return;
    }

    if (message.method === "Runtime.exceptionThrown") {
      const detail = message.params?.exceptionDetails;
      failures.push(detail?.exception?.description ?? detail?.text ?? JSON.stringify(detail));
    }

    if (message.method === "Network.loadingFailed" && !message.params?.canceled) {
      failures.push(`Resource failed: ${message.params?.errorText ?? "unknown error"}`);
    }
  });

  const ready = new Promise((resolve, reject) => {
    socket.addEventListener("open", resolve, { once: true });
    socket.addEventListener("error", () => reject(new Error("Chrome DevTools connection failed.")), { once: true });
  });

  function send(method, params = {}) {
    return new Promise((resolve, reject) => {
      const id = ++nextId;
      pending.set(id, { resolve, reject });
      socket.send(JSON.stringify({ id, method, params }));
    });
  }

  return { socket, ready, send, failures };
}

async function main() {
  const socketUrl = await discoverPage();
  const cdp = connectCdp(socketUrl);

  await cdp.ready;

  try {
    await cdp.send("Page.enable");
    await cdp.send("Runtime.enable");
    await cdp.send("Network.enable");

    for (const [route, expected] of routes) {
      const url = new URL(route, baseUrl).href;
      const errorOffset = cdp.failures.length;

      console.log(`Checking ${url}`);
      await cdp.send("Page.navigate", { url });

      const deadline = Date.now() + 20_000;
      let lastText = "";
      let passed = false;

      while (Date.now() < deadline) {
        try {
          const evaluation = await cdp.send("Runtime.evaluate", {
            expression: 'document.getElementById("root")?.innerText ?? ""',
            returnByValue: true,
          });

          lastText = evaluation.result?.value ?? "";

          if (/Reactily docs failed to (start|render)/.test(lastText)) {
            throw new Error(`Reactily displayed its error screen at ${url}:\n${lastText}`);
          }

          if (lastText.includes(expected)) {
            passed = true;
            break;
          }
        } catch (error) {
          if (String(error).includes("Reactily displayed its error screen")) {
            throw error;
          }
          // Ignore expected execution-context errors while navigating.
        }

        await sleep(250);
      }

      if (!passed) {
        const browserErrors = cdp.failures.slice(errorOffset).join("\n");
        throw new Error(
          `Browser failed to render ${url}. Expected: "${expected}".\n` +
          `Last page text: ${lastText.slice(0, 1500)}\n` +
          `Browser errors: ${browserErrors || "(none captured)"}`,
        );
      }

      console.log(`PASS: ${url}`);
    }
  } finally {
    cdp.socket.close();
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
