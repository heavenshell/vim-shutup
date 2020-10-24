# vim-shutup

![build](https://github.com/heavenshell/vim-shutup/workflows/build/badge.svg)

Supress warnings.

## Screencasts

![vim-shutup](https://user-images.githubusercontent.com/56591/96607212-187c6f00-1333-11eb-8611-91ebc0ecf906.gif)

[More](https://github.com/heavenshell/vim-shutup/issues/1)

## Usage

Set folliwng settings to your vimrc.

```vim
function s:lsp_eslint_format(...)
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
```

```typescript
console.log('foo' as any)
```

vim-lsp's diagnostics.

```vim
cli.ts|1 col 1| eslint:Error:no-console:Unexpected console statement.
cli.ts|1 col 22| eslint:Warning:@typescript-eslint/no-explicit-any:Unexpected any. Specify a different type.
```

### Insert to same line

Execute `Shutup` command.

```vim
:Shutup
```

Result

```typescript
console.log('foo' as any) // eslint-disable-line no-console,@typescript-eslint/no-explicit-any
```

### Insert above the cursor

Execute `ShutupNext` command.

```vim
:ShutupNext
```

Result

```typescript
// eslint-disable-next-line no-console,@typescript-eslint/no-explicit-any
console.log('foo' as any)
```

### Range

```typescript
console.log('foo')
console.log('bar')
```

Visual select and execute command

```vim
:'<,'>Shutup
```

Result

```typescript
console.log('foo') // eslint-disable-line no-console
console.log('bar') // eslint-disable-line no-console
```

### For ALE

```vim
function s:ale_eslint_format(...)
  if $ft !~ 'typescript'
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
function s:ale_py_format(...)
  if $ft !~ 'python'
    return ''
  endif
  let value = a:000[0]
  return printf('  # noqa: %s', a:000[0])
endfunction

let g:shutup_patterns = {
\ '[eslint].*(\zs.*\ze)': function('s:ale_eslint_format'),
\ '[flake8].*(\zs.*\ze)': function('s:ale_py_format'),
\ }

let g:ale_echo_msg_format = '[%linter%] [%severity%] %s (%code%)'
```

## License

New BSD License
