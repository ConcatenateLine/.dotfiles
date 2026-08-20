{ pkgs, ... }:

{
  # ── Git ──────────────────────────────────────────────
  programs.git = {
    enable = true;
    settings = {
      user.name = "Concatenate Line";
      user.email = "concatenateline@gmail.com";
      core.pager = "diff-so-fancy | less --tabs=4 -RF";
      interactive.diffFilter = "diff-so-fancy --patch";
      delta.navigate = true;
      merge.conflictstyle = "zdiff3";
      init.defaultBranch = "main";
    };
  };

  # ── Fish ─────────────────────────────────────────────
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      starship init fish | source
      mise activate fish | source
      fish_add_path /home/ubuntuuser/.opencode/bin
    '';
    shellInit = ''
      set -gx PATH ~/.local/bin $PATH
      set -gx PATH /opt/nvim-linux-x86_64/bin $PATH
      set -gx PATH /usr/local/go/bin $PATH
      set -gx PATH ~/go/bin $PATH
      set -gx PATH ~/.bun/bin $PATH
      set -gx NVM_DIR ~/.nvm
    '';
    shellAbbrs = {
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
    };
    functions = {
      nvm = "bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv";
    };
  };

  # ── Tmux ─────────────────────────────────────────────
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    mouse = true;
    keyMode = "vi";
    terminal = "tmux-256color";
    historyLimit = 50000;
    escapeTime = 0;
    focusEvents = true;
    sensibleOnTop = true;
    baseIndex = 1;
    resizeAmount = 5;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      resurrect
      {
        plugin = continuum;
        extraConfig = "set -g @continuum-restore 'on'";
      }
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_window_left_separator ""
          set -g @catppuccin_window_right_separator " "
          set -g @catppuccin_window_middle_separator " █"
          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"
          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(饮),}"
          set -g @catppuccin_status_modules_right "directory date_time"
          set -g @catppuccin_status_modules_left "session"
          set -g @catppuccin_status_left_separator " "
          set -g @catppuccin_status_right_separator " "
          set -g @catppuccin_status_right_separator_inverse "no"
          set -g @catppuccin_status_fill "icon"
          set -g @catppuccin_status_connect_separator "no"
          set -g @catppuccin_directory_text "#{b:pane_current_path}"
          set -g @catppuccin_date_time_text "%H:%M"
        '';
      }
    ];
    extraConfig = ''
      # Pane navigation (vi-style)
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Pane resize
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Split panes
      bind | split-window -h
      bind - split-window -v

      # Pane borders
      set -g pane-border-lines simple
      set -g pane-border-status top

      # Reload config
      bind r source-file ~/.tmux.conf \; display-message "Config reloaded!"

      # Status bar position
      set -g status-position bottom

      # Pass-through for clipboard
      set -g allow-pass-through on
      set -g set-clipboard on
      set -g xterm-keys on

      # SessionX
      set -g @sessionx-bind-zo-new-window 'ctrl-y'
      set -g @sessionx-auto-accept 'off'
      set -g @sessionx-bind 'o'
      set -g @sessionx-window-height '85%'
      set -g @sessionx-window-width '75%'
      set -g @sessionx-zoxide-mode 'eon'

      # Floax
      set -g @floax-width '80%'
      set -g @floax-height '80%'
      set -g @floax-border-color 'magenta'
      set -g @floax-text-color 'blue'
      set -g @floax-bind 'g'
      set -g @floax-change-path 'true'
    '';
  };

  # ── Starship ─────────────────────────────────────────
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = true;
      format = "$all$nix_shell$nodejs$lua$golang$rust$php$git_branch$git_commit$git_state$git_status \n $username$hostname$directory";
      directory = {
        style = "bg:#2f383e fg:#a7c080";
        format = "[ $path on]($style)";
        truncation_length = 3;
        truncation_symbol = "/";
      };
      git_branch = {
        symbol = " ";
        style = "bg:#3a454a fg:#d3c6aa";
        format = "[ $symbol $branch ]($style)";
      };
      git_status = {
        style = "bg:#3a454a fg:#e69875";
        format = "[ $all_status ]($style)";
      };
      nodejs = {
        symbol = " ";
        style = "bg:#4a555a fg:#83c092";
        format = "[ $symbol($version) ]($style) ";
      };
      rust = {
        symbol = "🦀";
        style = "bg:#4a555a fg:#e67e80";
        format = "[ $symbol($version) ]($style)";
      };
      python = {
        symbol = "🐍";
        pyenv_version_name = true;
        style = "bg:#4a555a fg:#d699b6";
        format = "[ $symbol$virtualenv ]($style)";
      };
      package = {
        symbol = "📦";
        style = "bg:#4a555a fg:#d3c6aa";
        format = "[ $symbol$version ]($style) ";
      };
      docker_context = {
        symbol = "🐳";
        style = "bg:#4a555a fg:#83c092";
        format = "[ $symbol $context ]($style)";
      };
      cmd_duration = {
        min_time = 2000;
        style = "bg:#5a666b fg:#e67e80";
        format = "[ took $duration ]($style)";
      };
      jobs = {
        symbol = "✦";
        style = "fg:#d699b6";
      };
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[✗](bold red)";
      };
    };
  };
}
