
/* ============================================================
 * Reactily · Lily Studios
 * Documentation Header
 * ============================================================ */

import {
  Menu,
  Moon,
  Search,
  Sun,
  X,
} from "lucide-react";

import {
  lazy,
  Suspense,
  useEffect,
  useState,
} from "react";

import { NavLink } from "react-router";

import type { Theme } from "../lib/theme";

import {
  applyTheme,
  getInitialTheme,
} from "../lib/theme";

import { Brand } from "./Brand";
import { VersionSelector } from "./VersionSelector";

/* ============================================================
 * Lazy-Loaded Search
 * ============================================================ */

const SearchDialog = lazy(() =>
  import("./SearchDialog").then((module) => ({
    default: module.SearchDialog,
  })),
);

/* ============================================================
 * Header
 * ============================================================ */

export function Header() {
  /* ==========================================================
   * State
   * ========================================================== */

  const [theme, setTheme] = useState<Theme>(
    getInitialTheme,
  );

  const [mobileOpen, setMobileOpen] = useState(false);

  const [searchOpen, setSearchOpen] = useState(false);

  /* ==========================================================
   * Theme
   * ========================================================== */

  useEffect(() => {
    applyTheme(theme);
  }, [theme]);

  /* ==========================================================
   * Keyboard Shortcuts
   * ========================================================== */

  useEffect(() => {
    const onKeyDown = (event: KeyboardEvent): void => {
      if (
        (event.metaKey || event.ctrlKey) &&
        event.key.toLowerCase() === "k"
      ) {
        event.preventDefault();
        setSearchOpen(true);
      }

      if (event.key === "Escape") {
        setSearchOpen(false);
        setMobileOpen(false);
      }
    };

    window.addEventListener("keydown", onKeyDown);

    return () => {
      window.removeEventListener("keydown", onKeyDown);
    };
  }, []);

  /* ==========================================================
   * Navigation
   * ========================================================== */

  const closeMobile = (): void => {
    setMobileOpen(false);
  };

  /* ==========================================================
   * Render
   * ========================================================== */

  return (
    <>
      <header className="siteHeader">
        <div className="headerInner">
          <Brand />

          {/* ================================================
           * Desktop Navigation
           * ================================================ */}

          <nav
            className="desktopNav"
            aria-label="Primary navigation"
          >
            <NavLink to="/docs/intro">
              Learn
            </NavLink>

            <NavLink to="/api">
              API
            </NavLink>

            <NavLink to="/docs/guides/examples">
              Examples
            </NavLink>
          </nav>

          {/* ================================================
           * Header Actions
           * ================================================ */}

          <div className="headerActions">
            <VersionSelector />

            {/* Search */}

            <button
              className="searchButton"
              type="button"
              onClick={() => {
                setSearchOpen(true);
              }}
              aria-label="Search Reactily documentation"
            >
              <Search
                size={16}
                aria-hidden="true"
              />

              <span>Search</span>

              <kbd>⌘K</kbd>
            </button>

            {/* Theme Toggle */}

            <button
              className="iconButton"
              type="button"
              aria-label={`Switch to ${
                theme === "dark" ? "light" : "dark"
              } theme`}
              onClick={() => {
                setTheme((current: Theme): Theme =>
                  current === "dark" ? "light" : "dark",
                );
              }}
            >
              {theme === "dark" ? (
                <Sun size={17} />
              ) : (
                <Moon size={17} />
              )}
            </button>

            {/* Mobile Navigation Toggle */}

            <button
              className="iconButton mobileMenuButton"
              type="button"
              aria-label={
                mobileOpen
                  ? "Close navigation"
                  : "Open navigation"
              }
              aria-expanded={mobileOpen}
              onClick={() => {
                setMobileOpen(
                  (current: boolean): boolean => !current,
                );
              }}
            >
              {mobileOpen ? (
                <X size={18} />
              ) : (
                <Menu size={18} />
              )}
            </button>
          </div>
        </div>

        {/* ==================================================
         * Mobile Navigation
         * ================================================== */}

        {mobileOpen ? (
          <nav
            className="mobileNav"
            aria-label="Mobile navigation"
          >
            <NavLink
              to="/docs/intro"
              onClick={closeMobile}
            >
              Learn
            </NavLink>

            <NavLink
              to="/api"
              onClick={closeMobile}
            >
              API Reference
            </NavLink>

            <NavLink
              to="/docs/guides/examples"
              onClick={closeMobile}
            >
              Examples
            </NavLink>
          </nav>
        ) : null}
      </header>

      {/* ====================================================
       * Lazy Search Dialog
       * ==================================================== */}

      {searchOpen ? (
        <Suspense fallback={null}>
          <SearchDialog
            open={searchOpen}
            onClose={() => {
              setSearchOpen(false);
            }}
          />
        </Suspense>
      ) : null}
    </>
  );
}
