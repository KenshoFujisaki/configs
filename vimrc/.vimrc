"----------------------------------------------------
" 基本的な設定
"----------------------------------------------------
" viとの互換性をとらない(vimの独自拡張機能を使う為)
set nocompatible
" 改行コードの自動認識
set fileformats=unix,dos,mac
" ビープ音を鳴らさない
set vb t_vb=
" バックスペースキーで削除できるものを指定
" indent  : 行頭の空白
" eol     : 改行
" start   : 挿入モード開始位置より手前の文字
set backspace=indent,eol,start
" クリップボード連携
set clipboard+=unnamed

"----------------------------------------------------
" バックアップ
"----------------------------------------------------
" バックアップをとらない
set nobackup
" ファイルの上書きの前にバックアップを作る
" (ただし、backup がオンでない限り、バックアップは上書きに成功した後削除される)
set writebackup
" バックアップをとる場合
"set backup
" バックアップファイルを作るディレクトリ
"set backupdir=~/backup
" スワップファイルを作るディレクトリ
"set directory=~/swap
" undoの履歴ファイル
set undofile

"----------------------------------------------------
" 検索
"----------------------------------------------------
" コマンド、検索パターンを100個まで履歴に残す
set history=100
" 検索の時に大文字小文字を区別しない
set ignorecase
" 検索の時に大文字が含まれている場合は区別して検索する
set smartcase
" 最後まで検索したら先頭に戻る
set wrapscan
" インクリメンタルサーチする
set incsearch

"----------------------------------------------------
" 表示関係
"----------------------------------------------------
" タイトルをウインドウ枠に表示する
set title
" 行番号を表示しない
set number
" ルーラーを表示
"set ruler
" タブ文字を CTRL-I で表示し、行末に $ で表示する
set list
set listchars=tab:\|\ ,trail:_,eol:↲,extends:>,precedes:<,nbsp:%
" 入力中のコマンドをステータスに表示する
set showcmd
" ステータスラインを常に表示
set laststatus=2
" 括弧入力時の対応する括弧を表示
set showmatch
" 対応する括弧の表示時間を2にする
set matchtime=2
" シンタックスハイライトを有効にする
syntax on
" 検索結果文字列のハイライトを有効にする
set hlsearch
" コメント文の色を変更
highlight Comment ctermfg=DarkCyan
" コマンドライン補完を拡張モードにする
set wildmenu
" 入力されているテキストの最大幅
" 行がそれより長くなると、この幅を超えないように空白の後で改行されるを無効にする
set textwidth=0
" ウィンドウの幅より長い行は折り返して、次の行に続けて表示する
set nowrap
" 全角スペースの表示
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/
" ステータスラインに表示する情報の指定
set statusline=%f%m%=%l,%c\ %{'['.(&fenc!=''?&fenc:&enc).']\ ['.&fileformat.']'}
" ステータスラインの色
highlight StatusLine   term=NONE cterm=NONE ctermfg=black ctermbg=white
" マルチバイト文字でずれないように設定
set ambiwidth=double

"----------------------------------------------------
" インデント
"----------------------------------------------------
" tabstop:     タブが対応する空白の数
" softtabstop: タブやバックスペースの使用等の編集操作をするときに、タブが対応する空白の数
" shiftwidth:  インデントの各段階に使われる空白の数
set shiftwidth=2 tabstop=2 softtabstop=2
augroup vimrc
  autocmd! FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4
augroup END
" タブを挿入するとき、代わりに空白を使わない
set expandtab

"----------------------------------------------------
" 国際化
"----------------------------------------------------
" 文字コードの設定
" fileencodingsの設定ではencodingの値を一番最後に記述する
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,ucs-bom,euc-jp,cp932,iso-2022-jp
set fileencodings+=,ucs-2le,ucs-2

"----------------------------------------------------
" オートコマンド
"----------------------------------------------------
if has("autocmd")
  " ファイルタイプ別インデント、プラグインを有効にする
  filetype plugin indent on
  " カーソル位置を記憶する
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
  " 貼り付け時に自動てコメントが入るのを防止
  autocmd FileType * set formatoptions-=ro
endif

"----------------------------------------------------
" タブ
"----------------------------------------------------
" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap  [Tag] <Nop>
nmap  t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

" tc 新しいタブを一番右に作る
map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tx タブを閉じる
map <silent> [Tag]x :tabclose<CR>
" tn 次のタブ
map <silent> [Tag]n :tabnext<CR>
" tp 前のタブ
map <silent> [Tag]p :tabprevious<CR>
" buffer一覧
map <silent> [Tag]t :Unite buffer file_mru file<CR>

"----------------------------------------------------
" Unite
"----------------------------------------------------
" insert modeで開始
let g:unite_enable_start_insert = 1
" 大文字小文字を区別しない
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1
" grep検索
nnoremap <silent> ,g  :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
" カーソル位置の単語をgrep検索
nnoremap <silent> ,cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W>
" grep検索結果の再呼出
nnoremap <silent> ,r  :<C-u>UniteResume search-buffer<CR>

"----------------------------------------------------
" ctags,cscope,gtags,...などのタグ
"----------------------------------------------------
if has("cscope")
  set csprg=/usr/local/bin/cscope
  set csto=0
  set cst
  set nocsverb
  " add any database in current directory
  if filereadable("cscope.out")
    cs add cscope.out
    " else add database pointed to by environment
  elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
  endif
  set csverb
endif
set cscopetag
set cscopetagorder=1
set cscopequickfix=s-,c-,d-,i-,t-,e-
nmap <C-\><C-\> <Plug>(csutil-toggle-csto)

"----------------------------------------------------
" previm (Github Markdown)
"----------------------------------------------------
augroup PrevimSettings
  autocmd!
  autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
augroup END

"----------------------------------------------------
" vimdiff color
" ref: https://vi.stackexchange.com/questions/10897/how-do-i-customize-vimdiff-colors
"----------------------------------------------------
hi DiffAdd      ctermfg=NONE          ctermbg=LightGreen
hi DiffChange   ctermfg=NONE          ctermbg=NONE
hi DiffDelete   ctermfg=LightBlue     ctermbg=Red
hi DiffText     ctermfg=Yellow        ctermbg=Red

"----------------------------------------------------
" neocomplcache
"----------------------------------------------------
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
  \ 'default' : ''
  \ }

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplcache#smart_close_popup() . "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

"----------------------------------------------------
" quickfix/unite-quickfix
"----------------------------------------------------
" unite-quickfix
let g:syntastic_always_populate_loc_list=1
nnoremap sc :Unite location_list<CR>

"----------------------------------------------------
" lightline (Powerlineのvim簡易版)
"----------------------------------------------------
let g:lightline = {
      \ 'colorscheme': 'landscape',
      \ 'active': {
      \   'left':  [ [ 'mode', 'paste' ],
      \              [ 'filename', 'fugitive', 'modified' ] ],
      \   'right': [ [ 'syntastic', 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'MyFugitive',
      \ },
      \ 'component_expand': {
      \   'syntastic': 'SyntasticStatuslineFlag',
      \ },
      \ 'component_type': {
      \   'syntastic': 'error',
      \ }
      \ }
function! MyFugitive()
  return exists('*fugitive#statusline') ? fugitive#statusline() : ''
end
endfunction
let g:syntastic_mode_map = { 'mode': 'passive' }
augroup AutoSyntastic
  autocmd!
  autocmd BufWritePost *.c,*.cpp,*.rb,*.erb,*.js,*.py call s:syntastic()
augroup END
function! s:syntastic()
  SyntasticCheck
  call lightline#update()
endfunction

"----------------------------------------------------
" quickrun
"----------------------------------------------------
let g:quickrun_config = {
\   "_" : {
\       "hook/close_unite_quickfix/enable_hook_loaded" : 1,
\       "hook/unite_quickfix/enable_failure" : 1,
\       "hook/close_quickfix/enable_exit" : 1,
\       "hook/close_buffer/enable_failure" : 1,
\       "hook/close_buffer/enable_empty_data" : 1,
\       "outputter" : "multi:buffer:quickfix",
\       "hook/shabadoubi_touch_henshin/enable" : 1,
\       "hook/shabadoubi_touch_henshin/wait" : 20,
\       "outputter/buffer/split" : ":top 20sp",
\       "outputter/buffer/into" : 1,
\       "outputter/buffer/running_mark" : "",
\       "runner" : "vimproc",
\       "runner/vimproc/updatetime" : 40,
\   }
\}

"----------------------------------------------------
" automatic
"----------------------------------------------------
let g:automatic_config = [
  \   {
  \       "match" : {
  \           "bufname" : '[\[\*]unite[\]\*]',
  \       },
  \   },
  \   {
  \       "match" : {
  \           "filetype" : 'quickrun',
  \       }
  \   }
  \]

"----------------------------------------------------
" その他
"----------------------------------------------------
" バッファを切替えてもundoの効力を失わない
set hidden
" 起動時のメッセージを表示しない
set shortmess+=I
" vimgrep（横断検索）
autocmd QuickFixCmdPost *grep* cwindow
nmap <C-g> :vimgrep /<C-r><C-w>/ ./**/*
" rubyで%を使えるように
if !exists('loaded_matchit')
  " matchitを有効化
  runtime macros/matchit.vim
endif

"----------------------------------------------------
" NeoBundle（簡易インストール）
"----------------------------------------------------
set nocompatible
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin()

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" Recommended to install
" After install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f
" your_machines_makefile
NeoBundle 'Shougo/vimproc', {
  \ 'build' : {
  \ 'windows' : 'make -f make_mingw32.mak',
  \ 'cygwin' : 'make -f make_cygwin.mak',
  \ 'mac' : 'make -f make_mac.mak',
  \ 'unix' : 'make -f make_unix.mak',
  \ },
  \ }

" 置換リッチ化
NeoBundle 'osyo-manga/vim-over'

" undoツリー
NeoBundle 'sjl/gundo.vim'
let g:gundo_prefer_python3 = 1
nmap U :<C-u>GundoToggle<CR>

" 簡易実行
NeoBundle 'thinca/vim-quickrun'

" 入力補完
if has("lua")
  NeoBundleLazy 'Shougo/neocomplete', { 'autoload' : {
    \ 'insert' : 1,
    \ }}
endif
NeoBundle 'Shougo/neocomplcache'

" 対応括弧の自動入力
NeoBundleLazy 'alpaca-tc/vim-endwise.git', {
  \ 'autoload' : {
  \ 'insert' : 1,
  \ }}
let g:endwise_no_mappings=1

" 対応括弧へのカーソル移動
""NeoBundleLazy 'edsono/vim-matchit', { 'autoload' : {
"  \ 'filetypes': 'ruby',
"  \ 'mappings' : ['nx', '%'] }}

" Uniteによる統合UI
NeoBundle 'Shougo/unite.vim'
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'Shougo/neomru.vim'
NeoBundleLazy 'tsukkee/unite-tag', {
  \ 'depends' : ['Shougo/unite.vim'],
  \ 'autoload' : {
  \ 'unite_sources' : ['tag', 'tag/file', 'tag/include']
  \ }}
NeoBundle 'osyo-manga/unite-quickfix'
NeoBundleLazy 'basyura/unite-rails', {
  \ 'depends' : 'Shougo/unite.vim',
  \ 'autoload' : {
  \ 'unite_sources' : [
  \ 'rails/bundle', 'rails/bundled_gem', 'rails/config',
  \ 'rails/controller', 'rails/db', 'rails/destroy', 'rails/features',
  \ 'rails/gem', 'rails/gemfile', 'rails/generate', 'rails/git', 'rails/helper',
  \ 'rails/heroku', 'rails/initializer', 'rails/javascript', 'rails/lib', 'rails/log',
  \ 'rails/mailer', 'rails/model', 'rails/rake', 'rails/route', 'rails/schema', 'rails/spec',
  \ 'rails/stylesheet', 'rails/view'
  \ ]
  \ }}

" markdown
NeoBundle 'kannokanno/previm'
NeoBundle 'tyru/open-browser.vim'
autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown

" stan
NeoBundle 'maverickg/stan.vim'
autocmd BufNewFile,BufRead *.stan,*.STAN set filetype=stan

" processing
NeoBundle "sophacles/vim-processing"
autocmd BufNewFile,BufRead *.pde set filetype=processing

" csv
NeoBundle "chrisbra/csv.vim"

" rails
NeoBundle 'tpope/vim-rails', { 'autoload' : {
  \ 'filetypes' : ['haml', 'ruby', 'eruby'] }}

" インデント表示
NeoBundle 'Yggdroot/indentLine'
let g:indentLine_color_term = 239
let g:indentLine_color_gui = 'red'
let g:indentLine_char = '¦' "use ¦, ┆ or │
"autocmd BufWritePost * IndentLinesReset

" 構文チェック
NeoBundle 'scrooloose/syntastic.git'
filetype plugin indent on

" lightline(powerline簡易版)
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'airblade/vim-gitgutter'

" automatic(ウインドウ自動分割)
NeoBundle "osyo-manga/vim-automatic"
NeoBundle "osyo-manga/vim-gift"

" Brief help
" :NeoBundleList          - list configured bundles
" :NeoBundleInstall(!)    - install(update) bundles
" :NeoBundleClean(!)      - confirm(or auto-approve) removal of unused bundles

" Installation check.
NeoBundleCheck
call neobundle#end()
