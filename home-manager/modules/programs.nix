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
      # Everforest color scheme (matches starship palette)
      set -g fish_color_normal d3c6aa
      set -g fish_color_command a7c080
      set -g fish_color_param d3c6aa
      set -g fish_color_keyword e67e80
      set -g fish_color_quote dbbc7f
      set -g fish_color_redirection d699b6
      set -g fish_color_end 7a8478
      set -g fish_color_error e67e80
      set -g fish_color_comment 7a8478
      set -g fish_color_selection --background=#4a555a
      set -g fish_color_search_match --background=#4a555a
      set -g fish_color_operator 83c092
      set -g fish_color_escape d699b6
      set -g fish_color_autosuggestion 7a8478
      set -g fish_color_cwd a7c080
      set -g fish_color_user 7fbbb3
      set -g fish_color_host a7c080
      set -g fish_color_cancel e67e80
      set -g fish_pager_color_progress 7a8478
      set -g fish_pager_color_prefix a7c080
      set -g fish_pager_color_completion d3c6aa
      set -g fish_pager_color_description 7a8478
      set -g fish_pager_color_selected_background --background=#4a555a

      mise activate fish | source

      # fzf key bindings
      if command -v fzf >/dev/null
        if test -f /usr/share/fish/vendor_functions.d/fzf_key_bindings.fish
          source /usr/share/fish/vendor_functions.d/fzf_key_bindings.fish
        else if test -f ~/.fzf/shell/key-bindings.fish
          source ~/.fzf/shell/key-bindings.fish
        end
      end
    '';
    shellInit = ''
      set -gx PATH ~/.local/bin $PATH
      set -gx PATH /usr/local/go/bin $PATH
      set -gx PATH ~/go/bin $PATH
      set -x DONT_PROMPT_WSL_INSTALL 1
      set -gx PATH ~/.dotfiles/custom-scripts $PATH

      # LunarVim venv
      if test -f $HOME/.venvs/lvim/bin/activate.fish
        source $HOME/.venvs/lvim/bin/activate.fish
      end
    '';
    shellAbbrs = {
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
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
      yank
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = continuum;
        extraConfig = "set -g @continuum-restore 'on'";
      }
      tmux-thumbs
      tmux-fzf
      {
        plugin = tmux-sessionx;
        extraConfig = ''
          set -g @sessionx-bind-zo-new-window 'ctrl-y'
          set -g @sessionx-auto-accept 'off'
          set -g @sessionx-bind 'o'
          set -g @sessionx-x-path '~/.dotfiles'
          set -g @sessionx-window-height '85%'
          set -g @sessionx-window-width '75%'
          set -g @sessionx-zoxide-mode 'eon'
          set -g @sessionx-custom-paths-subdirectories 'false'
          set -g @sessionx-filter-current 'false'
        '';
      }
      {
        plugin = tmux-floax;
        extraConfig = ''
          set -g @floax-width '80%'
          set -g @floax-height '80%'
          set -g @floax-border-color 'magenta'
          set -g @floax-text-color 'blue'
          set -g @floax-bind 'g'
          set -g @floax-change-path 'true'
        '';
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
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"

      # Status bar position
      set -g status-position bottom

      # Pass-through for clipboard
      set -g allow-passthrough on
      set -g set-clipboard on
      set -g xterm-keys on
    '';
  };

  # ── Starship ─────────────────────────────────────────
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = true;
      format = "[](bg:#2f383e fg:#2f383e)$directory[](fg:#2f383e bg:#3a454a)$git_branch$git_status[](fg:#3a454a bg:#4a555a)$nodejs$rust$python$package$docker_context[](fg:#4a555a bg:#5a666b)$cmd_duration[](fg:#5a666b bg:#6a777c)$jobs[](fg:#5a666b bg:none) 
$line_break$character
";
      directory = {
        style = "bg:#2f383e fg:#a7c080";
        format = "[ $path on]($style)";
        truncation_length = 3;
        truncation_symbol = "/";
      };
      git_branch = {
        symbol = "🌱";
        style = "bg:#3a454a fg:#d3c6aa";
        format = "[ $symbol $branch ]($style)";
      };
      git_status = {
        style = "bg:#3a454a fg:#e69875";
        format = "[ $all_status ]($style)";
      };
      nodejs = {
        symbol = "";
        style = "bg:#4a555a fg:#83c092";
        format = "[ $symbol($version) ]($style) ";
      };
      rust = {
        symbol = "🦀";
        style = "bg:#4a555a fg:#e67e80";
        format = "[ $symbol($version) ]($style) ";
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
        format = "[ $symbol $context ]($style) ";
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
