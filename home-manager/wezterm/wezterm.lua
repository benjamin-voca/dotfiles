local start = [[
    fish -e "/etc/profiles/per-user/benjamin/bin/zellij"
]]

return {
    enable_wayland = false,
    front_end = "WebGpu",
    max_fps = 60,
    color_schemes = {
        ["Gnome Light"] = require("gnome"),
        ["Charmful Dark"] = require("charmful"),
    },
    color_scheme = "Charmful Dark",
    font = require("wezterm").font("JetBrainsMono NerdFont"),
    cell_width = 0.9,
    default_cursor_style = "BlinkingBar",

    default_prog = { "bash", "-c", start },
    window_close_confirmation = "NeverPrompt",
    hide_tab_bar_if_only_one_tab = true,

    window_padding = {
        top = "0cell",
        right = "0cell",
        bottom = "0cell",
        left = "0cell",
    },

    inactive_pane_hsb = {
        saturation = 0.9,
        brightness = 0.8,
    },

    window_background_opacity = 1.0,
    text_background_opacity = 1.0,

    keys = require("keys"),

    audible_bell = "Disabled",
    harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }
}
