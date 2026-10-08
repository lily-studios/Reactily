export type Theme = "light" | "dark";

const storageKey = "reactily-theme";

function readStoredTheme(): Theme | null {
  try {
    const saved = window.localStorage.getItem(storageKey);
    return saved === "light" || saved === "dark" ? saved : null;
  } catch {
    return null;
  }
}

export function getInitialTheme(): Theme {
  const saved = readStoredTheme();
  if (saved) return saved;

  try {
    return window.matchMedia("(prefers-color-scheme: light)").matches ? "light" : "dark";
  } catch {
    return "dark";
  }
}

export function applyTheme(theme: Theme): void {
  document.documentElement.dataset.theme = theme;

  try {
    window.localStorage.setItem(storageKey, theme);
  } catch {
    // Storage can be unavailable in privacy-restricted browser contexts.
  }
}
