import { Menu, Moon, Search, Sun, X } from "lucide-react";
import { useEffect, useState } from "react";
import { Link, useLocation } from "react-router";
import type { Theme } from "../lib/theme";
import { applyTheme, getInitialTheme } from "../lib/theme";
import { Brand } from "./Brand";
import { SearchDialog } from "./SearchDialog";
import { VersionSelector } from "./VersionSelector";

const navigation = [
  { label: "Learn", href: "/docs/intro", section: "learn" },
  { label: "API", href: "/api", section: "api" },
  { label: "Examples", href: "/docs/guides/examples", section: "examples" },
] as const;

export function Header() {
  const { pathname } = useLocation();
  const [theme, setTheme] = useState<Theme>(getInitialTheme);
  const [mobileOpen, setMobileOpen] = useState(false);
  const [searchOpen, setSearchOpen] = useState(false);

  const activeSection = pathname === "/api" || pathname.startsWith("/docs/api/")
    ? "api"
    : pathname === "/docs/guides/examples"
      ? "examples"
      : pathname.startsWith("/docs/")
        ? "learn"
        : undefined;

  useEffect(() => {
    applyTheme(theme);
  }, [theme]);

  useEffect(() => {
    setMobileOpen(false);
  }, [pathname]);

  useEffect(() => {
    const onKeyDown = (event: KeyboardEvent): void => {
      if ((event.metaKey || event.ctrlKey) && event.key.toLowerCase() === "k") {
        event.preventDefault();
        setSearchOpen(true);
      }

      if (event.key === "Escape") {
        setSearchOpen(false);
        setMobileOpen(false);
      }
    };

    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, []);

  const links = (mobile: boolean) => navigation.map((item) => (
    <Link
      key={item.section}
      to={item.href}
      className={activeSection === item.section ? "active" : undefined}
      aria-current={pathname === item.href ? "page" : undefined}
      onClick={mobile ? () => setMobileOpen(false) : undefined}
    >
      {item.label}
    </Link>
  ));

  return (
    <>
      <header className="siteHeader">
        <div className="headerInner">
          <Brand />
          <nav className="desktopNav" aria-label="Primary navigation">
            {links(false)}
          </nav>
          <div className="headerActions">
            <VersionSelector />
            <button
              className="searchButton"
              type="button"
              onClick={() => setSearchOpen(true)}
              aria-label="Search Reactily documentation"
              title="Search documentation (Ctrl/Command + K)"
            >
              <Search size={16} aria-hidden="true" />
              <span>Search</span>
              <kbd>⌘K</kbd>
            </button>
            <button
              className="iconButton"
              type="button"
              aria-label={theme === "dark" ? "Switch to light theme" : "Switch to dark theme"}
              onClick={() => setTheme((current) => current === "dark" ? "light" : "dark")}
            >
              {theme === "dark" ? <Sun size={17} /> : <Moon size={17} />}
            </button>
            <button
              className="iconButton mobileMenuButton"
              type="button"
              aria-label={mobileOpen ? "Close navigation" : "Open navigation"}
              aria-expanded={mobileOpen}
              aria-controls="mobile-primary-navigation"
              onClick={() => setMobileOpen((current) => !current)}
            >
              {mobileOpen ? <X size={18} /> : <Menu size={18} />}
            </button>
          </div>
        </div>
        {mobileOpen ? (
          <nav
            id="mobile-primary-navigation"
            className="mobileNav"
            aria-label="Mobile navigation"
          >
            {links(true)}
          </nav>
        ) : null}
      </header>
      {searchOpen ? (
        <SearchDialog open={searchOpen} onClose={() => setSearchOpen(false)} />
      ) : null}
    </>
  );
}
