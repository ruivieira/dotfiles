local wezterm = require 'wezterm';

if wezterm.target_triple == 'x86_64-apple-darwin' then
    -- Configs for OSX only
    -- font_dirs    = { '$HOME/.dotfiles/.fonts' }
    font_size = 16
    dpi = 96.0
    native_macos_fullscreen_mode = false
end

if wezterm.target_triple == 'x86_65-unknown-linux-gnu' then
    -- Configs for Linux only
    -- font_dirs    = { '$HOME/.dotfiles/.fonts' }
    font_size = 12
    dpi = 96.0
    native_macos_fullscreen_mode = true
end

return {
    check_for_updates = false,
    front_end = "OpenGL",
    dpi = dpi,
    exit_behavior = "Close",
    font = wezterm.font("JetBrains Mono"),
    font_size = font_size,
    line_height = 1.1,
    color_scheme = "Firewatch",
    hide_tab_bar_if_only_one_tab = true,
    native_macos_fullscreen_mode = native_macos_fullscreen_mode,
    window_padding = {
        left = 20,
        right = 20,
        top = 20,
        bottom = 20
    },
    enable_tab_bar = true,
    default_cursor_style = "SteadyBlock"
}
