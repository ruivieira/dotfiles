local wezterm = require 'wezterm';

return {
    color_scheme = "Arthur",
    font = wezterm.font("JetBrains Mono"),
    font_size = 14,
    warn_about_missing_glyphs = false,
    use_dead_keys = false,
    default_cursor_style = "BlinkingBlock",
    cursor_blink_rate = 500,
    window_close_confirmation = "NeverPrompt",
    keys = {{
        key = "q",
        mods = "CTRL",
        action = "QuitApplication"
    }}
}
