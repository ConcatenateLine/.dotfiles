# OpenCode Configuration

## Overview
OpenCode configuration directory containing AI assistant setup, MCP servers, agents, and integration settings for enhanced development workflow.

## Configuration Files

### Core Configuration

#### `opencode.json`
Main OpenCode configuration with:
- **Theme**: evergarden-winter
- **Auto-update**: Enabled
- **MCP Servers**: Multiple Model Context Protocol servers configured

#### `oh-my-opencode.json`
Extended OpenCode configuration with:
- **9 Specialized Agents**: Configured with appropriate models
- **LSP Integration**: TypeScript language server setup

### MCP (Model Context Protocol) Servers

#### Active Servers
- **context7**: Remote documentation and code examples server (enabled)

#### Available but Disabled
- **vibe_kanban**: Project management via npx vibe-kanban
- **playwright**: Testing framework integration
- **angular-cli**: Angular CLI MCP server
- **vitest**: Vitest testing framework MCP server

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

### Development Tools

#### Package Management
- **Node.js**: Package configuration with lock files
- **Bun**: Alternative package manager support

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
├── .gitignore              # Git ignore rules
├── AGENTS.md               # Agent documentation and templates
├── README.md               # This file
├── agent/                  # Agent configurations (empty)
├── bun.lock               # Bun package manager lock file
├── mcps-config.md         # MCP server configurations
├── node_modules/          # Node.js dependencies
├── oh-my-opencode-config.md # Plugin configuration reference
├── oh-my-opencode.json    # Extended OpenCode configuration
├── opencode.json          # Main OpenCode configuration
├── package-lock.json      # npm lock file
├── package.json           # npm package configuration
├── skill/                 # Skill definitions (empty)
├── test-add.js           # Test utility script
└── themes/               # Theme configurations (empty)
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

- **LunarVim**: Integrated via opencode.nvim plugin
- **Fish Shell**: PATH configuration for custom scripts
- **Development Tools**: Seamless integration with testing and build tools