import { tool } from "@opencode-ai/plugin/tool"
import { glob } from "node:fs/promises"
import { readFile, writeFile, stat, readdir, mkdir } from "node:fs/promises"
import { join, relative, resolve } from "node:path"
import { execSync } from "node:child_process"

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

export const findFiles = tool({
  description: "Find files matching a glob pattern",
  args: {
    pattern: tool.schema.string().describe("Glob pattern (e.g., '**/*.ts', 'src/**/*.test.ts')"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
    maxResults: tool.schema.number().optional().default(100).describe("Maximum results to return"),
  },
  async execute(args: { pattern: string; cwd?: string; maxResults: number }) {
    const cwd = args.cwd || process.cwd()
    const results: string[] = []
    for await (const file of glob(args.pattern, { cwd })) {
      results.push(file)
      if (results.length >= args.maxResults) break
    }
    return results.join("\n") || "No files found"
  },
})

export const readMultipleFiles = tool({
  description: "Read multiple files at once",
  args: {
    paths: tool.schema.array(tool.schema.string()).describe("Array of file paths to read"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
  },
  async execute(args: { paths: string[]; cwd?: string }) {
    const cwd = args.cwd || process.cwd()
    const results: Array<{ path: string; content: string; error?: string }> = []
    for (const path of args.paths) {
      const fullPath = resolve(cwd, path)
      try {
        const content = await readFile(fullPath, "utf-8")
        results.push({ path, content })
      } catch (e: unknown) {
        const err = e as { code?: string; message?: string }
        results.push({ path, content: "", error: err.code === "ENOENT" ? "File not found" : err.message })
      }
    }
    return JSON.stringify(results, null, 2)
  },
})

export const getFileInfo = tool({
  description: "Get detailed file/directory information (size, modified time, permissions, type)",
  args: {
    paths: tool.schema.array(tool.schema.string()).describe("Array of file/directory paths"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
  },
  async execute(args: { paths: string[]; cwd?: string }) {
    const cwd = args.cwd || process.cwd()
    const results = []
    for (const path of args.paths) {
      const fullPath = resolve(cwd, path)
      try {
        const s = await stat(fullPath)
        results.push({
          path,
          size: s.size,
          isDirectory: s.isDirectory(),
          isFile: s.isFile(),
          modified: s.mtime.toISOString(),
          created: s.birthtime.toISOString(),
          permissions: (s.mode & 0o777).toString(8),
        })
      } catch (e: unknown) {
        const err = e as { code?: string; message?: string }
        results.push({ path, error: err.code === "ENOENT" ? "Not found" : err.message })
      }
    }
    return JSON.stringify(results, null, 2)
  },
})

export const listDirectory = tool({
  description: "List directory contents with details",
  args: {
    path: tool.schema.string().optional().default(".").describe("Directory path"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
    recursive: tool.schema.boolean().optional().default(false).describe("Recurse into subdirectories"),
    maxDepth: tool.schema.number().optional().default(3).describe("Max recursion depth"),
  },
  async execute(args: { path?: string; cwd?: string; recursive?: boolean; maxDepth?: number }) {
    const cwd = args.cwd || process.cwd()
    const targetDir = resolve(cwd, args.path || ".")

    async function listDir(dir: string, depth: number): Promise<Array<{ name: string; path: string; type: string; size: number; modified: string }>> {
      if (depth > (args.maxDepth || 3)) return []
      const entries = await readdir(dir, { withFileTypes: true })
      const results = []
      for (const entry of entries) {
        const fullPath = join(dir, entry.name)
        const relPath = relative(cwd, fullPath)
        const s = await stat(fullPath)
        const info = {
          name: entry.name,
          path: relPath,
          type: entry.isDirectory() ? "directory" : entry.isFile() ? "file" : "other",
          size: s.size,
          modified: s.mtime.toISOString(),
        }
        results.push(info)
        if (entry.isDirectory() && args.recursive && depth < (args.maxDepth || 3)) {
          results.push(...(await listDir(fullPath, depth + 1)))
        }
      }
      return results
    }

    try {
      const results = await listDir(targetDir, 0)
      return JSON.stringify(results, null, 2)
    } catch (e: unknown) {
      const err = e as { code?: string; message?: string }
      return `Error: ${err.code === "ENOENT" ? "Directory not found" : err.message}`
    }
  },
})

export const searchInFiles = tool({
  description: "Search for a pattern across multiple files (like grep)",
  args: {
    pattern: tool.schema.string().describe("Regex pattern to search for"),
    include: tool.schema.string().optional().default("**/*").describe("Glob pattern for files to search"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
    caseSensitive: tool.schema.boolean().optional().default(true).describe("Case sensitive search"),
    maxResults: tool.schema.number().optional().default(50).describe("Maximum matches to return"),
  },
  async execute(args: { pattern: string; include?: string; cwd?: string; caseSensitive?: boolean; maxResults?: number }) {
    const cwd = args.cwd || process.cwd()
    const flags = args.caseSensitive ? "" : "-i"
    const cmd = `grep -r ${flags} -n --include="${args.include || "**/*"}" "${args.pattern.replace(/"/g, '\\"')}" ${cwd} | head -n ${args.maxResults || 50}`
    return runShell(cmd, cwd)
  },
})

export const replaceInFiles = tool({
  description: "Find and replace text across multiple files",
  args: {
    find: tool.schema.string().describe("Text or regex pattern to find"),
    replace: tool.schema.string().describe("Replacement text"),
    include: tool.schema.string().optional().default("**/*").describe("Glob pattern for files to modify"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
    dryRun: tool.schema.boolean().optional().default(true).describe("Preview changes without writing"),
    regex: tool.schema.boolean().optional().default(false).describe("Treat find as regex"),
  },
  async execute(args: { find: string; replace: string; include?: string; cwd?: string; dryRun?: boolean; regex?: boolean }) {
    const cwd = args.cwd || process.cwd()
    const files = []
    for await (const file of glob(args.include || "**/*", { cwd })) {
      files.push(file)
    }
    const results = []
    for (const file of files) {
      const fullPath = resolve(cwd, file)
      try {
        let content = await readFile(fullPath, "utf-8")
        const originalContent = content
        if (args.regex) {
          content = content.replace(new RegExp(args.find, "g"), args.replace)
        } else {
          content = content.split(args.find).join(args.replace)
        }
        if (content !== originalContent) {
          results.push({ file, changed: true, preview: content.slice(0, 200) })
          if (!args.dryRun) {
            await writeFile(fullPath, content, "utf-8")
          }
        }
      } catch {
        // Skip unreadable files
      }
    }
    return JSON.stringify({ changed: results.length, files: results, dryRun: args.dryRun }, null, 2)
  },
})

export const copyFiles = tool({
  description: "Copy files or directories",
  args: {
    source: tool.schema.string().describe("Source path"),
    destination: tool.schema.string().describe("Destination path"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
    overwrite: tool.schema.boolean().optional().default(false).describe("Overwrite existing"),
  },
  async execute(args: { source: string; destination: string; cwd?: string; overwrite?: boolean }) {
    const cwd = args.cwd || process.cwd()
    const src = resolve(cwd, args.source)
    const dest = resolve(cwd, args.destination)
    const flag = args.overwrite ? "-f" : "-n"
    return runShell(`cp -r ${flag} "${src}" "${dest}"`, cwd)
  },
})

export const moveFiles = tool({
  description: "Move or rename files or directories",
  args: {
    source: tool.schema.string().describe("Source path"),
    destination: tool.schema.string().describe("Destination path"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
    overwrite: tool.schema.boolean().optional().default(false).describe("Overwrite existing"),
  },
  async execute(args: { source: string; destination: string; cwd?: string; overwrite?: boolean }) {
    const cwd = args.cwd || process.cwd()
    const src = resolve(cwd, args.source)
    const dest = resolve(cwd, args.destination)
    const flag = args.overwrite ? "-f" : "-n"
    return runShell(`mv ${flag} "${src}" "${dest}"`, cwd)
  },
})

export const deleteFiles = tool({
  description: "Delete files or directories",
  args: {
    paths: tool.schema.array(tool.schema.string()).describe("Paths to delete"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
    force: tool.schema.boolean().optional().default(false).describe("Force delete (no prompt)"),
    recursive: tool.schema.boolean().optional().default(false).describe("Delete directories recursively"),
  },
  async execute(args: { paths: string[]; cwd?: string; force?: boolean; recursive?: boolean }) {
    const cwd = args.cwd || process.cwd()
    const flags = []
    if (args.force) flags.push("-f")
    if (args.recursive) flags.push("-r")
    const flagStr = flags.length ? flags.join(" ") + " " : ""
    const paths = args.paths.map(p => `"${resolve(cwd, p)}"`).join(" ")
    return runShell(`rm ${flagStr}${paths}`, cwd)
  },
})

export const createDirectory = tool({
  description: "Create directories (including nested)",
  args: {
    paths: tool.schema.array(tool.schema.string()).describe("Directory paths to create"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
  },
  async execute(args: { paths: string[]; cwd?: string }) {
    const cwd = args.cwd || process.cwd()
    const results = []
    for (const path of args.paths) {
      const fullPath = resolve(cwd, path)
      try {
        await mkdir(fullPath, { recursive: true })
        results.push({ path, created: true })
      } catch (e: unknown) {
        const err = e as { code?: string; message?: string }
        results.push({ path, created: false, error: err.message })
      }
    }
    return JSON.stringify(results, null, 2)
  },
})