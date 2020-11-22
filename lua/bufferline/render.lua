-- !::exe [luafile %]
--
-- render.lua
--

local vim = vim
local api = vim.api
local nvim = require'bufferline.nvim'
local utils = require'bufferline.utils'
local get_icon = require'bufferline.get-icon'
local len = utils.len
local slice = utils.slice
local reverse = utils.reverse
local state = require'bufferline.state'
local Buffer = require'bufferline.buffer'
local Layout = require'bufferline.layout'
local JumpMode = require'bufferline.jump_mode'

local HL_BY_ACTIVITY = {
  [0] = 'Inactive',
  [1] = 'Visible',
  [2] = 'Current',
}

local function hl(name)
   return '%#' .. name .. '#'
end

local function slice_groups_right(groups, width)
  local result = ''
  local accumulated_width = 0
  for i, group in ipairs(groups) do
    local hl   = group[1]
    local text = group[2]
    local text_width = nvim.strwidth(text)

    accumulated_width = accumulated_width + text_width

    if accumulated_width >= width then
      local diff = text_width - (accumulated_width - width)
      result = result .. hl .. vim.fn.strcharpart(text, 0, diff)
      break
    end
    result = result .. hl .. text
  end
  return result
end

local function slice_groups_left(groups, width)
  local result = ''
  local accumulated_width = 0
  for i, group in ipairs(reverse(groups)) do
    local hl   = group[1]
    local text = group[2]
    local text_width = nvim.strwidth(text)

    accumulated_width = accumulated_width + text_width

    if accumulated_width >= width then
      local length = text_width - (accumulated_width - width)
      local start = text_width - length
      result = hl .. vim.fn.strcharpart(text, start, length) .. result
      break
    end
    result = hl .. text .. result
  end
  return result
end

local function render(update_names)
  local buffer_numbers = state.get_updated_buffers(update_names)
  local current = vim.fn.bufnr('%')

  -- Store current buffer to open new ones next to this one
  if nvim.buf_get_option(current, 'buflisted') then
    local ok, is_empty = pcall(api.nvim_buf_get_var, current, 'empty_buffer')
    if ok and is_empty then
      state.last_current_buffer = nil
    else
      state.last_current_buffer = current
    end
  end

  local opts = vim.g.bufferline
  local icons = setmetatable(opts, {__index = function(_, k) return opts['icon_'..k] end})

  local click_enabled = vim.fn.has('tablineat') and opts.clickable
  local has_close = opts.closable
  local has_icons = (opts.icons == true) or (opts.icons == 'both')
  local has_numbers = (opts.icons == 'numbers') or (opts.icons == 'both')

  local layout = Layout.calculate(state)

  local items = {}

  local accumulated_width = 0
  for i, buffer_number in ipairs(buffer_numbers) do

    local buffer_data = state.get_buffer_data(buffer_number)
    local buffer_name = buffer_data.name or '[no name]'

    buffer_data.dimensions = Layout.calculate_dimensions(
      buffer_name, layout.base_width, layout.padding_width)

    local activity = Buffer.get_activity(buffer_number)
    local is_inactive = activity == 0
    local is_visible = activity == 1
    local is_current = activity == 2
    -- local is_inactive = activity == 0
    local is_modified = nvim.buf_get_option(buffer_number, 'modified')
    local is_closing = buffer_data.closing

    local status = HL_BY_ACTIVITY[activity]
    local mod = is_modified and 'Mod' or ''

    local separatorPrefix = hl('Buffer' .. status .. 'Sign')
    local separator = is_inactive and
      icons.separator_inactive or
      icons.separator_active

    local namePrefix = hl('Buffer' .. status .. mod)
    local name =
      (not has_icons and state.is_picking_buffer) and
        slice(buffer_name, 1) or
        buffer_name

    local buffer_icons = {}
    if state.is_picking_buffer then
      local letter = JumpMode.get_letter(buffer_number)
      buffer_icons[#buffer_icons+1] = {
        -- Prefix
        hl('Buffer' .. status .. 'Target'),
        -- Icon
        letter and letter..' ' or '',
      }
    elseif has_numbers then
      local number_text = tostring(i)
      buffer_icons[#buffer_icons+1] = {
        -- Prefix
        '',
        -- Icon
        number_text .. ' '
      }
    end

    if has_icons then
      local iconChar, iconHl = get_icon(buffer_name, vim.fn.getbufvar(buffer_number, '&filetype'), status)
      buffer_icons[#buffer_icons+1] = {
        --[[Prefix]]
        hl(is_inactive and 'BufferInactive' or iconHl),
        -- Icon
        iconChar .. ' '
      }
    end

    local closePrefix = ''
    local close = ''
    if has_close then
      local icon =
        (not is_modified and
          icons.close_tab or
          icons.close_tab_modified)

      closePrefix = namePrefix
      close = icon .. ' '

      if click_enabled then
        closePrefix =
            '%' .. buffer_number .. '@BufferlineCloseClickHandler@' .. closePrefix
      end
    end

    local clickable = ''
    if click_enabled then
      clickable = '%' .. buffer_number .. '@BufferlineMainClickHandler@'
    end

    local padding = string.rep(' ', layout.padding_width)

    local item = {
      width = buffer_data.width
        or (layout.padding_width + layout.base_widths[i] + layout.padding_width),
      groups = vim.list_extend({
        { clickable,       ''},
        { separatorPrefix, separator},
        { '',              padding}
      }, vim.list_extend(buffer_icons, {
        { namePrefix,      name},
        { '',              padding},
        { '',              ' '},
        { closePrefix,     close},
      }))
    }

    if is_current then
      state.index = i
      local start = accumulated_width
      local end_  = accumulated_width + item.width

      if state.scroll > start then
        state.set_scroll(start)
      elseif state.scroll + layout.buffers_width < end_ then
        state.set_scroll(state.scroll + (end_ - (state.scroll + layout.buffers_width)))
      end
    end

    table.insert(items, item)
    accumulated_width = accumulated_width + item.width
  end

  -- Create actual tabline string
  local result = ''

  local max_scroll = math.max(layout.used_width - layout.buffers_width, 0)
  local scroll = math.min(state.scroll_current, max_scroll)
  local needed_width = scroll

  accumulated_width = 0

  for i, item in ipairs(items) do
    if needed_width > 0 then
      needed_width = needed_width - item.width
      if needed_width < 0 then
        local diff = -needed_width
        result = result .. slice_groups_left(item.groups, diff)
        accumulated_width = accumulated_width + diff
      end
    else
      if accumulated_width + item.width > layout.buffers_width then
        local diff = layout.buffers_width - accumulated_width
        result = result .. slice_groups_right(item.groups, diff)
        accumulated_width = accumulated_width + diff
        break
      end
      result = result .. slice_groups_right(item.groups, item.width)
      accumulated_width = accumulated_width + item.width
    end
  end

  -- To prevent the expansion of the last click group
  result = result .. '%0@BufferlineMainClickHandler@' .. hl('BufferTabpageFill')

  if layout.actual_width + len(icons.separator_inactive) <= layout.buffers_width and len(items) > 0 then
    result = result .. icons.separator_inactive
  end

  local current_tabpage = vim.fn.tabpagenr()
  local total_tabpages  = vim.fn.tabpagenr('$')
  if layout.tabpages_width > 0 then
    result = result .. '%=%#BufferTabpages# ' .. tostring(current_tabpage) .. '/' .. tostring(total_tabpages) .. ' '
  end

  -- vim.g.layout = {
  --   scroll = state.scroll,
  --   max_scroll = max_scroll,
  --   layout = layout,
  --   needed_width = needed_width,
  --   accumulated_width = accumulated_width,
  -- }

  result = result .. hl('TabLineFill')

  return result
end

local function render_safe(update_names)
  local ok, result = pcall(render, update_names)
  return {ok, tostring(result)}
end

-- print(render(state.buffers))

local exports = {
  render = render,
  render_safe = render_safe,
}

return exports
