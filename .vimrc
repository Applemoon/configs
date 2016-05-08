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

" подсветка строки с курсором
set cursorline

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

