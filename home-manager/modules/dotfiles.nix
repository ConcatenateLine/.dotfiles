{ pkgs, ... }:

let
  dotfiles = ../..;
in
{
  xdg.configFile = {
    # ── Devin ────────────────────────────────────────────
    "devin/config.json".source = "${dotfiles}/devin/config.json";
    "devin/mcp_config.json".source = "${dotfiles}/devin/mcp_config.json";
    "devin/global_rules.md".source = "${dotfiles}/devin/global_rules.md";

    # ── Kitty ────────────────────────────────────────────
    "kitty/kitty.conf".source = "${dotfiles}/kitty/kitty.conf";
  };

  # ── Neovim (LazyVim) ─────────────────────────────────────
  # ~/.config/nvim has to point at the repository instead of a nix store
  # copy: lazy.nvim writes lazy-lock.json into the config directory and
  # store paths are read-only. The link is created here (and not through
  # xdg.configFile) because nix copies every absolute path found in a
  # derivation string into the store.
  #
  # The checkout is expected in ~/.dotfiles (see README/bootstrap.sh).
  # Set DOTFILES_REPO to use a different location.
  home.activation.linkNvimConfig = pkgs.lib.mkAfter ''
    repo="''${DOTFILES_REPO:-$HOME/.dotfiles}"
    target="$HOME/.config/nvim"
    link="''$repo/nvim"

    mkdir -p "$HOME/.config"

    if [ -L "$target" ]; then
      rm -f "$target"
    elif [ -e "$target" ]; then
      echo "Backing up $target to $target.backup"
      rm -rf "$target.backup"
      mv "$target" "$target.backup"
    fi

    ln -sfn "$link" "$target"
  '';

  # ── OpenCode (copy files instead of symlinks) ───────────
  home.activation.copyOpenCodeConfig = pkgs.lib.mkAfter ''
    mkdir -p $HOME/.config/opencode
    # Store-copied files arrive read-only; make them writable so they can be replaced.
    chmod -R u+w $HOME/.config/opencode 2>/dev/null || true
    rm -f $HOME/.config/opencode/*.json $HOME/.config/opencode/*.md
    for dir in agent skill themes tool tui-plugin commands references; do
      [ -d $HOME/.config/opencode/$dir ] && rm -rf $HOME/.config/opencode/$dir
    done
    cp ${dotfiles}/opencode/opencode.json $HOME/.config/opencode/opencode.json
    cp ${dotfiles}/opencode/AGENTS.md $HOME/.config/opencode/AGENTS.md
    cp ${dotfiles}/opencode/tui.json $HOME/.config/opencode/tui.json
    cp ${dotfiles}/opencode/oh-my-opencode.json $HOME/.config/opencode/oh-my-opencode.json
    cp ${dotfiles}/opencode/oh-my-opencode-config.md $HOME/.config/opencode/oh-my-opencode-config.md
    cp ${dotfiles}/opencode/mcps-config.md $HOME/.config/opencode/mcps-config.md
    cp -r ${dotfiles}/opencode/agent $HOME/.config/opencode/agent
    cp -r ${dotfiles}/opencode/skill $HOME/.config/opencode/skill
    cp -r ${dotfiles}/opencode/themes $HOME/.config/opencode/themes
    cp -r ${dotfiles}/opencode/tool $HOME/.config/opencode/tool
    cp -r ${dotfiles}/opencode/tui-plugin $HOME/.config/opencode/tui-plugin
    cp -r ${dotfiles}/opencode/commands $HOME/.config/opencode/commands
    cp -r ${dotfiles}/opencode/references $HOME/.config/opencode/references
    # Keep writable for future runs (cp preserves the store's read-only modes).
    chmod -R u+w $HOME/.config/opencode
  '';
}
