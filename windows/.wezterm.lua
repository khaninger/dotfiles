local wezterm = require 'wezterm'
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Default start
config.wsl_domains = {
  {
    name = 'WSL:Ubuntu',
    distribution = 'Ubuntu-24.04',
    default_cwd = "~",
  },
}
config.default_domain = 'WSL:Ubuntu'
config.default_prog = { "wsl.exe" }


--config.disableDefaultBindings = true
 
config.keys = {
  {
    key = 'Enter',
    mods = 'ALT',
    action = wezterm.action.DisableDefaultAssignment,
  },
 
}


-- Appearance
config.font = wezterm.font("Berkeley Mono")
config.window_decorations = "RESIZE"

config.color_scheme = "SpacemacsTheme" -- Changed from Catppuccin Mocha
config.colors = {
  background = "#262626",
  tab_bar = {
    background = "#262626",
  },
}
config.color_schemes = {
  ["SpacemacsTheme"] = {
    foreground = "#a3a3a3",
    background = "#262626",
    cursor_bg = "#e3dedd",
    cursor_fg = "#292b2e",
    cursor_border = "#e3dedd",
    selection_bg = "#444155",
    selection_fg = "#a3a3a3",
    ansi = {
      "#292b2e", -- black
      "#f2241f", -- red
      "#67b11d", -- green
      "#b1951d", -- yellow
      "#4f97d7", -- blue
      "#a31db1", -- magenta
      "#2d9574", -- cyan
      "#a3a3a3", -- white
    },
    brights = {
      "#68727c", -- bright black
      "#f2241f", -- bright red
      "#67b11d", -- bright green
      "#b1951d", -- bright yellow
      "#4f97d7", -- bright blue
      "#a31db1", -- bright magenta
      "#2d9574", -- bright cyan
      "#e3dedd", -- bright white
    },
  },
}

return config