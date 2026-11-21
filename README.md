# greek.nvim

A neovim plugin that makes typing greek characters easier using the latin alphabet. It uses neovim [nvim_buf_set_extmark](https://neovim.io/doc/user/api/#nvim_buf_set_extmark()) to conceal the latin text with greek unicode letters.

Note: The code was *not* wrriten by chatgpt, BUT I did ask him questions and gave him my code when it didnt work, but this project is not artificial intelligence slop, its natural stupidity slop 🥲

## Installation

For [vim-plug](https://github.com/junegunn/vim-plug):

```lua
Plug("niki-stefan/greek.nvim")
```

For the plugin to work, you have to call the `setup` function:

```lua
require("greek").setup({
  files_pattern = "...", -- optional, tells the plugin in which files to conceal on BufEnter and InsertLeave, defaults to * (any file)
  hl_group = "...", -- optional, specifies what highlight group to apply to the extmarks, defaults to 'Exception', which is a red foreground, execute ':highlight' to see available highlight groups
})
```

The plugin can be invoked in any file other than the ones in [files_pattern](https://neovim.io/doc/user/api/#nvim_create_autocmd()), by mannually calling `ConcealGreek`. By calling `HideGreek`, you can temporarly hide the ext_marks, until InsertLeave fires.

## Syntax

The syntax is `gr[LETTER_NAME(:diacritics)?]` where `LETTER_NAME` is the [english name](https://en.wikipedia.org/wiki/Greek_alphabet) of the letter, and `diacritics` are the diacritics to apply to the letter, see below. While editing the line, the original text will show. You can also use shorthands (for example: `a` for `alpha`), the letters names and their shorthands can be found in [lua/greek.lua](https://github.com/niki-stefan/greek.nvim/blob/main/lua/greek.lua).

For example, to write "Kirye, eleison" (Lord, have mercy):

```
gr[K]gr[n:']gr[r]gr[i]gr[e], gr[e:,]gr[l]gr[e:']gr[eta]gr[s]gr[o]gr[nu].
```

## Diacritics

Supported diacritics are [grave](https://en.wikipedia.org/wiki/Grave_accent) (\`), [acute](https://en.wikipedia.org/wiki/Acute_accent) ('), [macron](https://en.wikipedia.org/wiki/Macron_(diacritic)) (-), [diaeresis](https://en.wikipedia.org/wiki/Diaeresis_(diacritic)) (.), [smooth breathing](https://en.wikipedia.org/wiki/Smooth_breathing) (,), [rough breathing](https://en.wikipedia.org/wiki/Rough_breathing) (;), [circumflex](https://en.wikipedia.org/wiki/Circumflex) (~), [subscript](https://en.wikipedia.org/wiki/Iota_subscript) (\_).

They *must* be preceeded by a semicolon. To combine multiple diacritics simply write them one after another: `gr[eta:,_]`.
