// Fails when the plugin SDK pin drifts from the installed OpenCode CLI.
// The plugin API is versioned with the CLI, so both must share a version.
import { execFileSync } from "node:child_process"
import { readFileSync } from "node:fs"

const cli = execFileSync("opencode", ["--version"], { encoding: "utf8" }).match(/\d+\.\d+\.\d+/)?.[0]
const pkg = JSON.parse(readFileSync(new URL("../package.json", import.meta.url), "utf8"))
const pin = pkg.devDependencies["@opencode/plugin"]

if (!cli) {
  console.error("could not determine the opencode CLI version")
  process.exit(1)
}

if (pin !== cli) {
  console.error(`@opencode/plugin ${pin} does not match opencode ${cli}. Update the pin (or the CLI) so they match.`)
  process.exit(1)
}

console.log(`@opencode/plugin ${pin} matches opencode ${cli}`)
