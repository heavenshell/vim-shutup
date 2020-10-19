# vim-shutup

Supress warnings.

## Usage

Set settings to your vimrc.

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

Execute `Shutup` command.

```vim
:Shutup
```

Result

```typescript
console.log('foo' as any) // eslint-disable-line no-console,@typescript-eslint/no-explicit-any
```

Execute `ShutupNext` command.

```vim
:ShutupNext
```

Result

```typescript
// eslint-disable-next-line no-console,@typescript-eslint/no-explicit-any
console.log('foo' as any)
```

## Screencasts

![vim-shutup](./assets/vim-shutup.gif)

## License

New BSD License
