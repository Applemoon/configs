set number
set encoding=utf8
filetype plugin on
colorscheme corporation

set wildmenu
set wcm=<Tab>

menu Encoding.koi8-r :e ++enc=koi8-r ++ff=unix<CR>
menu Encoding.windows-1251 :e ++enc=cp1251 ++ff=dos<CR>
menu Encoding.cp866 :e ++enc=cp866 ++ff=dos<CR>
menu Encoding.utf-8 :e ++enc=utf8 <CR>
menu Encoding.koi8-u :e ++enc=koi8-u ++ff=unix<CR>
map <F8> :emenu Encoding.<TAB>

set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan

execute pathogen#infect()

