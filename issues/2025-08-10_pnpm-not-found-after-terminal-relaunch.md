# Issue Report: pnpm Not Found After Terminal Relaunch

**Date:** August 10, 2025  
**Status:** ✅ Resolved  
**Shell:** Fish 3.7.0  
**Environment:** Ubuntu Linux (WSL)

## Problem Description

After installing pnpm via NVM, the command was not available when launching new terminal sessions, despite being accessible in the current session where it was installed.

### Symptoms
- `pnpm --version` worked in the original installation session
- `Command 'pnpm' not found` error when opening new terminals
- `which pnpm` showed `/home/ubuntuuser/.nvm/versions/node/v22.17.0/bin/pnpm` in working sessions

## Root Cause

The fish shell configuration was not properly loading the NVM environment on startup. Specifically:

1. **Missing NVM initialization** - No automatic loading of NVM paths
2. **PATH order issues** - NVM paths were being overridden by other PATH assignments
3. **Incomplete NVM setup** - Fish shell lacked proper NVM integration

## Solution Implemented

Updated `~/.dotfiles/fish/config.fish` with the following changes:

### 1. Added NVM Directory Setup
```fish
# Load NVM and set Node path
set -gx NVM_DIR ~/.nvm
```

### 2. Added NVM Command Function
```fish
# NVM function using bass
if test -d ~/.nvm
    function nvm
        bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
    end
end
```

### 3. Fixed PATH Loading Order
```fish
# Add Node.js to PATH (at the end to ensure it's not overridden)
set -gx PATH /home/ubuntuuser/.nvm/versions/node/v22.17.0/bin $PATH
```

### 4. Fixed FZF Integration
```fish
if command -v fzf >/dev/null
    # Try different fzf integration methods
    if test -f /usr/share/fish/vendor_functions.d/fzf_key_bindings.fish
        source /usr/share/fish/vendor_functions.d/fzf_key_bindings.fish
    else if test -f ~/.fzf/shell/key-bindings.fish
        source ~/.fzf/shell/key-bindings.fish
    end
end
```

## Key Insights

- **PATH order matters**: The Node.js binary path needs to be added after other PATH modifications to prevent overriding
- **Fish + NVM integration**: Requires the `bass` plugin (already installed) for proper bash script sourcing
- **Configuration loading sequence**: The order of operations in fish config affects final environment state

## Verification

After implementing the fix:

```bash
$ fish -c "pnpm --version"
10.14.0

$ fish -c "which pnpm"  
/home/ubuntuuser/.nvm/versions/node/v22.17.0/bin/pnpm
```

## Files Modified

- `~/.dotfiles/fish/config.fish` - Updated with NVM integration and proper PATH handling

## Dependencies

- **bass plugin** - Used for NVM bash script integration (already installed via fisher)
- **NVM v22.17.0** - Node.js version manager with Node.js v22.17.0 installed
- **pnpm v10.14.0** - Installed via NVM

## Prevention

To avoid similar issues in the future:
1. Always verify new shell sessions load tools correctly after installation
2. Add PATH modifications at the end of configuration files
3. Test configuration changes with `fish -c "command --version"` before committing

## Related Tools Working

This fix also ensures the following tools are available in new sessions:
- `node` - Node.js runtime
- `npm` - Node package manager  
- `npx` - Node package runner
- `pnpm` - Fast, disk space efficient package manager

---

*Issue resolved by updating fish shell configuration to properly initialize NVM environment on startup.*
