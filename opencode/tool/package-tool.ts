import { tool } from "@opencode-ai/plugin/tool"
import { execSync } from "node:child_process"
import { readFile } from "node:fs/promises"
import { join, resolve } from "node:path"

function runShell(cmd: string, cwd?: string): string {
  try {
    return execSync(cmd, {
      cwd: cwd || process.cwd(),
      encoding: "utf-8",
      stdio: ["ignore", "pipe", "pipe"],
    }).trim()
  } catch (e: unknown) {
    const err = e as { stdout?: Buffer; stderr?: Buffer; message?: string }
    return err.stdout?.toString().trim() || err.stderr?.toString().trim() || err.message || "Unknown error"
  }
}

function detectPackageManager(cwd: string): "npm" | "pnpm" | "yarn" | "bun" {
  const files = ["pnpm-lock.yaml", "yarn.lock", "bun.lockb", "package-lock.json"]
  for (const f of files) {
    try {
      readFile(resolve(cwd, f))
      if (f === "pnpm-lock.yaml") return "pnpm"
      if (f === "yarn.lock") return "yarn"
      if (f === "bun.lockb") return "bun"
      return "npm"
    } catch {
      // continue
    }
  }
  return "npm"
}

function getPmCommands(pm: string) {
  const cmds: Record<string, { install: string; add: string; remove: string; update: string; audit: string; outdated: string; run: string; list: string }> = {
    npm: { install: "ci", add: "install", remove: "uninstall", update: "update", audit: "audit", outdated: "outdated", run: "run", list: "list" },
    pnpm: { install: "install --frozen-lockfile", add: "add", remove: "remove", update: "update", audit: "audit", outdated: "outdated", run: "run", list: "list" },
    yarn: { install: "install --frozen-lockfile", add: "add", remove: "remove", update: "upgrade", audit: "audit", outdated: "outdated", run: "run", list: "list" },
    bun: { install: "install --frozen-lockfile", add: "add", remove: "remove", update: "update", audit: "audit", outdated: "outdated", run: "run", list: "ls" },
  }
  return cmds[pm] || cmds.npm
}

export const packageInstall = tool({
  description: "Install dependencies using detected package manager",
  args: {
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
    frozen: tool.schema.boolean().optional().default(true).describe("Use frozen lockfile (ci/install --frozen-lockfile)"),
    production: tool.schema.boolean().optional().default(false).describe("Install only production dependencies"),
  },
  async execute(args) {
    const cwd = args.cwd || process.cwd()
    const pm = detectPackageManager(cwd)
    const cmds = getPmCommands(pm)
    let cmd = `${pm} ${cmds.install}`
    if (!args.frozen && pm !== "npm") cmd = `${pm} install`
    if (args.production) cmd += " --production"
    return runShell(cmd, cwd)
  },
})

export const packageAdd = tool({
  description: "Add a new dependency",
  args: {
    packages: tool.schema.array(tool.schema.string()).describe("Package names to add (e.g., 'lodash', 'react@18')"),
    dev: tool.schema.boolean().optional().default(false).describe("Add as dev dependency"),
    peer: tool.schema.boolean().optional().default(false).describe("Add as peer dependency (pnpm/yarn only)"),
    optional: tool.schema.boolean().optional().default(false).describe("Add as optional dependency"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
  },
  async execute(args) {
    const cwd = args.cwd || process.cwd()
    const pm = detectPackageManager(cwd)
    const cmds = getPmCommands(pm)
    let cmd = `${pm} ${cmds.add}`
    if (args.dev) cmd += " -D"
    else if (args.peer && pm !== "npm") cmd += " -P"
    else if (args.optional && pm !== "npm") cmd += " -O"
    cmd += " " + args.packages.join(" ")
    return runShell(cmd, cwd)
  },
})

export const packageRemove = tool({
  description: "Remove a dependency",
  args: {
    packages: tool.schema.array(tool.schema.string()).describe("Package names to remove"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
  },
  async execute(args) {
    const cwd = args.cwd || process.cwd()
    const pm = detectPackageManager(cwd)
    const cmds = getPmCommands(pm)
    return runShell(`${pm} ${cmds.remove} ${args.packages.join(" ")}`, cwd)
  },
})

export const packageUpdate = tool({
  description: "Update dependencies",
  args: {
    packages: tool.schema.array(tool.schema.string()).optional().describe("Specific packages to update (default: all)"),
    latest: tool.schema.boolean().optional().default(false).describe("Update to latest version (ignore semver)"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
  },
  async execute(args) {
    const cwd = args.cwd || process.cwd()
    const pm = detectPackageManager(cwd)
    const cmds = getPmCommands(pm)
    let cmd = `${pm} ${cmds.update}`
    if (args.latest && pm === "npm") cmd += " --latest"
    if (args.latest && pm === "yarn") cmd += " --latest"
    if (args.latest && pm === "pnpm") cmd += " --latest"
    if (args.packages?.length) cmd += " " + args.packages.join(" ")
    return runShell(cmd, cwd)
  },
})

export const packageAudit = tool({
  description: "Run security audit on dependencies",
  args: {
    fix: tool.schema.boolean().optional().default(false).describe("Attempt to fix vulnerabilities automatically"),
    level: tool.schema.enum(["low", "moderate", "high", "critical"]).optional().describe("Minimum severity level to report"),
    json: tool.schema.boolean().optional().default(false).describe("Output JSON format"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
  },
  async execute(args) {
    const cwd = args.cwd || process.cwd()
    const pm = detectPackageManager(cwd)
    const cmds = getPmCommands(pm)
    let cmd = `${pm} ${cmds.audit}`
    if (args.fix) cmd += " --fix"
    if (args.level) cmd += ` --audit-level=${args.level}`
    if (args.json && pm === "npm") cmd += " --json"
    if (args.json && pm === "yarn") cmd += " --json"
    return runShell(cmd, cwd)
  },
})

export const packageOutdated = tool({
  description: "Check for outdated dependencies",
  args: {
    json: tool.schema.boolean().optional().default(false).describe("Output JSON format"),
    depth: tool.schema.number().optional().default(0).describe("Depth of dependency tree to check"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
  },
  async execute(args) {
    const cwd = args.cwd || process.cwd()
    const pm = detectPackageManager(cwd)
    const cmds = getPmCommands(pm)
    let cmd = `${pm} ${cmds.outdated}`
    if (args.json && pm === "npm") cmd += " --json"
    if (args.json && pm === "yarn") cmd += " --json"
    if (args.json && pm === "pnpm") cmd += " --json"
    if (args.depth > 0 && pm === "npm") cmd += ` --depth=${args.depth}`
    return runShell(cmd, cwd)
  },
})

export const packageRun = tool({
  description: "Run a package.json script",
  args: {
    script: tool.schema.string().describe("Script name to run"),
    args: tool.schema.array(tool.schema.string()).optional().describe("Additional arguments to pass to script"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
  },
  async execute(args) {
    const cwd = args.cwd || process.cwd()
    const pm = detectPackageManager(cwd)
    const cmds = getPmCommands(pm)
    const extra = args.args?.length ? " -- " + args.args.join(" ") : ""
    return runShell(`${pm} ${cmds.run} ${args.script}${extra}`, cwd)
  },
})

export const packageList = tool({
  description: "List installed packages",
  args: {
    depth: tool.schema.number().optional().default(0).describe("Depth of dependency tree (0 = top-level only)"),
    prod: tool.schema.boolean().optional().default(false).describe("Production dependencies only"),
    dev: tool.schema.boolean().optional().default(false).describe("Dev dependencies only"),
    json: tool.schema.boolean().optional().default(false).describe("Output JSON format"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
  },
  async execute(args) {
    const cwd = args.cwd || process.cwd()
    const pm = detectPackageManager(cwd)
    const cmds = getPmCommands(pm)
    let cmd = `${pm} ${cmds.list}`
    if (args.depth > 0) cmd += ` --depth=${args.depth}`
    if (args.prod && pm === "npm") cmd += " --production"
    if (args.prod && pm === "yarn") cmd += " --production"
    if (args.prod && pm === "pnpm") cmd += " --prod"
    if (args.dev && pm === "npm") cmd += " --development"
    if (args.dev && pm === "yarn") cmd += " --development"
    if (args.dev && pm === "pnpm") cmd += " --dev"
    if (args.json && pm === "npm") cmd += " --json"
    if (args.json && pm === "yarn") cmd += " --json"
    if (args.json && pm === "pnpm") cmd += " --json"
    return runShell(cmd, cwd)
  },
})

export const packageInfo = tool({
  description: "Get package.json info or check a specific package",
  args: {
    name: tool.schema.string().optional().describe("Package name to check (default: read local package.json)"),
    field: tool.schema.string().optional().describe("Specific field to extract (version, dependencies, scripts, etc.)"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
    registry: tool.schema.boolean().optional().default(false).describe("Query npm registry for latest info"),
  },
  async execute(args) {
    const cwd = args.cwd || process.cwd()
    if (!args.name) {
      try {
        const pkg = JSON.parse(await readFile(resolve(cwd, "package.json"), "utf-8"))
        if (args.field) {
          const keys = args.field.split(".")
          let val: any = pkg
          for (const k of keys) val = val?.[k]
          return JSON.stringify(val, null, 2)
        }
        return JSON.stringify(pkg, null, 2)
      } catch {
        return "No package.json found"
      }
    }

    if (args.registry) {
      const pm = detectPackageManager(cwd)
      const cmd = `${pm} view ${args.name}${args.field ? " " + args.field : ""} --json 2>/dev/null || ${pm} view ${args.name}${args.field ? " " + args.field : ""}`
      return runShell(cmd, cwd)
    }

    try {
      const pkg = JSON.parse(await readFile(resolve(cwd, "package.json"), "utf-8"))
      const deps = { ...pkg.dependencies, ...pkg.devDependencies, ...pkg.peerDependencies, ...pkg.optionalDependencies }
      const version = deps[args.name]
      return version ? `${args.name}@${version}` : "Not installed"
    } catch {
      return "No package.json found"
    }
  },
})

export const packageInit = tool({
  description: "Initialize a new package.json",
  args: {
    name: tool.schema.string().optional().describe("Package name"),
    version: tool.schema.string().optional().default("1.0.0").describe("Initial version"),
    description: tool.schema.string().optional().describe("Package description"),
    main: tool.schema.string().optional().describe("Entry point"),
    license: tool.schema.string().optional().default("MIT").describe("License"),
    private: tool.schema.boolean().optional().default(false).describe("Private package"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
    yes: tool.schema.boolean().optional().default(true).describe("Accept all defaults"),
  },
  async execute(args) {
    const cwd = args.cwd || process.cwd()
    const pm = detectPackageManager(cwd)
    let cmd = `${pm} init`
    if (args.yes) cmd += " -y"
    if (args.name) cmd += ` --name="${args.name}"`
    if (args.version) cmd += ` --version="${args.version}"`
    if (args.description) cmd += ` --description="${args.description}"`
    if (args.main) cmd += ` --main="${args.main}"`
    if (args.license) cmd += ` --license="${args.license}"`
    if (args.private) cmd += " --private"
    return runShell(cmd, cwd)
  },
})

export const packageLockSync = tool({
  description: "Sync package-lock / lockfile with package.json",
  args: {
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
  },
  async execute(args) {
    const cwd = args.cwd || process.cwd()
    const pm = detectPackageManager(cwd)
    if (pm === "npm") return runShell("npm install --package-lock-only", cwd)
    if (pm === "pnpm") return runShell("pnpm install --lockfile-only", cwd)
    if (pm === "yarn") return runShell("yarn install --mode=update-lockfile", cwd)
    if (pm === "bun") return runShell("bun install --lockfile-only", cwd)
    return "Unknown package manager"
  },
})