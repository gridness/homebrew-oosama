const { spawn } = require("node:child_process");
const { readFileSync, realpathSync } = require("node:fs");
const { dirname, join, isAbsolute, relative } = require("node:path");
const { runMain } = require("node:module");

const executable = realpathSync(process.execPath);
const root = join(dirname(executable), "app");
const args = process.argv.slice(2);
const runtimeFlags = [];
let command = executable;
try {
  // Homebrew writes its stable opt path so upgrades keep agent registrations valid.
  command = readFileSync(join(dirname(executable), "command-path"), "utf8").trim();
} catch (error) {
  if (error.code !== "ENOENT") throw error;
}

// Upstream workers pass V8 limits before their script. SEA accepts runtime
// options through --node-options, preserving those limits in the embedded VM.
while (
  /^(?:--(?:max-old-space-size|max-semi-space-size|v8-pool-size|stack_size)=\d+|--(?:expose-gc|single-threaded))$/.test(args[0] ?? "")
) {
  runtimeFlags.push(args.shift());
}

let script;
if (args[0] && isAbsolute(args[0]) && /\.(?:js|mjs|cjs)$/.test(args[0])) {
  try {
    const candidate = realpathSync(args[0]);
    // ASVS 2.2.1: script execution is limited to installed runtime resources.
    if (!relative(root, candidate).startsWith("..")) script = candidate;
  } catch {
    // Ordinary CLI arguments continue through the upstream argument parser.
  }
}

if (script && runtimeFlags.length) {
  // ASVS 1.2.5: forward worker arguments directly without a shell.
  const child = spawn(
    executable,
    [`--node-options=${runtimeFlags.join(" ")}`, script, ...args.slice(1)],
    { stdio: "inherit" },
  );
  const signals = ["SIGINT", "SIGTERM", "SIGHUP"];
  const handlers = signals.map((signal) => {
    const handler = () => child.kill(signal);
    process.on(signal, handler);
    return handler;
  });
  child.once("error", (error) => {
    console.error(error.message);
    process.exitCode = 1;
  });
  child.once("exit", (code, signal) => {
    signals.forEach((name, index) => process.off(name, handlers[index]));
    if (signal) process.kill(process.pid, signal);
    else process.exitCode = code ?? 1;
  });
} else if (script) {
  process.argv = [executable, script, ...args.slice(1)];
  runMain(script);
} else if (args[0] === "update" && !args.includes("--help")) {
  console.log("Upgrade this installation with: brew upgrade gridness/oosama/rea");
} else {
  // Agent setup registers the installed binary. Upstream module paths remain
  // intact for native addons, bridge files, bundled skills, and worker scripts.
  process.argv = [executable, command, ...runtimeFlags, ...args];
  runMain(join(root, "node_modules/rea-agents/scripts/rea.mjs"));
}
