local ERROR = vim.diagnostic.severity.ERROR
local HINT = vim.diagnostic.severity.HINT
local INFO = vim.diagnostic.severity.INFO
local WARN = vim.diagnostic.severity.WARN

--- Retrieve some value under `key` from `g:bufferline`, or return a `default` if none was present.
--- PERF: this implementation was profiled be an improvement over `vim.g.bufferline and vim.g.bufferline[key] or default`
--- @generic T
--- @param default? T
--- @param key string
--- @return T value
local function get(key, default)
  local value = (vim.g.bufferline or {})[key]
  if value == nil or value == vim.NIL then
    return default
  else
    return value
  end
end

--- @class bufferline.options.diagnostics.severity
--- @field enabled boolean
--- @field icon string

--- @class bufferline.options.diagnostics
--- @field [1] bufferline.options.diagnostics.severity
--- @field [2] bufferline.options.diagnostics.severity
--- @field [3] bufferline.options.diagnostics.severity
--- @field [4] bufferline.options.diagnostics.severity
local DEFAULT_DIAGNOSTICS = {
  [ERROR] = {enabled = false, icon = 'Ⓧ '},
  [HINT] = {enabled = false, icon = '💡'},
  [INFO] = {enabled = false, icon = 'ⓘ '},
  [WARN] = {enabled = false, icon = '⚠️ '},
}

--- @class bufferline.options.hide
--- @field current? boolean
--- @field extensions? boolean
--- @field inactive? boolean
--- @field visible? boolean

--- @class bufferline.options
local options = {}

--- @return boolean enabled
function options.animation()
  return get('animation', true)
end

--- @return boolean enabled
function options.auto_hide()
  return get('auto_hide', false)
end

--- @return boolean enabled
function options.clickable()
  return get('clickable', true)
end

--- @return boolean enabled
function options.closable()
  return get('closable', true)
end

--- @return bufferline.options.diagnostics
function options.diagnostics()
  return vim.tbl_deep_extend('keep', get('diagnostics', {}), DEFAULT_DIAGNOSTICS)
end

--- @return string[] excluded
function options.exclude_ft()
  return get('exclude_ft', {})
end

--- @return string[] excluded
function options.exclude_name()
  return get('exclude_name', {})
end

--- @return boolean enabled
function options.file_icons()
  local enabled = options.icons()
  return enabled == true or enabled == 'both' or enabled == 'buffer_number_with_icon'
end

--- @return bufferline.options.hide
function options.hide()
  return get('hide', {})
end

--- @return string icon
function options.icon_close_tab()
  return get('icon_close_tab', '')
end

--- @return string icon
function options.icon_close_tab_modified()
  return get('icon_close_tab_modified', '●')
end

--- @return string icon
function options.icon_pinned()
  return get('icon_pinned', '')
end

--- @return string icon
function options.icon_separator_active()
  return get('icon_separator_active', '▎')
end

--- @return string icon
function options.icon_separator_inactive()
  return get('icon_separator_inactive', '▎')
end

--- @return boolean enabled
function options.icons()
  return get('icons', true)
end

--- @return boolean enabled
function options.icon_custom_colors()
  return get('icon_custom_colors', false)
end

--- @return boolean enabled
function options.index_buffers()
  local enabled = options.icons()
  return enabled == 'both' or enabled == 'numbers'
end

--- @return boolean enabled
function options.insert_at_start()
  return get('insert_at_start', false)
end

--- @return boolean enabled
function options.insert_at_end()
  return get('insert_at_end', false)
end

--- @return string letters
function options.letters()
  return get('letters', 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP')
end

--- @return integer padding
function options.maximum_padding()
  return get('maximum_padding', 4)
end

--- @return integer padding
function options.minimum_padding()
  return get('minimum_padding', 1)
end

--- @return integer length
function options.maximum_length()
  return get('maximum_length', 30)
end

--- @return nil|string title
function options.no_name_title()
  return get('no_name_title')
end

--- @return boolean enabled
function options.semantic_letters()
  return get('semantic_letters', true)
end

--- @return boolean enabled
function options.tabpages()
  return get('tabpages', true)
end

return options
