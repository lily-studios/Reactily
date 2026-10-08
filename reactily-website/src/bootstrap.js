/* ============================================================
 * Reactily · Lily Studios
 * Startup diagnostics
 * ============================================================ */

const root = document.getElementById("root");

try {
  await import("./main.tsx");
} catch (error) {
  console.error("[Reactily Docs] Failed to start", error);

  if (root) {
    const message =
      error instanceof Error ? error.stack ?? error.message : String(error);
    const screen = document.createElement("main");
    const heading = document.createElement("h1");
    const description = document.createElement("p");
    const details = document.createElement("pre");

    screen.style.cssText =
      "min-height:100vh;padding:32px;background:#0f171a;color:#eef9fa;font-family:ui-monospace,monospace";
    heading.textContent = "Reactily docs failed to start";
    description.textContent =
      "The application could not load. The startup error is shown below.";
    details.style.cssText =
      "overflow-wrap:anywhere;white-space:pre-wrap;padding:16px;background:#151f23;border-radius:8px";
    details.textContent = message;
    screen.append(heading, description, details);
    root.replaceChildren(screen);
  }
}
