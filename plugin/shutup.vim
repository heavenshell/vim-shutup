" File: shutup.vim
" Author: Shinya Ohyanagi <sohyanagi@gmail.com>
" WebPage: http://github.com/heavenshell/vim-shutup
" Description: Supress diagnostic error with rule name.
" License: BSD, see LICENSE for more details.
let s:save_cpo = &cpo
set cpo&vim

command! -nargs=* -range=0 Shutup :call shutup#run(<q-args>, <count>, <line1>, <line2>, '')
command! -nargs=* -range=0 ShutupNext :call shutup#run(<q-args>, <count>, <line1>, <line2>, 'upper')

let &cpo = s:save_cpo
unlet s:save_cpo
