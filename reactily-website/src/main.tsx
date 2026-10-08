import { Component, StrictMode } from "react";
import type { ErrorInfo, ReactNode } from "react";
import { createRoot } from "react-dom/client";
import { BrowserRouter } from "react-router";

import { App } from "./App";
import "./styles.css";

type AppErrorBoundaryProps = {
  readonly children: ReactNode;
};

type AppErrorBoundaryState = {
  readonly error: Error | null;
};

class AppErrorBoundary extends Component<
  AppErrorBoundaryProps,
  AppErrorBoundaryState
> {
  public state: AppErrorBoundaryState = {
    error: null,
  };

  public static getDerivedStateFromError(
    error: Error,
  ): AppErrorBoundaryState {
    return {
      error,
    };
  }

  public componentDidCatch(
    error: Error,
    info: ErrorInfo,
  ): void {
    console.error(
      "[Reactily Docs] Unhandled render error",
      error,
      info,
    );
  }

  public render(): ReactNode {
    const { error } = this.state;

    if (error !== null) {
      return (
        <main
          style={{
            minHeight: "100vh",
            padding: "32px",
            background: "#0f171a",
            color: "#eef9fa",
            fontFamily:
              "ui-monospace, SFMono-Regular, Menlo, monospace",
          }}
        >
          <h1 style={{ marginTop: 0 }}>
            Reactily docs failed to render
          </h1>

          <p style={{ color: "#9db2b7" }}>
            The application hit a runtime error.
          </p>

          <pre
            style={{
              overflowX: "auto",
              padding: "16px",
              borderRadius: "8px",
              background: "#151f23",
              whiteSpace: "pre-wrap",
            }}
          >
            {error.stack ?? error.message}
          </pre>
        </main>
      );
    }

    return this.props.children;
  }
}

const rootElement = document.getElementById("root");

if (rootElement === null) {
  throw new Error(
    'React root element "#root" was not found.',
  );
}

const baseUrl = import.meta.env.BASE_URL;
const basename =
  baseUrl === "/"
    ? undefined
    : baseUrl.replace(/\/+$/, "");

const app = (
  <AppErrorBoundary>
    <App />
  </AppErrorBoundary>
);

const router =
  basename === undefined ? (
    <BrowserRouter>{app}</BrowserRouter>
  ) : (
    <BrowserRouter basename={basename}>{app}</BrowserRouter>
  );

createRoot(rootElement).render(
  <StrictMode>{router}</StrictMode>,
);
