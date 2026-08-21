# ~/.config/fish/config.fish

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Set up PATH variables
set -gx PATH /home/ubuntuuser/.local/bin $PATH
set -gx PATH /opt/nvim-linux-x86_64/bin $PATH
set -gx PATH /usr/local/go/bin $PATH
set -gx PATH ~/go/bin $PATH
set -gx PATH /home/ubuntuuser/.applications/idea-2026/idea-IU-261.24374.151/bin $PATH

# Load NVM and set Node path
set -gx NVM_DIR ~/.nvm

# NVM function using bass
if test -d ~/.nvm
    function nvm
        bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
    end
end

starship init fish | source
if command -v fzf >/dev/null
    # Try different fzf integration methods
    if test -f /usr/share/fish/vendor_functions.d/fzf_key_bindings.fish
        source /usr/share/fish/vendor_functions.d/fzf_key_bindings.fish
    else if test -f ~/.fzf/shell/key-bindings.fish
        source ~/.fzf/shell/key-bindings.fish
    end
end

source $HOME/.venvs/lvim/bin/activate.fish

# Add Node.js to PATH (at the end to ensure it's not overridden)
set -gx PATH /home/ubuntuuser/.nvm/versions/node/v22.17.0/bin $PATH

set -x DONT_PROMPT_WSL_INSTALL 1

/home/ubuntuuser/.local/bin/mise activate fish | source

# opencode
fish_add_path /home/ubuntuuser/.opencode/bin

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
