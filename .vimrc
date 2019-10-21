syntax on

" контраст темы gruvbox
let g:gruvbox_contrast_dark = 'hard'

" запуск патогена для плагинов
execute pathogen#infect()

" номер строки
set number

" поиск во время ввода
set incsearch

" игнорирует регистр поиска, пока не введена заглавная
set ignorecase smartcase

" кодировка
set encoding=utf8

filetype plugin on

" тема
colorscheme gruvbox 
set background=dark

" переносы по словам
set linebreak

" подсветка строки с курсором (тормозит)
"set cursorline

set wildmenu
set wcm=<Tab>

" выбор кодировки файла по <F8>
menu Encoding.koi8-r :e ++enc=koi8-r ++ff=unix<CR>
menu Encoding.windows-1251 :e ++enc=cp1251 ++ff=dos<CR>
menu Encoding.cp866 :e ++enc=cp866 ++ff=dos<CR>
menu Encoding.utf-8 :e ++enc=utf8 <CR>
menu Encoding.koi8-u :e ++enc=koi8-u ++ff=unix<CR>
map <F8> :emenu Encoding.<TAB>

" русская раскладка
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

" настройки для airline
set laststatus=2
let g:airline_powerline_fonts = 1
set noshowmode " убрать дополнительное отображение режима
let g:airline_theme='dark' 

" отображать введенную команду
set showcmd

" пробел как pagedown
nmap <Space> <PageDown>

" подсветка переменных по <F12>
autocmd CursorMoved * exe exists("hluc")?hluc?printf('match MatchParen /\V\<%s\>/', escape(expand('<cword>'), '/\')):'match none':""
nnoremap <F12> :exe "let hluc=exists(\"hluc\")?hluc*-1+1:1"<CR>

" привычная работа с мышью
set mouse=a

" перемещение по вкладкам
imap <F5> <Esc> :tabprev <CR>i
map <F5> :tabprev <CR>
imap <F6> <Esc> :tabnext <CR>i
map <F6> :tabnext <CR>

" сохранение файла по <F2>
nnoremap <F2> :w<CR>
