local wezterm = require 'wezterm';

return {
    color_scheme = "Spring",
    font = wezterm.font("Comic Mono"),
    font_size = 14,
    warn_about_missing_glyphs = false,
    use_dead_keys = false,
    default_cursor_style = "BlinkingBlock",
    cursor_blink_rate = 500,
    window_close_confirmation = "NeverPrompt",
    keys = {
      {key="q", mods="CTRL", action="QuitApplication"},
      -- This will create a new split and run the `top` program inside it
      {key="d", mods="CTRL", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}}
    }
}
