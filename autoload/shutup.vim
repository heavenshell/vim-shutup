let s:save_cpo = &cpo
set cpo&vim

let g:shutup_patterns = get(g:, 'shutup_patterns', {})

function! s:get_range() abort
  " Get visual mode selection.
  let mode = visualmode(1)
  if mode == 'v' || mode == 'V' || mode == ''
    let start_lnum = line("'<")
    let end_lnum = line("'>")
    return {'start_lnum': start_lnum, 'end_lnum': end_lnum}
  endif

  return {'start_lnum': 1, 'end_lnum': '$'}
endfunction

function! s:execute(qflist, position, lnum) abort
  let results = []
  let filtered_list = filter(deepcopy(a:qflist), { _, v -> v['lnum'] == a:lnum })
  let i = 0
  let save_cursor = getcurpos()
  for l in filtered_list
    for p in keys(g:shutup_patterns)
      let matched = matchstr(string(l['text']), p)
      if matched != ''
        let F = g:shutup_patterns[p]
        let value = F(matched, a:position)
        if value == ''
          continue
        endif
        if i == 0
          call add(results, value)
        else
          call add(results, matched)
        endif
        let i = i + 1
      endif
    endfor
  endfor
  let value = join(results, ',')
  if a:position == 'upper'
    silent! execute 'normal! O' . value
    call setpos('.', [save_cursor[0], save_cursor[1] + 1, save_cursor[2], save_cursor[3], save_cursor[4]])
  else
    silent! execute 'normal! $a' . value
    call setpos('.', [save_cursor[0], save_cursor[1], save_cursor[2], save_cursor[3], save_cursor[4]])
  endif
endfunction

function! shutup#run(qargs, count, line1, line2, position) abort
  let qflist = len(getqflist()) ? getqflist() : getloclist(win_getid())
  if len(qflist) > 0
    let range = s:get_range()
    if range['end_lnum'] == '$'
      call s:execute(qflist, a:position, line('.'))
    else
      let end_lnum = range['end_lnum'] == '$' ? line('.') : range['end_lnum']
      let start_lnum = range['start_lnum']
      let save_cursor = getcurpos()
      for lnum in range(start_lnum, end_lnum)
        call s:execute(qflist, a:position, lnum)
        silent! execute 'normal! j'
      endfor
      call setpos('.', save_cursor)
    endif
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
