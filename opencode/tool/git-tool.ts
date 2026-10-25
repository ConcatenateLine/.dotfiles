import { tool } from "@opencode-ai/plugin/tool"
import { execSync } from "node:child_process"

function runGit(args: string[], cwd?: string): string {
  try {
    return execSync(`git ${args.join(" ")}`, {
      cwd: cwd || process.cwd(),
      encoding: "utf-8",
      stdio: ["ignore", "pipe", "pipe"],
    }).trim()
  } catch (e: unknown) {
    const err = e as { stdout?: Buffer; stderr?: Buffer; message?: string }
    return err.stdout?.toString().trim() || err.stderr?.toString().trim() || err.message || "Unknown error"
  }
}

export const gitStatus = tool({
  description: "Get git status (modified, staged, untracked files)",
  args: {
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
  },
  async execute(args) {
    return runGit(["status", "--short"], args.cwd)
  },
})

export const gitDiff = tool({
  description: "Get git diff for working tree or staged changes",
  args: {
    staged: tool.schema.boolean().optional().default(false).describe("Show staged changes instead of working tree"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
    file: tool.schema.string().optional().describe("Specific file to diff"),
  },
  async execute(args) {
    const cmd = ["diff"]
    if (args.staged) cmd.push("--staged")
    if (args.file) cmd.push(args.file)
    return runGit(cmd, args.cwd)
  },
})

export const gitLog = tool({
  description: "Get recent git log entries",
  args: {
    count: tool.schema.number().optional().default(10).describe("Number of commits to show"),
    oneline: tool.schema.boolean().optional().default(true).describe("Use oneline format"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
    file: tool.schema.string().optional().describe("Filter by file path"),
  },
  async execute(args) {
    const cmd = ["log"]
    if (args.oneline) cmd.push("--oneline")
    cmd.push(`-n${args.count}`)
    if (args.file) cmd.push("--", args.file)
    return runGit(cmd, args.cwd)
  },
})

export const gitBranch = tool({
  description: "List or create git branches",
  args: {
    create: tool.schema.string().optional().describe("Name of new branch to create"),
    delete: tool.schema.string().optional().describe("Name of branch to delete"),
    listAll: tool.schema.boolean().optional().default(false).describe("List all branches (including remote)"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
  },
  async execute(args) {
    if (args.create) {
      return runGit(["checkout", "-b", args.create], args.cwd)
    }
    if (args.delete) {
      return runGit(["branch", "-d", args.delete], args.cwd)
    }
    const cmd = ["branch"]
    if (args.listAll) cmd.push("-a")
    return runGit(cmd, args.cwd)
  },
})

export const gitCheckout = tool({
  description: "Switch git branch or restore files",
  args: {
    target: tool.schema.string().describe("Branch name, commit hash, or file path"),
    create: tool.schema.boolean().optional().default(false).describe("Create new branch"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
  },
  async execute(args) {
    const cmd = ["checkout"]
    if (args.create) cmd.push("-b")
    cmd.push(args.target)
    return runGit(cmd, args.cwd)
  },
})

export const gitAdd = tool({
  description: "Stage files for commit",
  args: {
    files: tool.schema.array(tool.schema.string()).optional().default(["."]).describe("Files to stage (default: all)"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
  },
  async execute(args) {
    return runGit(["add", ...args.files], args.cwd)
  },
})

export const gitCommit = tool({
  description: "Create a git commit",
  args: {
    message: tool.schema.string().describe("Commit message"),
    amend: tool.schema.boolean().optional().default(false).describe("Amend previous commit"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
  },
  async execute(args) {
    const cmd = ["commit"]
    if (args.amend) cmd.push("--amend", "--no-edit")
    else cmd.push("-m", args.message)
    return runGit(cmd, args.cwd)
  },
})

export const gitPush = tool({
  description: "Push commits to remote",
  args: {
    remote: tool.schema.string().optional().default("origin").describe("Remote name"),
    branch: tool.schema.string().optional().describe("Branch name (default: current)"),
    force: tool.schema.boolean().optional().default(false).describe("Force push"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
  },
  async execute(args) {
    const cmd = ["push"]
    if (args.force) cmd.push("--force-with-lease")
    cmd.push(args.remote)
    if (args.branch) cmd.push(args.branch)
    return runGit(cmd, args.cwd)
  },
})

export const gitPull = tool({
  description: "Pull changes from remote",
  args: {
    remote: tool.schema.string().optional().default("origin").describe("Remote name"),
    branch: tool.schema.string().optional().describe("Branch name (default: current)"),
    rebase: tool.schema.boolean().optional().default(false).describe("Use rebase instead of merge"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
  },
  async execute(args) {
    const cmd = ["pull"]
    if (args.rebase) cmd.push("--rebase")
    cmd.push(args.remote)
    if (args.branch) cmd.push(args.branch)
    return runGit(cmd, args.cwd)
  },
})

export const gitStash = tool({
  description: "Stash or restore working changes",
  args: {
    action: tool.schema.enum(["push", "pop", "list", "drop", "apply"]).default("push").describe("Stash action"),
    message: tool.schema.string().optional().describe("Stash message (for push)"),
    index: tool.schema.number().optional().describe("Stash index (for pop/apply/drop)"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
  },
  async execute(args) {
    const cmd = ["stash", args.action]
    if (args.message) cmd.push("-m", args.message)
    if (args.index !== undefined) cmd.push(`stash@{${args.index}}`)
    return runGit(cmd, args.cwd)
  },
})

export const gitRemote = tool({
  description: "List or manage git remotes",
  args: {
    action: tool.schema.enum(["list", "add", "remove", "rename"]).default("list").describe("Remote action"),
    name: tool.schema.string().optional().describe("Remote name"),
    url: tool.schema.string().optional().describe("Remote URL (for add)"),
    newName: tool.schema.string().optional().describe("New name (for rename)"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
  },
  async execute(args) {
    const cmd = ["remote", args.action]
    if (args.name) cmd.push(args.name)
    if (args.url) cmd.push(args.url)
    if (args.newName) cmd.push(args.newName)
    return runGit(cmd, args.cwd)
  },
})

export const gitTag = tool({
  description: "List or create git tags",
  args: {
    create: tool.schema.string().optional().describe("Tag name to create"),
    message: tool.schema.string().optional().describe("Tag message (annotated tag)"),
    delete: tool.schema.string().optional().describe("Tag name to delete"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
  },
  async execute(args) {
    if (args.create) {
      const cmd = ["tag"]
      if (args.message) cmd.push("-a", args.create, "-m", args.message)
      else cmd.push(args.create)
      return runGit(cmd, args.cwd)
    }
    if (args.delete) {
      return runGit(["tag", "-d", args.delete], args.cwd)
    }
    return runGit(["tag"], args.cwd)
  },
})

export const gitReset = tool({
  description: "Reset HEAD to a specific state",
  args: {
    mode: tool.schema.enum(["soft", "mixed", "hard"]).default("mixed").describe("Reset mode"),
    target: tool.schema.string().optional().default("HEAD").describe("Commit to reset to"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
  },
  async execute(args) {
    return runGit(["reset", `--${args.mode}`, args.target], args.cwd)
  },
})

export const gitClean = tool({
  description: "Remove untracked files from working tree",
  args: {
    force: tool.schema.boolean().optional().default(false).describe("Actually remove files (dry-run by default)"),
    directories: tool.schema.boolean().optional().default(false).describe("Also remove untracked directories"),
    cwd: tool.schema.string().optional().describe("Working directory (default: current)"),
  },
  async execute(args) {
    const cmd = ["clean"]
    if (!args.force) cmd.push("-n")
    else cmd.push("-f")
    if (args.directories) cmd.push("-d")
    return runGit(cmd, args.cwd)
  },
})