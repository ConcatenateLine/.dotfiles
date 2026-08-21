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

    # ── LunarVim ─────────────────────────────────────────
    "lvim/config.lua".source = "${dotfiles}/lvim/config.lua";

    # ── Kitty ────────────────────────────────────────────
    "kitty/kitty.conf".source = "${dotfiles}/kitty/kitty.conf";
  };

  # ── OpenCode (copy files instead of symlinks) ───────────
  home.activation.copyOpenCodeConfig = pkgs.lib.mkAfter ''
    mkdir -p $HOME/.config/opencode
    for dir in agent skill themes tool; do
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
  '';
}
