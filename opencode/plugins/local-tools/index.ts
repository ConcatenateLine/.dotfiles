// OpenCode V2 plugin tool template.
// Source of truth: dotfiles/opencode/plugins/local-tools/index.ts
//
// `import type` is intentional: the deployed copy lives under
// ~/.config/opencode/plugins/ and must run without a node_modules tree
// (home-manager copies it from the read-only nix store).
import type { Plugin } from "@opencode/plugin"
import { execFile } from "node:child_process"
import { access, readFile } from "node:fs/promises"
import { join } from "node:path"
import { promisify } from "node:util"

const exec = promisify(execFile)

type PackageManager = "npm" | "pnpm" | "yarn" | "bun"
type Input = { action: "detect" | "run"; script?: string; args?: string[] }

const LOCKFILES = [
  ["pnpm-lock.yaml", "pnpm"],
  ["yarn.lock", "yarn"],
  ["bun.lock", "bun"],
  ["bun.lockb", "bun"],
  ["package-lock.json", "npm"],
] as const satisfies ReadonlyArray<readonly [string, PackageManager]>

async function exists(path: string): Promise<boolean> {
  try {
    await access(path)
    return true
  } catch {
    return false
  }
}

async function detect(cwd: string): Promise<{ pm: PackageManager; lockfile: string | null }> {
  for (const [lockfile, pm] of LOCKFILES) {
    if (await exists(join(cwd, lockfile))) return { pm, lockfile }
  }
  return { pm: "npm", lockfile: null }
}

function parseInput(value: unknown): Input {
  if (typeof value !== "object" || value === null) throw new Error("invalid input")
  const v = value as Record<string, unknown>
  if (v.action !== "detect" && v.action !== "run") throw new Error("action must be 'detect' or 'run'")
  if (v.action === "run" && typeof v.script !== "string") throw new Error("action 'run' requires a 'script'")
  if (v.args !== undefined && (!Array.isArray(v.args) || v.args.some((a) => typeof a !== "string"))) {
    throw new Error("'args' must be an array of strings")
  }
  return {
    action: v.action,
    script: typeof v.script === "string" ? v.script : undefined,
    args: v.args as string[] | undefined,
  }
}

const plugin: Plugin.Plugin = {
  id: "local-tools",
  async setup(ctx) {
    await ctx.tool.transform((editor) => {
      editor.add({
        name: "pkg",
        description:
          "Detect the package manager for the current project (detect), or run a package.json script with it (run). Use this instead of guessing npm/pnpm/yarn/bun.",
        input: {
          type: "object",
          properties: {
            action: { type: "string", enum: ["detect", "run"] },
            script: { type: "string", description: "package.json script name (required for action: run)" },
            args: { type: "array", items: { type: "string" }, description: "Extra arguments passed after --" },
          },
          required: ["action"],
          additionalProperties: false,
        },
        async execute(raw, context) {
          const input = parseInput(raw)

          // V2: the server's process.cwd() is not the project. Always use the session location.
          const session = await ctx.session.get({ sessionID: context.sessionID })
          const cwd = session.location.directory
          const { pm, lockfile } = await detect(cwd)

          if (input.action === "detect") {
            const text = await readFile(join(cwd, "package.json"), "utf8").catch(() => "{}")
            let scripts: string[] = []
            try {
              scripts = Object.keys((JSON.parse(text) as { scripts?: Record<string, string> }).scripts ?? {})
            } catch {
              // package.json may be absent or malformed; detection still succeeds
            }
            return {
              content: JSON.stringify({ cwd, pm, lockfile, scripts }, null, 2),
              metadata: { pm, lockfile },
            }
          }

          const argv = ["run", input.script!, ...(input.args?.length ? ["--", ...input.args] : [])]
          const command = [pm, ...argv].join(" ")

          // Custom "pkg" action: not covered by the shell rules, so it prompts on its own.
          await ctx.permission.assert({
            sessionID: context.sessionID,
            agent: context.agent,
            action: "pkg",
            resources: [command],
            save: [command],
            source: { type: "tool", messageID: context.messageID, id: context.id },
          })

          try {
            const { stdout, stderr } = await exec(pm, argv, {
              cwd,
              signal: context.signal,
              timeout: 120_000,
              maxBuffer: 4 * 1024 * 1024,
              encoding: "utf8",
            })
            const output = [stdout.trim(), stderr.trim()].filter(Boolean).join("\n")
            return { content: output || "(no output)" }
          } catch (e) {
            const err = e as { stdout?: string; stderr?: string; message: string }
            throw new Error(`${command} failed:\n${(err.stderr || err.stdout || err.message).trim()}`)
          }
        },
      })
    })
  },
}

export default plugin
