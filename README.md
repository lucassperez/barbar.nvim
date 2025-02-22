
![demo](./static/demo.gif)

<h1 align="center">
  barbar.nvim
</h1>

<p align="center">
  <b>Tabs, as understood by any other editor.</b>
</p>

`barbar.nvim` is a tabline plugin with re-orderable, auto-sizing, clickable tabs,
icons, nice highlighting, sort-by commands and a magic jump-to-buffer mode. Plus
the tab names are made unique when two filenames match.

In jump-to-buffer mode, tabs display a target letter instead of their icon. Jump to
any buffer by simply typing their target letter. Even better, the target letter
stays constant for the lifetime of the buffer, so if you're working with a set of
files you can even type the letter ahead from memory.

##### Table of content
 - [Install](#install)
 - [Features](#features)
 - [Usage](#usage)
 - [Options](#options)
 - [Highlighting](#highlighting)
 - [Integration with filetree plugins](#integration-with-filetree-plugins)
 - [Known Issues](#known-issues)
 - [About Barbar](#about)

## Install

#### Using [vim-plug](https://github.com/junegunn/vim-plug)
```vim
Plug 'nvim-tree/nvim-web-devicons'
Plug 'romgrk/barbar.nvim'
```

#### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use 'nvim-tree/nvim-web-devicons'
use {'romgrk/barbar.nvim', wants = 'nvim-web-devicons'}
```

You can skip the dependency on `'nvim-tree/nvim-web-devicons'` if you
[disable icons](#options).  If you want the icons, don't forget to
install [nerd fonts](https://www.nerdfonts.com/).

##### Requirements
 - Neovim `0.7`

## Features

##### Re-order tabs

![reorder](./static/reorder.gif)

##### Auto-sizing tabs, fill the space when available

![resize](./static/resize.gif)

##### Jump-to-buffer mode

![jump](./static/jump.gif)

Type a letter to jump to a buffer. Letters stay constant for the lifetime of the buffer.
By default, letters are assigned based on buffer name, eg `README.md` will get letter `r`.
You can change this so that letters are assigned based on usability:
home row (`asdfjkl;gh`) first, then other rows.

##### Sort tabs automatically

![jump](./static/sort.gif)

`:BufferOrderByDirectory`, `:BufferOrderByLanguage`, `:BufferOrderByWindowNumber`, `:BufferOrderByBufferNumber`

##### Clickable & closable tabs

![click](./static/click.gif)

Left-click to go, middle-click or close button to close. Don't forget to `set mouse+=a`.

##### Unique names when filenames match

![unique-name](./static/unique-name.png)

##### Pinned buffers

![pinned](./static/pinned.png)

##### bbye.vim for closing buffers

A modified version of [bbye.vim](https://github.com/moll/vim-bbye) is included in this
plugin to close buffers without messing with your window layout and more. Available
as `BufferClose` and `bufferline#bbye#delete(buf)`.

##### Scrollable tabs, to always show the current buffer

![scroll](./static/scroll.gif)

## Usage

### Mappings & commands

#### Vim script

No default mappings are provided, here is an example. It is recommended to use
the `BufferClose` command to close buffers instead of `bdelete` because it will
not mess your window layout.

```vim
" Move to previous/next
nnoremap <silent>    <A-,> <Cmd>BufferPrevious<CR>
nnoremap <silent>    <A-.> <Cmd>BufferNext<CR>
" Re-order to previous/next
nnoremap <silent>    <A-<> <Cmd>BufferMovePrevious<CR>
nnoremap <silent>    <A->> <Cmd>BufferMoveNext<CR>
" Goto buffer in position...
nnoremap <silent>    <A-1> <Cmd>BufferGoto 1<CR>
nnoremap <silent>    <A-2> <Cmd>BufferGoto 2<CR>
nnoremap <silent>    <A-3> <Cmd>BufferGoto 3<CR>
nnoremap <silent>    <A-4> <Cmd>BufferGoto 4<CR>
nnoremap <silent>    <A-5> <Cmd>BufferGoto 5<CR>
nnoremap <silent>    <A-6> <Cmd>BufferGoto 6<CR>
nnoremap <silent>    <A-7> <Cmd>BufferGoto 7<CR>
nnoremap <silent>    <A-8> <Cmd>BufferGoto 8<CR>
nnoremap <silent>    <A-9> <Cmd>BufferGoto 9<CR>
nnoremap <silent>    <A-0> <Cmd>BufferLast<CR>
" Pin/unpin buffer
nnoremap <silent>    <A-p> <Cmd>BufferPin<CR>
" Close buffer
nnoremap <silent>    <A-c> <Cmd>BufferClose<CR>
" Wipeout buffer
"                          :BufferWipeout
" Close commands
"                          :BufferCloseAllButCurrent
"                          :BufferCloseAllButVisible
"                          :BufferCloseAllButPinned
"                          :BufferCloseAllButCurrentOrPinned
"                          :BufferCloseBuffersLeft
"                          :BufferCloseBuffersRight
" Magic buffer-picking mode
nnoremap <silent> <C-p>    <Cmd>BufferPick<CR>
" Sort automatically by...
nnoremap <silent> <Space>bb <Cmd>BufferOrderByBufferNumber<CR>
nnoremap <silent> <Space>bd <Cmd>BufferOrderByDirectory<CR>
nnoremap <silent> <Space>bl <Cmd>BufferOrderByLanguage<CR>
nnoremap <silent> <Space>bw <Cmd>BufferOrderByWindowNumber<CR>

" Other:
" :BarbarEnable - enables barbar (enabled by default)
" :BarbarDisable - very bad command, should never be used
```

#### Lua

```lua
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next
map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
-- Re-order to previous/next
map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
-- Goto buffer in position...
map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
-- Pin/unpin buffer
map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
-- Close buffer
map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
-- Wipeout buffer
--                 :BufferWipeout
-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight
-- Magic buffer-picking mode
map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
-- Sort automatically by...
map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used
```

## Options

#### Vim Script

```vim
" NOTE: If barbar's option dict isn't created yet, create it
let bufferline = get(g:, 'bufferline', {})

" Enable/disable animations
let bufferline.animation = v:true

" Enable/disable auto-hiding the tab bar when there is a single buffer
let bufferline.auto_hide = v:false

" Enable/disable current/total tabpages indicator (top right corner)
let bufferline.tabpages = v:true

" Enable/disable close button
let bufferline.closable = v:true

" Enables/disable clickable tabs
"  - left-click: go to buffer
"  - middle-click: delete buffer
let bufferline.clickable = v:true

" Enables / disables diagnostic symbols
" ERROR / WARN / INFO / HINT
let bufferline.diagnostics = [
  \ {'enabled': v:true, 'icon': 'ﬀ'},
  \ {'enabled': v:false},
  \ {'enabled': v:false},
  \ {'enabled': v:true},
\]

" Excludes buffers from the tabline
let bufferline.exclude_ft = ['javascript']
let bufferline.exclude_name = ['package.json']

" Hide file extensions
let bufferline.file_extensions = v:false

" Hide inactive buffers and file extensions. Other options are `current` and `visible`
let bufferline.hide = {'extensions': v:true, 'inactive': v:true}

" Enable/disable icons
" if set to 'buffer_number', will show buffer number in the tabline
" if set to 'numbers', will show buffer index in the tabline
" if set to 'both', will show buffer index and icons in the tabline
" if set to 'buffer_number_with_icon', will show buffer number and icons in the tabline
let bufferline.icons = v:true

" Sets the icon's highlight group.
" If false, will use nvim-web-devicons colors
let bufferline.icon_custom_colors = v:false

" Configure icons on the bufferline.
let bufferline.icon_separator_active = '▎'
let bufferline.icon_separator_inactive = '▎'
let bufferline.icon_close_tab = ''
let bufferline.icon_close_tab_modified = '●'
let bufferline.icon_pinned = '車'

" If true, new buffers will be inserted at the start/end of the list.
" Default is to insert after current buffer.
let bufferline.insert_at_start = v:false
let bufferline.insert_at_end = v:false

" Sets the maximum padding width with which to surround each tab.
let bufferline.maximum_padding = 4

" Sets the minimum padding width with which to surround each tab.
let bufferline.minimum_padding = 1

" Sets the maximum buffer name length.
let bufferline.maximum_length = 30

" If set, the letters for each buffer in buffer-pick mode will be
" assigned based on their name. Otherwise or in case all letters are
" already assigned, the behavior is to assign letters in order of
" usability (see order below)
let bufferline.semantic_letters = v:true

" New buffer letters are assigned in this order. This order is
" optimal for the qwerty keyboard layout but might need adjustement
" for other layouts.
let bufferline.letters =
  \ 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP'

" Sets the name of unnamed buffers. By default format is "[Buffer X]"
" where X is the buffer number. But only a static string is accepted here.
let bufferline.no_name_title = v:null
```

#### Lua

```lua
-- Set barbar's options
require'bufferline'.setup {
  -- Enable/disable animations
  animation = true,

  -- Enable/disable auto-hiding the tab bar when there is a single buffer
  auto_hide = false,

  -- Enable/disable current/total tabpages indicator (top right corner)
  tabpages = true,

  -- Enable/disable close button
  closable = true,

  -- Enables/disable clickable tabs
  --  - left-click: go to buffer
  --  - middle-click: delete buffer
  clickable = true,

  -- Enables / disables diagnostic symbols
  diagnostics = {
    -- you can use a list
    {enabled = true, icon = 'ﬀ'}, -- ERROR
    {enabled = false}, -- WARN
    {enabled = false}, -- INFO
    {enabled = true},  -- HINT

    -- OR `vim.diagnostic.severity`
    [vim.diagnostic.severity.ERROR] = {enabled = true, icon = 'ﬀ'},
    [vim.diagnostic.severity.WARN] = {enabled = false},
    [vim.diagnostic.severity.INFO] = {enabled = false},
    [vim.diagnostic.severity.HINT] = {enabled = true},
  },

  -- Excludes buffers from the tabline
  exclude_ft = {'javascript'},
  exclude_name = {'package.json'},

  -- Hide inactive buffers and file extensions. Other options are `current` and `visible`
  hide = {extensions = true, inactive = true},


  -- Enable/disable icons
  -- if set to 'numbers', will show buffer index in the tabline
  -- if set to 'both', will show buffer index and icons in the tabline
  icons = true,

  -- If set, the icon color will follow its corresponding buffer
  -- highlight group. By default, the Buffer*Icon group is linked to the
  -- Buffer* group (see Highlighting below). Otherwise, it will take its
  -- default value as defined by devicons.
  icon_custom_colors = false,

  -- Configure icons on the bufferline.
  icon_separator_active = '▎',
  icon_separator_inactive = '▎',
  icon_close_tab = '',
  icon_close_tab_modified = '●',
  icon_pinned = '車',

  -- If true, new buffers will be inserted at the start/end of the list.
  -- Default is to insert after current buffer.
  insert_at_end = false,
  insert_at_start = false,

  -- Sets the maximum padding width with which to surround each tab
  maximum_padding = 1,

  -- Sets the minimum padding width with which to surround each tab
  minimum_padding = 1,

  -- Sets the maximum buffer name length.
  maximum_length = 30,

  -- If set, the letters for each buffer in buffer-pick mode will be
  -- assigned based on their name. Otherwise or in case all letters are
  -- already assigned, the behavior is to assign letters in order of
  -- usability (see order below)
  semantic_letters = true,

  -- New buffer letters are assigned in this order. This order is
  -- optimal for the qwerty keyboard layout but might need adjustement
  -- for other layouts.
  letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',

  -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
  -- where X is the buffer number. But only a static string is accepted here.
  no_name_title = nil,
}
```

### Highlighting

For the highlight groups, here are the default ones. Your colorscheme
can override them by defining them. See the "Meaning of terms" comment
inside the example below.

```vim
let fg_target = 'red'

let fg_current  = s:fg(['Normal'], '#efefef')
let fg_visible  = s:fg(['TabLineSel'], '#efefef')
let fg_inactive = s:fg(['TabLineFill'], '#888888')

let fg_modified  = s:fg(['WarningMsg'], '#E5AB0E')
let fg_special  = s:fg(['Special'], '#599eff')
let fg_subtle  = s:fg(['NonText', 'Comment'], '#555555')

let bg_current  = s:bg(['Normal'], '#000000')
let bg_visible  = s:bg(['TabLineSel', 'Normal'], '#000000')
let bg_inactive = s:bg(['TabLineFill', 'StatusLine'], '#000000')

" Meaning of terms:
"
" format: "Buffer" + status + part
"
" status:
"     *Current: current buffer
"     *Visible: visible but not current buffer
"    *Inactive: invisible but not current buffer
"
" part:
"        *Icon: filetype icon
"       *Index: buffer index
"         *Mod: when modified
"        *Sign: the separator between buffers
"      *Target: letter in buffer-picking mode
"
" BufferTabpages: tabpage indicator
" BufferTabpageFill: filler after the buffer section
" BufferOffset: offset section, created with set_offset()

call s:hi_all([
\ ['BufferCurrent',        fg_current,  bg_current],
\ ['BufferCurrentIndex',   fg_special,  bg_current],
\ ['BufferCurrentMod',     fg_modified, bg_current],
\ ['BufferCurrentSign',    fg_special,  bg_current],
\ ['BufferCurrentTarget',  fg_target,   bg_current,   'bold'],
\ ['BufferVisible',        fg_visible,  bg_visible],
\ ['BufferVisibleIndex',   fg_visible,  bg_visible],
\ ['BufferVisibleMod',     fg_modified, bg_visible],
\ ['BufferVisibleSign',    fg_visible,  bg_visible],
\ ['BufferVisibleTarget',  fg_target,   bg_visible,   'bold'],
\ ['BufferInactive',       fg_inactive, bg_inactive],
\ ['BufferInactiveIndex',  fg_subtle,   bg_inactive],
\ ['BufferInactiveMod',    fg_modified, bg_inactive],
\ ['BufferInactiveSign',   fg_subtle,   bg_inactive],
\ ['BufferInactiveTarget', fg_target,   bg_inactive,  'bold'],
\ ['BufferTabpages',       fg_special,  bg_inactive, 'bold'],
\ ['BufferTabpageFill',    fg_inactive, bg_inactive],
\ ])

call s:hi_link([
\ ['BufferCurrentIcon',  'BufferCurrent'],
\ ['BufferVisibleIcon',  'BufferVisible'],
\ ['BufferInactiveIcon', 'BufferInactive'],
\ ['BufferOffset',       'BufferTabpageFill'],
\ ])

" NOTE: this is an example taken from the source, implementation of
" s:fg(), s:bg(), s:hi_all() and s:hi_link() is left as an exercise
" for the reader.
```

[See code for the example above](https://github.com/romgrk/barbar.nvim/blob/master/lua/bufferline/highlight.lua)

You can also use the [doom-one.vim](https://github.com/romgrk/doom-one.vim)
colorscheme that defines those groups and is also very pleasant as you could see
in the demos above.

### Integration with filetree plugins

To ensure tabs begin with the shown buffer you can set an offset for the tabline.

![filetree-with-offset](./static/filetree-with-offset.png)

Add this autocmds to your configuration.

```lua
vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = '*',
  callback = function()
    if vim.bo.filetype == 'NvimTree' then
      require'bufferline.api'.set_offset(31, 'FileTree')
    end
  end
})

vim.api.nvim_create_autocmd('BufWinLeave', {
  pattern = '*',
  callback = function()
    if vim.fn.expand('<afile>'):match('NvimTree') then
      require'bufferline.api'.set_offset(0)
    end
  end
})
```

And add a mapping to use the above functions:

```vim
noremap <silent> <C-n> :lua require'tree'.toggle()<CR>
```

In the case of `nvim-tree`, there is an even simpler solution because it exposes an events API.
You can add the following functions and then use `nvim-tree` mappings:

```lua
local nvim_tree_events = require('nvim-tree.events')
local bufferline_api = require('bufferline.api')

local function get_tree_size()
  return require'nvim-tree.view'.View.width
end

nvim_tree_events.subscribe('TreeOpen', function()
  bufferline_api.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe('Resize', function()
  bufferline_api.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe('TreeClose', function()
  bufferline_api.set_offset(0)
end)
```

## Known Issues

#### Netrw

`:BufferNext`/`:BufferPrevious` don't work in netrw buffer due to an issue in
netrw. See [this comment](https://github.com/romgrk/barbar.nvim/issues/82#issuecomment-748498951)
for a workaround.

#### Lightline

Barbar doesn't show up because lightline changes the tabline setting. Add:

```vim
let g:lightline={ 'enable': {'statusline': 1, 'tabline': 0} }
```

## About

Barbar is called barbar because it's a bar, but it's also more than a bar:
a "barbar".

It is pronounced like "Jar Jar" in "Jar Jar Binks", but with Bs.

No, barbar has nothing to do with barbarians.

## License

barbar.nvim: Distributed under the terms of the JSON license.  
bbye.vim: Distributed under the terms of the GNU Affero license.
