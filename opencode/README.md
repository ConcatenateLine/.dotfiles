# OpenCode Configuration

## Overview
OpenCode configuration directory containing AI assistant setup, MCP servers, agents, and integration settings for enhanced development workflow.

## Configuration Files

### Core Configuration

#### `opencode.json`
Main OpenCode **V2 server** configuration with:
- **Auto-update**: Enabled (`"update": "auto"`)
- **Permissions**: `pkg` tool action set to `ask`
- **MCP Servers**: Model Context Protocol servers under `mcp.servers`

#### `cli.json`
OpenCode **V2 client** (TUI) configuration: theme, plugins, attention/notifications,
diff wrapping, sidebar and tab behavior. Replaces the V1 `tui.json`.

> **Version pin:** `@opencode/plugin` in `package.json` must match the installed
> CLI exactly (`opencode --version`). `npm run typecheck` fails when they drift.

#### `oh-my-opencode.json`
Extended OpenCode configuration with:
- **9 Specialized Agents**: Configured with appropriate models
- **LSP Integration**: TypeScript language server setup

### MCP (Model Context Protocol) Servers

#### Active Servers
- **context7**: Remote documentation and code examples server (enabled)
- **codegraph**: Local code knowledge graph server (enabled)

#### Available but Disabled
- **vibe_kanban**: Project management via npx vibe-kanban
- **playwright**: Testing framework integration
- **angular-cli**: Angular CLI MCP server
- **vitest**: Vitest testing framework MCP server
- **openpencil**: Remote design MCP server

### Agent Configuration

#### Primary Model: opencode/big-pickle
- **Sisyphus**: General purpose assistant
- **librarian**: Documentation and knowledge management
- **explore**: Exploration and discovery tasks
- **oracle**: Wisdom and strategic guidance
- **frontend-ui-ux-engineer**: Frontend development specialist
- **document-writer**: Technical writing and documentation
- **multimodal-looker**: Visual and multimodal analysis
- **angular-tdd-green**: Angular TDD specialist

#### Secondary Model: opencode/glm-4.7-free
- **tdd-test-architect**: Test-driven development architect

### LSP Integration
- **TypeScript Language Server**: 
  - Supports `.ts` and `.tsx` files
  - Priority: 10
  - Command: `typescript-language-server --stdio`

### Custom Tools (V2 Plugins)

V1 `tool/*.ts` files are gone. Custom tools are **plugins**, auto-discovered from
`~/.config/opencode/plugins/<plugin-id>/index.ts`.

#### `pkg` — reference implementation

`plugins/local-tools/index.ts` registers one tool, `pkg`, with two actions:

| Action | Permission | Purpose |
|--------|-----------|---------|
| `detect` | none (read-only) | Report package manager, lockfile, and scripts for the session directory |
| `run` | `pkg` (asks) | Run a `package.json` script with the detected manager |

It demonstrates the rules that matter:

- cwd comes from `ctx.session.get(...).location.directory`, never `process.cwd()`
- `execFile(pm, argv)` — no shell string interpolation
- `timeout`, `maxBuffer`, and `signal: context.signal` set on every run
- mutations call `ctx.permission.assert({ action: "pkg", ... })`, which is covered
  by the `permissions` rule in `opencode.json`

To add a tool: copy this plugin's shape, follow the checklist in `AGENTS.md`, then
run `npm run typecheck` before deploying.

### Development Tools

#### Type checking
```bash
cd opencode
npm install
npm run typecheck   # tsc --noEmit + plugin/CLI version pin check
```

#### Testing
- **test-add.js**: Test utility script

### Documentation

#### `AGENTS.md`
Comprehensive agent documentation including:
- **Context7 Usage Guidelines**: Automatic library documentation retrieval
- **Asana Integration**: Task creation templates and workflows
- **Story Points System**: Effort estimation framework (1-13 points)
- **User Story Templates**: Standardized format for requirements

#### Configuration Notes
- **mcps-config.md**: Additional MCP server configurations (Asana integration)
- **oh-my-opencode-config.md**: Plugin configuration reference

### Directory Structure

```
opencode/
├── AGENTS.md               # Agent documentation and templates
├── README.md               # This file
├── agent/                  # Agent configurations (18 agents)
├── cli.json                # V2 client (TUI) configuration
├── commands/               # Slash commands (9 commands)
├── mcps-config.md          # MCP server configurations
├── node_modules/           # Node.js dependencies (dev only)
├── oh-my-opencode-config.md # Plugin configuration reference
├── oh-my-opencode.json     # Extended OpenCode configuration
├── opencode.json           # V2 server configuration + permissions
├── package-lock.json       # npm lock file
├── package.json            # Dev deps + typecheck / verify scripts
├── plugins/
│   └── local-tools/        # V2 plugin tools (pkg)
├── references/             # Shared checklists and pattern references
├── scripts/
│   └── verify-pin.mjs      # CLI / @opencode/plugin version guard
├── skill/                  # Skill definitions (26 skills)
├── test-add.js             # Test utility script
├── tsconfig.json           # Typecheck config for plugins/
└── themes/                 # Theme configurations
```

## Key Features

### AI Assistant Integration
- 9 specialized agents for different development tasks
- Context7 integration for automatic documentation retrieval
- Custom prompts for full-stack development workflows

### Development Workflow Support
- TypeScript LSP integration for intelligent code assistance
- Testing framework integrations (Playwright, Vitest)
- Angular CLI support for Angular development

### Project Management
- Asana integration with structured task templates
- Story points estimation system
- Automated due date calculations

### Customization
- Theme support (evergarden-winter)
- Extensible MCP server architecture
- Configurable agent models and behaviors

## Usage

1. **OpenCode Configuration**: Main settings in `opencode.json`
2. **Agent Selection**: Choose specialized agents based on task requirements
3. **MCP Servers**: Enable/disable additional servers as needed
4. **Documentation**: Refer to `AGENTS.md` for detailed usage guidelines

## Integration Points

- **Neovim (LazyVim)**: Integrated via the opencode.nvim plugin (`nvim/lua/plugins/opencode.lua`)
- **Fish Shell**: PATH configuration for custom scripts
- **Development Tools**: Seamless integration with testing and build tools