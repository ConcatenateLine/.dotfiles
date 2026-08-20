{ pkgs, ... }:

let
  dotfiles = ../..;
in
{
  xdg.configFile = {
    # ── OpenCode ─────────────────────────────────────────
    "opencode/opencode.json".source = "${dotfiles}/opencode/opencode.json";
    "opencode/AGENTS.md".source = "${dotfiles}/opencode/AGENTS.md";
    "opencode/tui.json".source = "${dotfiles}/opencode/tui.json";
    "opencode/oh-my-opencode.json".source = "${dotfiles}/opencode/oh-my-opencode.json";
    "opencode/oh-my-opencode-config.md".source = "${dotfiles}/opencode/oh-my-opencode-config.md";
    "opencode/mcps-config.md".source = "${dotfiles}/opencode/mcps-config.md";
    "opencode/agent".source = "${dotfiles}/opencode/agent";
    "opencode/skill".source = "${dotfiles}/opencode/skill";
    "opencode/themes".source = "${dotfiles}/opencode/themes";
    "opencode/tool".source = "${dotfiles}/opencode/tool";

    # ── Devin ────────────────────────────────────────────
    "devin/config.json".source = "${dotfiles}/devin/config.json";
    "devin/mcp_config.json".source = "${dotfiles}/devin/mcp_config.json";
    "devin/global_rules.md".source = "${dotfiles}/devin/global_rules.md";

    # ── LunarVim ─────────────────────────────────────────
    "lvim/config.lua".source = "${dotfiles}/lvim/config.lua";

    # ── Kitty ────────────────────────────────────────────
    "kitty/kitty.conf".source = "${dotfiles}/kitty/kitty.conf";
  };
}
