-- 仅会加载本文件；若同时存在 ~/.config/wezterm/wezterm.lua，后者会被忽略。
local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- ssh
config.default_prog = { "ssh", "dev" }

config.ssh_domains = {
  {
    name = "dev",
    remote_address = "dev",
    username = "siyu",
    multiplexing = "None",
  },
}

-- theme
config.font = wezterm.font_with_fallback({
  'Cascadia Mono',
  'DengXian', -- 中文 fallback；不需要中文可删
})
config.font_size = 12.0

-- WT 默认是竖条光标；WezTerm 默认是方块
config.default_cursor_style = 'SteadyBar'

-- 更接近常见终端对粗体亮色的处理
config.bold_brightens_ansi_colors = true

config.color_schemes = {
  ['Windows Terminal Campbell'] = {
    foreground = '#CCCCCC',
    background = '#0C0C0C',
    cursor_bg = '#FFFFFF',
    cursor_fg = '#0C0C0C',
    cursor_border = '#FFFFFF',
    ansi = {
      '#0C0C0C',
      '#C50F1F',
      '#13A10E',
      '#C19C00',
      '#0037DA',
      '#881798',
      '#3A96DD',
      '#CCCCCC',
    },
    brights = {
      '#767676',
      '#E74856',
      '#16C60C',
      '#F9F1A5',
      '#3B78FF',
      '#B4009E',
      '#61D6D6',
      '#F2F2F2',
    },
  },
}
config.color_scheme = 'Windows Terminal Campbell'


--keymap
local act = wezterm.action
-- 更接近 Windows Terminal：按物理键位认 - / =
config.key_map_preference = 'Physical'

config.keys = {

  -- Ctrl+Shift+W: 关闭当前 pane
  -- 如果这是最后一个 pane，会继续关闭 tab / window，行为和 WT 很接近
  { key = 'w', mods = 'CTRL|SHIFT', action = act.CloseCurrentPane { confirm = false } },

  -- Alt+Shift+- : 向下分屏
  { key = '-', mods = 'CTRL|SHIFT', action = act.SplitPane { direction = 'Down', size = { Percent = 50 } } },

  -- Alt+Shift++ : 向右分屏
  { key = '=', mods = 'CTRL|SHIFT', action = act.SplitPane { direction = 'Right', size = { Percent = 50 } } },

  -- Alt+方向键：切 pane
  { key = 'LeftArrow',  mods = 'ALT', action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow',    mods = 'ALT', action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow',  mods = 'ALT', action = act.ActivatePaneDirection 'Down' },

  -- Alt+Shift+方向键：调整 pane 大小
  { key = 'LeftArrow',  mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Left', 3 } },
  { key = 'RightArrow', mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Right', 3 } },
  { key = 'UpArrow',    mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Up', 3 } },
  { key = 'DownArrow',  mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Down', 3 } },

  -- 可选：给缩放一个顺手点的键
  { key = 'Enter', mods = 'ALT', action = act.TogglePaneZoomState },
}
config.mouse_bindings = {
  -- 普通场景：mouse_reporting = false
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = act.Nop,
  },
  {
    event = { Up = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = act.PasteFrom 'Clipboard',
  },

  -- 程序开启 mouse reporting 的场景：比如 vim / tmux
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    mouse_reporting = true,
    action = act.Nop,
  },
  {
    event = { Up = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    mouse_reporting = true,
    action = act.PasteFrom 'Clipboard',
  },
}

-- history lines
config.scrollback_lines = 20000
return config
