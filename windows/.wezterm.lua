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

-- Appearance
config.font = wezterm.font("Berkeley Mono")
config.color_scheme = "Catppuccin Mocha"
config.window_decorations = "RESIZE"

return config