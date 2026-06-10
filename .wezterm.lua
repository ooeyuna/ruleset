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
  'Sarasa Mono SC', -- 中文 fallback；不需要中文可删
}, { weight = 'Medium' })
config.font_size = 13.0
config.cell_width = 0.9
config.line_height = 1.0

-- 更偏向 LCD 子像素渲染，通常比默认更锐
config.freetype_load_target = 'HorizontalLcd'
config.freetype_render_target = 'HorizontalLcd'

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

config.enable_scroll_bar = true
config.min_scroll_bar_height = '1cell'

config.use_fancy_tab_bar = false
config.tab_max_width = 20
config.show_tab_index_in_tab_bar = false -- 我们自己画 index
config.show_new_tab_button_in_tab_bar = false

local MIN_TAB_WIDTH = 12

local function get_tab_title(tab)
  if tab.tab_title and #tab.tab_title > 0 then
    return tab.tab_title
  end
  return tab.active_pane.title
end

wezterm.on('format-tab-title', function(tab, tabs, panes, cfg, hover, max_width)
  local index = tostring(tab.tab_index + 1)
  local title = get_tab_title(tab)

  local prefix = index .. ': '
  local inner_max = math.max(1, max_width - #prefix - 2)
  title = wezterm.truncate_right(title, inner_max)

  local label = prefix .. title
  if #label < MIN_TAB_WIDTH then
    label = label .. string.rep(' ', MIN_TAB_WIDTH - #label)
  end

  return ' ' .. label .. ' '
end)

config.colors = {
  split = "#909090",
}

config.inactive_pane_hsb = {
  saturation = 0.80,
  brightness = 0.40,
}

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
