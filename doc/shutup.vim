*shutup*	Supress diagnostic error with rule name.

Version: 1.0.0
Author: Shinya Ohynagi <sohyanagi@gmail.com>
Repository: http://github.com/heavenshell/vim-shutup/
License: BSD, see LICENSE for more details.

==============================================================================
CONTENTS						*shutup-contents*

Introduction		|shutup-introduction|
Install			|shutup-install|
Usage			|shutup-usage|
Changelogs		|shutup-changelog|

==============================================================================
INTRODUCTION						*shutup-introduction*

If vim-lsp, ALE or etc, shows diagnostic error, you can add
`// eslint-disable-line` to your source code and supress error message.
|shutup| help to add supress message.

==============================================================================
INSTALL							*shutup-install*

Install the distributed files into Vim runtime directory which is usually
~/.vim/, or $HOME/vimfiles on Windows.

If you use built in `package`, you should extract the
file into '~/.vim/pack/*/start' directory.

==============================================================================
TUTORIAL						*shutup-usage*

Add following settings to your vimrc.
>
  function s:lsp_eslint_format(...)
    if &ft !~ 'typescript'
      return ''
    endif
    let value = a:000[0]
    let position = a:000[1]
    if position == 'upper' " Insert ignore into above current line.
      return printf('// eslint-disable-next-line %s', value)
    endif
    " Insert ignore into same line
    return printf(' // eslint-disable-line %s', value)
  endfunction

  let g:shutup_patterns = {
  \ 'eslint:\(Error\|Warning\):\zs.*\ze:': function('s:lsp_eslint_format'),
  \ }
>
Execute |Shutup| command.
>
  console.log('foo') // eslint-disable-line no-console
>
Execute |ShutupNext| command.
>
  // eslint-disable-next-line no-console
  console.log('foo')
>
You can select multipul lines and execute `:'<,'>Shutup`
>
  console.log('foo') // eslint-disable-line no-console
  console.log('bar') // eslint-disable-line no-console
>

==============================================================================
VARIABLES						*shutup-variables*
  Type: Dict
  Default: {}

  `key` is regex. `value` is function.
  When regex was matched to QuickFix's text, value's function was called.

  function would called with matched text and insert position.
  function should return insert string or empty string.
  If empty string returned, nothing to insert.

==============================================================================
CHANGELOG						*shutup-changelog*
2020-10-24
- First release

vim:tw=78:ts=8:ft=help:norl:noet:fen:fdl=0:
