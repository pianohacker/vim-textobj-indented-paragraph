# vim-indented-paragraph

Provides text objects for a single indented paragraph.

* `ir` - current paragraph, indented same or more than current line
* `ar` - same as above, including surrounding empty lines

## Examples

Given the following code (with the cursor at `|`):

```
if (condition) {
	result = operation();|
	if (!result) return false;

	operation2();
}
```

`dir` will result in:

```
if (condition) {

	operation2();
}
```

and `dar` will result in:

```
if (condition) {
	operation2();
}
```

## Dependencies

- NeoVim or Vim 7.3+
- [vim-textobj-user][vim-textobj-user]

## Installation

First, add the necessary line to your `vimrc`:

- [Vundle][vundle] - `Bundle 'pianohacker/vim-indented-paragraph'`
- [NeoBundle][neobundle] - `NeoBundle 'pianohacker/vim-indented-paragraph'`
- [dein][dein] - `call dein#add('pianohacker/vim-indented-paragraph')`
- [vim-plug][vim-plug] - `Plug 'pianohacker/vim-indented-paragraph'`

Then, add [kana/vim-textobj-user][vim-textobj-user] the same way.

Finally, restart your editor, then install both plugins:

- [Vundle][vundle] - `call :PluginInstall`
- [NeoBundle][neobundle] - `:NeoBundleInstall`
- [Dein][dein] - `:call dein#install()`
- [vim-plug][vim-plug] - `:PlugInstall`

[vundle]: https://github.com/VundleVim/Vundle.vim
[neobundle]: https://github.com/Shougo/neobundle.vim
[neobundle]: https://github.com/Shougo/dein.vim
[vim-plug]: https://github.com/junegunn/vim-plug
[vim-textobj-user]: https://github.com/kana/vim-textobj-user
