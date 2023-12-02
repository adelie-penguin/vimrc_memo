" vim: set tabstop=4 nowrap foldmethod=marker :
"========================================================================
"
" vimrc ver.2022.12.07 
"
"　　※部分的に機能していない設定あり
"
"========================================================================

"viと互換性のないコマンドを使用します
if &compatible
	set nocompatible
endif

"------------------------------------------------------------------------

" 敬虔なるvimmerに怒られそうな設定
map f d$

"改行コードの自動認識
set fileformats=unix,dos,mac

set clipboard=unnamed,autoselect	"コピペのレジスタをwinデフォルトと共有
set backspace=indent,eol,start 		"BSキーの使用可能範囲拡大

set tabstop=4
set shiftwidth=4
set noautoindent
set number

set noerrorbells	"ビープ音を鳴らさない

set vb t_vb=		"画面の点滅禁止
let loaded_matchparen = 1 "括弧の強調停止

set modeline      "モードラインを有効化
set laststatus=2	"ステータスラインを常に表示
set noshowmode		"画面下の「ビジュアル」都下の表示を消去

set noswapfile		"スワップファイルは作らない

set ignorecase		"検索で大文字小文字を区別しない
set smartcase

set nojoinspaces	"コマンドJでスペースを挟まない
set keymodel=startsel	"Shift+矢印キー で選択

set completeopt=menu,preview,menuone	"補完
set showfulltag		"タグファイルから単語補完

set guioptions=

"256色ちゃんと表示できますよー
if !has('gui_funning')
		set  t_Co=256
endif

"バックアップファイルの作成
set writebackup
set backup

"------------------------------------------------------------------------
"OS分岐
"
if has('unix')

	"バックアップファイルの設定
	set backupdir =~/Backup_vi/
	set directory =~/Backup_vi/
	set undodir   =~/Backup_vi/

	"1行に入る最大のコメントアウト幅
	map cl  i /*<Esc>76a-<Esc>a*/<Esc>

	"フォントの設定
    set guifont=UDEV\ Gothic\ JPDOC\ 12

else

	let $HOME = "C:/Users/adelie"
	set runtimepath+=$HOME
	set runtimepath+="C:\msys64\mingw64\bin"
	set runtimepath+=$HOME/vimfiles
	set packpath+=$HOME/vimfiles
	"バックアップファイルの設定
	let g:backup_dir = "C:/Users/adelie/Documents/backup"
	let &backupdir = g:backup_dir
	let &directory = g:backup_dir
	let &undodir   = g:backup_dir

	"フォントの設定
	set guifont=UDEV_Gothic_JPDOC:h12:cSHIFTJIS

endif
  
"------------------------------------------------------------------------
"折り畳みの部分の表示設定

set foldtext=PenguinFoldText()

function! PenguinFoldText()
	let line = getline(v:foldstart+1)
	let sub  = substitute(line, '/\*|\*/|{\d\=', '', 'g')
	let fold_cnt = v:foldend - v:foldstart + 1
	return '+' . v:folddashes . '[' . fold_cnt . ']' . sub . ' '
endfunction


"------------------------------------------------------------------------
" 僕が好きなのは僕のvimなんだーmap集
"------------------------------------------------------------------------

"表示による改行をjkに反映
:nnoremap j gj
:nnoremap k gk

"タブ幅編集
map tt i<TAB><ESC>j5h<ESC>
map rr xj<ESC>

"日本語句点の禁止
inoremap 、 ，
inoremap 。 ．

"ファイル比較
map :vdiff :vertical<Space>diffsplit<Space>

"ウインドウ最大化は不要
map :W :w

"検索ハイライトのON/OFFトリガスイッチ
nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR>

colorscheme penguindark

"------------------------------------------------------------------------
"ターミナルのキーマップ
"
if exists(":tmap")
	"上にカーソル上に移動したらnormalモード
	tnoremap kk <C-w><S-n> 	
	map :terminal :vert terminal
endif

" terminalの色設定
let g:terminal_ansi_colors = [
			\  "#7493be",  "#7493be",  "#7493be", "#7493be", 
			\  "#99ad6a",  "#99ad6a",  "#99ad6a", "#99ad6a", 
			\  "#99ad6a",  "#99ad6a",  "#99ad6a", "#99ad6a", 
			\  "#99ad6a",  "#99ad6a",  "#99ad6a", "#99ad6a"
			\ ]
                                        
"------------------------------------------------------------------------
"拡張子識別設定
"------------------------------------------------------------------------
augroup filetype
	au!		
	au BufRead 		*.c set syntax=cpp
	au BufRead 		*.h set syntax=cpp
	au BufRead 		*.cu set syntax=cpp
	au BufRead 		*.htm set nowrap
	au BufRead 		*.txt call Tex_comment_emphasis()
	au BufRead 		*.tex call PenguinTex()
	au BufRead  	*.bib call Bib_function()
	au BufNewFile 	*.h call H_Head()
	au BufNewFile 	*.c call C_Head()
	au BufNewFile   *.bib call Bib_new()
augroup END

"---------------------------------
".hと.cファイルにifdefを追加

function! H_Head()
	let headname = substitute(toupper(expand("%:t")), "\\.", "_", "g")
	normal! gg
	execute "normal! i/* vim: set tabstop=4 : */"
	execute "normal! o/*\<Esc>75i*\<Esc>3o\<CR>\<Esc>75a*\<Esc>a/"
	execute "normal! o#ifndef __PENGUIN_" . headname . "\<Esc>"
	execute "normal! o#define __PENGUIN_" . headname . "\<Esc>5o\<CR>"
	execute "normal! Go#endif /* #ifdef __PENGUIN_" . headname . "*/"
endfunction

function! C_Head()
	normal! gg
	execute "normal! i/* vim: set tabstop=4 : */"
	execute "normal! o/*\<Esc>75i*\<Esc>3o\<CR>\<Esc>75a*\<Esc>a/"
	execute "normal! :4\<CR>$35a--\<Esc>"
	execute "normal! Go#include<stdio.h>"
	execute "normal! o#include<stdlib.h>"
	execute "normal! o#include<string.h>"
	execute "normal! oint main(int argc, char *argv[])\<CR>{\<CR>return(0);\<CR>}"
endfunction

"------------------------------
"テキストファイルでTexコメント(%コメント)を強調

function! Tex_comment_emphasis()
	syn match penguinTXTcomment 	/^%.*/
	hi penguinTXTcomment guifg=#7493BE
	hi penguinTXTcomment guifg=#7493BE
endfunction

"------------------------------------------------------------------------
" .texファイルの設定強化

function! PenguinTex()
	"ファイルのジャンプ強化(うまく動かないorz)
	au BufRead *.tex let b:match_words = '<if>:<fi>,<\\if>:<\\fi>,begin:end,\\begin:\\end'
	"\beginから始まる内容を\endで作成
	inoremap <expr><buffer> \end  PenguinTexBE()<Esc>0/}<CR>ld$i
endfunction

"map用関数：\beginから始まる内容を\endで作成
function! PenguinTexBE()
	let l:flg = 1				"begin-endの入れ子に対応
	let l:count = line('.') - 1	"チェックする行番号(カーソルの1つ上の行で初期化)
	while l:count > 0 
		let l:line = getline(l:count) 
		if l:line =~ '\\begin' 		"パターンマッチング
			let l:flg = l:flg - 1
		endif
		if l:flg == 0
			let l:line = substitute(l:line, '.*\zs\\begin\ze.*', '\\end', '')
			let l:line = substitute(l:line, '.*\zs}.*\ze', '}', '')
			return l:line 
		endif
		if l:line =~ '\\end'
			let	l:flg = l:flg + 1 "ペアのbeginが遠くなった…
		endif
		let l:count = l:count - 1
	endwhile
	return '\end{}'
endfunction

"------------------------------
"bibファイルを最初に開いた時だけmapの一覧を表示

function! Bib_new()
	normal! gg
	execute "normal! i\"the penguin_map is availabale\<CR>\":add\<CR>\":book\<CR>\":web\<CR>\":direct\<CR>"
	call Bib_function()
endfunction

"------------------------------
"bibファイル用のmap
"
function! Bib_function()
	set notimeout	"マッピング待ちにタイムアウトなし
	map <buffer> :add Go@article{,<ENTER><TAB>author="",<ENTER>title=""<ENTER>,journal="",<ENTER>volume="",<ENTER>number="",<ENTER>pages="",<ENTER>year="",<ENTER>}<ESC>
	map <buffer> :book Go@book{,<ENTER><TAB>author="",<ENTER>title="",<ENTER>publisher="",<ENTER>year="",<ENTER>}<ESC>
	map <buffer> :web Go@webpage{,<ENTER><TAB>author="",<ENTER>title="",<ENTER>date="",<ENTER>}<ESC>
	map <buffer> :direct Go@direct{,<ENTER><TAB>title="",<ENTER>}<ESC>
endfunction

"------------------------------------------------------------------------
" kana/vim-tabpagecdからの借パク
"------------------------------------------------------------------------
":cdコマンドがタブページごとに管理できる
augroup plugin-tabpagecd
	autocmd!
	autocmd TabEnter *	if exists('t:cwd') |   cd `=t:cwd` | endif
	autocmd TabLeave * 	let t:cwd = getcwd()
augroup END

"------------------------------------------------------------------------
" insertモードは行番号を非表示
" 	cohama/insert_linenr.vimから借パク
"------------------------------------------------------------------------
let g:penguin_lineNr = ''

augroup penguin_LineNr
	au!
	au InsertEnter * call s:Penguin_LineNr_insert()	"文字色を元に戻す 
	au InsertLeave * call s:Penguin_LineNr_normal()	"文字色を変更
	au ColorScheme * call s:Penguin_LineNr_init()	"色情報取得
augroup End


function! s:Penguin_LineNr_insert() 
	execute s:penguin_b
endfunction
"
function! s:Penguin_LineNr_normal() 
	execute s:penguin_f
endfunction
"
function! s:Penguin_LineNr_init() 
	"コマンド実行結果の文字列を利用
	let s:penguin_f = ''	" LineNrのそのまま利用
	let s:penguin_b = ''	" Normalの背景色情報を加工
	redir => s:penguin_f
		silent execute 'highlight LineNr '
	redir END
	redir => s:penguin_b
		silent execute 'highlight Normal '
	redir END
	"文字列置換(fはデフォルト設定なのでguifg後部の設定が残ってもOK)
	let s:penguin_f = 'highlight LineNr ' . substitute(s:penguin_f, '\zs.*guifg\ze.*', 'guifg' , '')
	let s:penguin_b = substitute(s:penguin_b, '\zs.*guibg\ze.*', 'guifg' , '')
	"let s:penguin_b = 'highlight LineNr ' . substitute(s:penguin_b, '.* \zs.*\ze', '' , '') "番号を背景色にする
	let s:penguin_b = 'highlight LineNr guifg=#99ad6a'
endfunction

"------------------------------------------------------------------------
" GDB
"------------------------------------------------------------------------
packadd termdebug
set mouse=a
let g:termdebug_wide=160

"------------------------------------------------------------------------
" jetpack
"------------------------------------------------------------------------
packadd vim-jetpack
call jetpack#begin()
	Jetpack 'tani/vim-jetpack', {'opt': 1} "bootstrap
	Jetpack 'itchyny/calendar.vim'
	Jetpack 'itchyny/lightline.vim'
	Jetpack 'vim-scripts/gtags.vim'
call jetpack#end()

"------------------------------
" lightlineの設定
"------------------------------
let g:lightline = {
	\	'colorscheme':'wombat',
	\	'active': {		'left'  : [['mode'],['imeFunction'],['filename']],
	\					'right' : [['whatTime'],['readonly'],['addFunction']],
	\	},
	\	'inactive': {	'left'  : [[ ], ['filename']],
	\					'right' : [[ ], ['readonly']],
	\	},
	\	'component_function' : {'addFunction' : 'PenguinLine', 'imeFunction':'PenguinIME', 'whatTime':'PenguinTime'},
	\	'subseparator' : {'left':''},
	\}

"本当は，IMEの状態を取得してJまたはEを表示したかったの
"→表示はできるようになったけど，SAN値ピンチを消すのが忍びない
"どうしてこうなった…(´・ω・`)
let g:san_chi = 0
function! PenguinLine()
	if g:san_chi == 0
		let g:san_chi = 1
		if getimstatus() == 0
			return '＼(・ω・＼) sanity！'
		else
			return '＼(・д・＼) SAN値！'
		endif
	else
		let g:san_chi = 0
		if getimstatus() == 0
			return '(／・ω・)／ pinch！'
		else
			return '(／・д・)／ ピンチ！'
		endif
	endif
endfunction


function! PenguinIME()
	if getimstatus() == 0
		set imsearch=0
		return 'E'
	else
		set imsearch=2
		return 'J'
	endif
endfunction

function! PenguinTime()
	return strftime("%Y/%m/%d(%H:%M)")
endfunction
"------------------------------
" Calendarの設定
"------------------------------

"スケジュールを保存するディレクトリ
if has('unix')
	let g:calendar_cache_directory = "~/.vim/calendar/"
else
	let g:calendar_cache_directory = "C:/Users/adelie/vimfiles/calendar/"
endif

"------------------------------
" gtagsの設定
"------------------------------

"タグファイル指定 (セミコロンで親ディレクトリを遡る)
set tags+=./tags;
nmap <C-]>   <C-w>v:GtagsCursor<CR>

"------------------------------------------------------------------------
" コマンドメモ
"------------------------------------------------------------------------
"文字コーディング関係
"set displayencoding=euc-jp
"set fileencoding=euc-jp
"
"文字コードを指定してファイルを開く
"e ++enc=cp932
"
"IMEの日/英切替
"	execute	<C-^>
"	
"その場でマクロ
"	記録	qa → a
"	実行	@a
"
":terminal
"Normalモード: [Ctrl]+[w]+([shift]+[n])
"
"Jetpackのpulginインストールコマンド
":JetpackSync
"
"カレンダー
":Calendar 
":Calendar -view=year -split=vertical -width=23
":calendar -view=clock

