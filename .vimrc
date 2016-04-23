" номер строки
set number

" кодировка
set encoding=utf8
filetype plugin on
colorscheme corporation

" переносы по словам
set linebreak

set wildmenu
set wcm=<Tab>

" выбор кодировки файла по F8
menu Encoding.koi8-r :e ++enc=koi8-r ++ff=unix<CR>
menu Encoding.windows-1251 :e ++enc=cp1251 ++ff=dos<CR>
menu Encoding.cp866 :e ++enc=cp866 ++ff=dos<CR>
menu Encoding.utf-8 :e ++enc=utf8 <CR>
menu Encoding.koi8-u :e ++enc=koi8-u ++ff=unix<CR>
map <F8> :emenu Encoding.<TAB>

" русская раскладка
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

" запуск патогена для плагинов
execute pathogen#infect()

" перечитывание вимрц на лету (вроде как)
autocmd! bufwritepost ~/.vimrc execute "normal! :source ~/.vimrc"

