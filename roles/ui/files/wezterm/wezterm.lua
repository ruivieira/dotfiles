local wezterm = require 'wezterm';

return {
  font = wezterm.font("JetBrains Mono"),
  font_size = 14,
  use_dead_keys = false,
  window_close_confirmation = "NeverPrompt",
  keys = {
    {key="q", mods="CTRL", action="QuitApplication"},
  },
}