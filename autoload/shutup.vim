let s:save_cpo = &cpo
set cpo&vim

let g:shutup_patterns = get(g:, 'shutup_patterns', {})

function! shutup#run(position) abort
  let qflist = len(getqflist()) ? getqflist() : getloclist(bufnr('%'))
  if len(qflist) > 0
    let results = []
    let lnum = line('.')
    let filtered_list = filter(qflist, { _, v -> v['lnum'] == lnum })
    let save_cursor = getcurpos()
    let i = 0
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
      call setpos('.', save_cursor)
    endif
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
