const root = document.getElementById("root");

function formatFailure(value: unknown): string {
  if (value instanceof Error) {
    return value.stack ?? value.message;
  }

  if (typeof value === "string") {
    return value;
  }

  try {
    return JSON.stringify(value, null, 2);
  } catch {
    return String(value);
  }
}

function showStartupFailure(error: unknown): void {
  console.error("[Reactily Docs] Startup failed", error);

  if (root === null) {
    document.body.textContent =
      `Reactily docs startup failed: ${formatFailure(error)}`;

    return;
  }

  root.innerHTML = "";

  const main = document.createElement("main");

  main.style.cssText = [
    "min-height:100vh",
    "padding:32px",
    "background:#0f171a",
    "color:#eef9fa",
    "font-family:ui-monospace,SFMono-Regular,Menlo,monospace",
  ].join(";");

  const title = document.createElement("h1");

  title.textContent = "Reactily docs failed to start";
  title.style.marginTop = "0";

  const explanation = document.createElement("p");

  explanation.textContent =
    "The React entry module could not load. Run this project with `npm run dev` or serve the built `dist` folder; do not open the source index.html with Live Server.";

  explanation.style.color = "#9db2b7";
  explanation.style.maxWidth = "880px";

  const pre = document.createElement("pre");

  pre.textContent = formatFailure(error);

  pre.style.cssText = [
    "max-width:1100px",
    "overflow:auto",
    "white-space:pre-wrap",
    "padding:16px",
    "border:1px solid rgba(255,255,255,.12)",
    "border-radius:10px",
    "background:#151f23",
  ].join(";");

  main.append(title, explanation, pre);
  root.append(main);
}

window.addEventListener("error", (event: ErrorEvent): void => {
  if (event.error !== undefined) {
    showStartupFailure(event.error);
  }
});

window.addEventListener(
  "unhandledrejection",
  (event: PromiseRejectionEvent): void => {
    showStartupFailure(event.reason);
  },
);

void import("./main.js").catch((error: unknown) => {
  showStartupFailure(error);
});
