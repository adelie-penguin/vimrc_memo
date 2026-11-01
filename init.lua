-- vim: set foldmethod=marker : --

-------------------------------------------------
-- lazy.nvimでファイル管理
-------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
	"itchyny/calendar.vim",
	"rebelot/kanagawa.nvim",
	"cameron-wags/rainbow_csv.nvim",
})

-------------------------------------------------
-- colorscheme
-------------------------------------------------

vim.opt.termguicolors = true
vim.cmd('syntax on')
vim.cmd('colorscheme kanagawa-dragon')

-------------------------------------------------
-- keymap
-------------------------------------------------

-- 危険なマッピング
vim.keymap.set('n', 'f', 'd$')
vim.keymap.set('n', 'Y', 'yy')

-- ターミナルのキーマップ
vim.keymap.set('n', ':terminal', ':vert terminal')
-- shift押しながら上にカーソル移動したらnormalモード
vim.keymap.set('t', 'KK', [[<C-\><C-n>]])

--表示による改行をjkに反映
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')


-- 日本語句点の禁止
vim.keymap.set('i', '、', '，')
vim.keymap.set('i', '。', '．')

-- Tabのインデント編集
vim.keymap.set('n', 'tt', 'i<TAB><ESC>jhhhhh<ESC>')
vim.keymap.set('n', 'rr', 'xj<ESC>')

--改行^Mの削除
vim.keymap.set('n', ':MM', ':%s/\r$//g')

-- ファイル比較
vim.keymap.set('n', ':vdiff', ':vertical diffsplit ')

-- ウインドウ最大化は不要
vim.keymap.set('n', ':W', ':w')

-- 検索ハイライトのON/OFFトリガスイッチ
vim.keymap.set('n', '<Esc><Esc>', ':set nohlsearch!<CR>')

-------------------------------------------------
-- gvimのsetコマンド
-------------------------------------------------

-- いつメン
vim.opt.tabstop    = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = false
vim.opt.number     = true

-- 検索で大小文字を区別しない(混合時は除く)
vim.opt.ignorecase = true
vim.opt.smartcase  = true

-- スワップファイルを作らない
vim.opt.swapfile = false

-- 括弧の強調禁止
vim.g.loaded_matchparen = 1 


--[ ステータスライン]----------------------------

-- 分割ウインドウ間で共有
vim.opt.laststatus = 3
vim.opt.statusline = [[%!v:lua.PenguinStatusline()]]

function PenguinStatusline()

	local l1_h = '%#IncSearch#'
	local l1_m = ' NORMAL '
	local r1_m = os.date("%Y/%m/%d(%H:%M)")

	if vim.api.nvim_get_mode().mode == 'i' then
		l1_h = '%#CurSearch#'
		l1_m = ' INSERT '
	end
	return l1_h..l1_m..'%* %t%='..r1_m
end

--[ 折畳ライン]----------------------------------

--marker行の1行下にある内容を表示するのだ
vim.opt.foldtext = [[v:lua.PenguinFoldtext()]]

function PenguinFoldtext()
	local fold_cnt  = vim.v.foldend - vim.v.foldstart + 1
	local text_line = vim.fn.getline(vim.v.foldstart + 1)
	return '▶ '..'['..fold_cnt..']'..text_line..' '
end

--[ <ESC>で自動英語モード ]----------------------

vim.api.nvim_create_autocmd("InsertLeave", {command = "silent! !/mnt/c/Users/Adelie/Program_Files/zenhan.exe 0"})


-------------------------------------------------
-- .vimrcからの移植
-------------------------------------------------


--[ Calendarの設定 ]----------------------------

-- スケジュールを保存するディレクトリを設定
-- カレンダーの切替は「<」または「>」
vim.cmd[[
if has('unix')
	let g:calendar_cache_directory = "/mnt/c/Users/Adelie/vimfiles/calendar/"
else
	let g:calendar_cache_directory = "C:/Users/Adelie/vimfiles/calendar/"
endif

let g:calendar_views = ['month', 'clock', 'year']
]]
