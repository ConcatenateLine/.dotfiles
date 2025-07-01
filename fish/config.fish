# ~/.config/fish/config.fish

if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx PATH /home/ubuntuuser/.local/bin $PATH
set -gx PATH /opt/nvim-linux-x86_64/bin $PATH
set -gx PATH /usr/local/go/bin $PATH
set -gx PATH ~/go/bin $PATH

starship init fish | source

source $HOME/.venvs/lvim/bin/activate.fish
