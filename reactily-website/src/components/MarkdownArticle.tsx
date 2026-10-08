import { Check, Copy } from "lucide-react";
import { Children, isValidElement, useState } from "react";
import type { ReactNode } from "react";
import ReactMarkdown from "react-markdown";
import type { Components } from "react-markdown";
import { Link } from "react-router";
import remarkGfm from "remark-gfm";
import type { DocRecord } from "../lib/docs";
import { headingId, resolveDocHref } from "../lib/docs";

const LUAU_KEYWORDS = new Set([
  "and",
  "break",
  "continue",
  "do",
  "else",
  "elseif",
  "end",
  "export",
  "false",
  "for",
  "function",
  "if",
  "in",
  "local",
  "nil",
  "not",
  "or",
  "repeat",
  "return",
  "self",
  "then",
  "true",
  "type",
  "typeof",
  "until",
  "while",
]);

const LUAU_GLOBALS = new Set([
  "Color3",
  "CFrame",
  "Enum",
  "Instance",
  "Reactily",
  "UDim",
  "UDim2",
  "Vector2",
  "Vector3",
  "game",
  "workspace",
]);

type SyntaxTokenKind =
  | "comment"
  | "constant"
  | "function"
  | "keyword"
  | "number"
  | "property"
  | "punctuation"
  | "string"
  | "text"
  | "type";

type SyntaxToken = {
  readonly kind: SyntaxTokenKind;
  readonly value: string;
};

function flattenText(value: ReactNode): string {
  return Children.toArray(value)
    .map((child) => {
      if (typeof child === "string" || typeof child === "number") {
        return String(child);
      }

      if (isValidElement<{ children?: ReactNode }>(child)) {
        return flattenText(child.props.children);
      }

      return "";
    })
    .join("");
}

function nextNonWhitespaceCharacter(source: string, start: number): string {
  for (let index = start; index < source.length; index += 1) {
    const character = source[index];

    if (character !== undefined && !/\s/.test(character)) {
      return character;
    }
  }

  return "";
}

function previousNonWhitespaceCharacter(source: string, start: number): string {
  for (let index = start; index >= 0; index -= 1) {
    const character = source[index];

    if (character !== undefined && !/\s/.test(character)) {
      return character;
    }
  }

  return "";
}

function classifyIdentifier(
  source: string,
  value: string,
  start: number,
  end: number,
): SyntaxTokenKind {
  if (LUAU_KEYWORDS.has(value)) {
    if (value === "true" || value === "false" || value === "nil") {
      return "constant";
    }

    return "keyword";
  }

  const previousCharacter = previousNonWhitespaceCharacter(source, start - 1);
  const nextCharacter = nextNonWhitespaceCharacter(source, end);

  if (nextCharacter === "=" && previousCharacter !== ".") {
    return "property";
  }

  if (nextCharacter === "(") {
    return "function";
  }

  if (
    LUAU_GLOBALS.has(value) ||
    /^[A-Z][A-Za-z0-9_]*$/.test(value)
  ) {
    return "type";
  }

  if (previousCharacter === ".") {
    return "property";
  }

  return "text";
}

function tokenizeCode(source: string): readonly SyntaxToken[] {
  const tokens: SyntaxToken[] = [];
  let index = 0;

  while (index < source.length) {
    const rest = source.slice(index);

    const whitespaceMatch = /^\s+/.exec(rest);
    if (whitespaceMatch !== null) {
      tokens.push({ kind: "text", value: whitespaceMatch[0] });
      index += whitespaceMatch[0].length;
      continue;
    }

    if (rest.startsWith("--")) {
      const newlineIndex = rest.indexOf("\n");
      const value = newlineIndex === -1 ? rest : rest.slice(0, newlineIndex);
      tokens.push({ kind: "comment", value });
      index += value.length;
      continue;
    }

    const stringMatch = /^(?:"(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|`(?:\\.|[^`\\])*`)/.exec(rest);
    if (stringMatch !== null) {
      tokens.push({ kind: "string", value: stringMatch[0] });
      index += stringMatch[0].length;
      continue;
    }

    const numberMatch = /^(?:0x[\da-fA-F]+|\d+(?:\.\d+)?|\.\d+)/.exec(rest);
    if (numberMatch !== null) {
      tokens.push({ kind: "number", value: numberMatch[0] });
      index += numberMatch[0].length;
      continue;
    }

    const identifierMatch = /^[A-Za-z_][A-Za-z0-9_]*/.exec(rest);
    if (identifierMatch !== null) {
      const value = identifierMatch[0];
      tokens.push({
        kind: classifyIdentifier(source, value, index, index + value.length),
        value,
      });
      index += value.length;
      continue;
    }

    const character = source[index];

    if (character !== undefined) {
      tokens.push({ kind: "punctuation", value: character });
    }

    index += 1;
  }

  return tokens;
}

export function HighlightedCode({ source }: { readonly source: string }) {
  const tokens = tokenizeCode(source);

  return (
    <>
      {tokens.map((token, index) =>
        token.kind === "text" ? (
          token.value
        ) : (
          <span key={`${index}-${token.kind}`} className={`syntax-${token.kind}`}>
            {token.value}
          </span>
        ),
      )}
    </>
  );
}

function CodeContent({
  className,
  children,
}: {
  readonly className: string | undefined;
  readonly children?: ReactNode;
}) {
  const source = flattenText(children).replace(/\n$/, "");

  return (
    <code className={className}>
      <HighlightedCode source={source} />
    </code>
  );
}

function CopyablePre({ children }: { readonly children?: ReactNode }) {
  const [copied, setCopied] = useState(false);
  const text = flattenText(children).replace(/\n$/, "");

  const copy = async (): Promise<void> => {
    try {
      await navigator.clipboard.writeText(text);
      setCopied(true);
      window.setTimeout(() => setCopied(false), 1300);
    } catch (error) {
      console.error("[Reactily Docs] Failed to copy code", error);
    }
  };

  return (
    <div className="codeBlock">
      <div className="codeChrome">
        <span className="codeChromeLeft">
          <span className="codeDots" aria-hidden="true">
            <i />
            <i />
            <i />
          </span>
          <span className="codeLanguageLabel">Luau</span>
        </span>

        <button
          type="button"
          onClick={() => {
            void copy();
          }}
          aria-label="Copy code"
        >
          {copied ? <Check size={14} /> : <Copy size={14} />}
          {copied ? "Copied" : "Copy"}
        </button>
      </div>
      <pre>{children}</pre>
    </div>
  );
}

export function MarkdownArticle({ doc }: { readonly doc: DocRecord }) {
  const components: Components = {
    h2({ children }) {
      const text = flattenText(children);
      return <h2 id={headingId(text)}>{children}</h2>;
    },
    h3({ children }) {
      const text = flattenText(children);
      return <h3 id={headingId(text)}>{children}</h3>;
    },
    pre({ children }) {
      return <CopyablePre>{children}</CopyablePre>;
    },
    code({ className, children }) {
      return <CodeContent className={className}>{children}</CodeContent>;
    },
    a({ href, children }) {
      if (!href) return <span>{children}</span>;

      const resolved = resolveDocHref(doc, href);

      if (/^[a-z][a-z0-9+.-]*:/i.test(resolved) || resolved.startsWith("//")) {
        return (
          <a href={resolved} target="_blank" rel="noopener noreferrer">
            {children}
          </a>
        );
      }

      if (resolved.startsWith("#")) {
        return <a href={resolved}>{children}</a>;
      }

      return <Link to={resolved}>{children}</Link>;
    },
  };

  return (
    <ReactMarkdown remarkPlugins={[remarkGfm]} components={components}>
      {doc.body}
    </ReactMarkdown>
  );
}
