/** Normalize Luau examples without changing executable statements. */
export function formatLuauCode(source: string, signature = false): string {
  const lines = source.replace(/\r\n?/g, "\n").split("\n");
  while (lines[0]?.trim() === "") lines.shift();
  while (lines.at(-1)?.trim() === "") lines.pop();

  const expanded = lines.map((line) => line.replace(/\t/g, "    ").replace(/[ \t]+$/g, ""));
  const indentation = Math.min(
    ...expanded.filter((line) => line.trim().length > 0).map((line) => line.match(/^ */)?.[0].length ?? 0),
  );
  const dedented = expanded.map((line) => line.trim().length ? line.slice(indentation) : "");
  const compact: string[] = [];

  for (const line of dedented) {
    if (line === "" && compact.at(-1) === "") continue;
    compact.push(line);
  }

  const result = compact.join("\n");
  return signature ? wrapSignature(result) : result;
}

/** Wrap only single-line public signatures; keep function calls and code intact. */
function wrapSignature(source: string): string {
  if (source.includes("\n") || source.length < 92 || !source.startsWith("Reactily.")) return source;
  const open = source.indexOf("(");
  if (open < 0) return source;
  let nesting = 0;
  let close = -1;
  for (let index = open; index < source.length; index += 1) {
    if (source[index] === "(") nesting += 1;
    if (source[index] === ")") {
      nesting -= 1;
      if (nesting === 0) { close = index; break; }
    }
  }
  if (close < 0 || !source.slice(close + 1).startsWith(":")) return source;
  const argumentsText = source.slice(open + 1, close).trim();
  if (!argumentsText) return source;
  const parameters: string[] = [];
  let beginning = 0;
  let round = 0;
  let curly = 0;
  let square = 0;
  let angle = 0;
  for (let index = 0; index < argumentsText.length; index += 1) {
    const character = argumentsText[index];
    if (character === "(") round += 1;
    else if (character === ")") round -= 1;
    else if (character === "{") curly += 1;
    else if (character === "}") curly -= 1;
    else if (character === "[") square += 1;
    else if (character === "]") square -= 1;
    else if (character === "<") angle += 1;
    else if (character === ">" && angle > 0) angle -= 1;
    else if (character === "," && round === 0 && curly === 0 && square === 0 && angle === 0) {
      parameters.push(argumentsText.slice(beginning, index).trim());
      beginning = index + 1;
    }
  }
  parameters.push(argumentsText.slice(beginning).trim());
  if (parameters.length < 2 || parameters.some((parameter) => !parameter)) return source;
  return `${source.slice(0, open + 1)}\n${parameters.map((parameter) => `    ${parameter}`).join(",\n")}\n${source.slice(close)}`;
}

/** Normalize code fences and vertical rhythm across every documentation page. */
export function formatDocumentationMarkdown(source: string): string {
  const lines = source.replace(/\r\n?/g, "\n").split("\n");
  const output: string[] = [];
  let index = 0;
  let section = "";

  const blank = (): void => {
    if (output.length > 0 && output.at(-1) !== "") output.push("");
  };

  while (index < lines.length) {
    const line = lines[index] ?? "";
    const fence = /^\s*(`{3,})([^`]*$)/.exec(line);
    if (fence) {
      blank();
      const marker = fence[1] ?? "```";
      const languageInfo = (fence[2] ?? "").trim().toLowerCase();
      // A fence such as "luau experimental" marks just that example as experimental.
      const experimentalFence = /^([a-z0-9_+.-]+)\s+experimental$/.exec(languageInfo);
      const language = experimentalFence?.[1] ?? languageInfo;
      output.push(`${marker}${experimentalFence ? `${language}-experimental` : language}`);
      const body: string[] = [];
      index += 1;
      while (index < lines.length && !lines[index]?.trim().startsWith(marker)) {
        body.push(lines[index] ?? "");
        index += 1;
      }
      if (language === "luau" || language === "lua") {
        output.push(...formatLuauCode(body.join("\n"), section === "signature").split("\n"));
      } else {
        output.push(...body.map((part) => part.replace(/[ \t]+$/g, "")));
      }
      output.push(marker);
      index += 1;
      blank();
      continue;
    }
    const heading = /^(#{1,6})\s+(.+)$/.exec(line);
    if (heading) {
      section = (heading[2] ?? "").replace(/[`*_]/g, "").toLowerCase().trim();
      blank();
      output.push(line.trimEnd());
      blank();
    } else if (line.trim() === "") {
      blank();
    } else {
      output.push(line.replace(/[ \t]+$/g, ""));
    }
    index += 1;
  }
  return output.join("\n").trim();
}
