# vim-indented-paragraph

Provides text objects and movements for indented paragraphs.

Text objects:

* `ir` - current paragraph, indented same or more than current line
* `ar` - same as above, including surrounding empty lines

Movements:

* `g)` - move to the next beginning of an indented paragraph
* `g(` - move to the previous beginning of an indented paragraph

## Examples

### Text Objects

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

Note that `dar` in a block with empty lines on both sides will leave empty
lines behind; given:

```
if (a) {
    b();

    c();|

    d();
}
```

`dar` will result in:

```
if (a) {
    b();

    d();
}
```

### Movement

Given the following code (with the cursor at `|`):

```
if (condition) {
    result = operation();
    if (!result) return false;|

    operation2();
}
```

`g)` will move to:

```
if (condition) {
    result = operation();
    if (!result) return false;

    |operation2();
}
```

and `g(` will move to:

```
if (condition) {
    |result = operation();
    if (!result) return false;

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

- [Vundle][vundle] - `:PluginInstall`
- [NeoBundle][neobundle] - `:NeoBundleInstall`
- [Dein][dein] - `:call dein#install()`
- [vim-plug][vim-plug] - `:PlugInstall`

[vundle]: https://github.com/VundleVim/Vundle.vim
[neobundle]: https://github.com/Shougo/neobundle.vim
[dein]: https://github.com/Shougo/dein.vim
[vim-plug]: https://github.com/junegunn/vim-plug
[vim-textobj-user]: https://github.com/kana/vim-textobj-user
