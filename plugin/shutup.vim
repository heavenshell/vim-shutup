let s:save_cpo = &cpo
set cpo&vim

command! -nargs=* -range=0 -complete=customlist,gql#complete Gql :call gql#run(<q-args>, <count>, <line1>, <line2>)

command! Shutup     :call shutup#run('')
command! ShutupNext :call shutup#run('upper')
noremap <buffer> <Plug>(Shutup) :Shutup<CR>
noremap <buffer> <Plug>(ShutupNext) :ShutupNext<CR>

let &cpo = s:save_cpo
unlet s:save_cpo
