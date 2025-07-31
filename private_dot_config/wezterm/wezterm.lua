---@diagnostic disable: undefined-field

local wezterm = require("wezterm") --[[@as Wezterm]]

local config = wezterm.config_builder()

config:set_strict_mode(true)

config.default_domain = "WSL:Arch"

config.colors = require("color_schemes").Cyberdream

config.win32_system_backdrop = "Acrylic"
config.window_background_opacity = 0.5

config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

local actions = wezterm.action

config.keys = {
	{
		key = "s",
		mods = "SHIFT|ALT",
		action = actions.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "v",
		mods = "SHIFT|ALT",
		action = actions.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "[",
		mods = "CTRL",
		action = actions.ActivateTabRelative(-1),
	},
	{
		key = "]",
		mods = "CTRL",
		action = actions.ActivateTabRelative(1),
	},
	{
		key = "F11",
		action = actions.ToggleFullScreen,
	},
}

return config
