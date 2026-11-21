# greek.nvim

A neovim plugin that makes typing greek characters easier using the latin alphabet. It uses neovim [nvim_buf_set_extmark](https://neovim.io/doc/user/api/#nvim_buf_set_extmark()) to conceal.

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
  hl_group = "...", -- optional, specifies what highlight group to apply to the extmarks, defaults to 'Exception', which is a red foreground
})
```

The plugin can be invoked in any file other than the ones in files_pattern, by mannually calling `ConcealGreek`. By calling `HideGreek`, you can temporarly hide the ext_marks, until InsertLeave fires.

## Syntax

The syntax is `gr[LETTER_NAME]` where `LETTER_NAME` is the [english name](https://en.wikipedia.org/wiki/Greek_alphabet) of the letter. While editing the line the original text will show. You can also use shorthands (for example: `a` for `alpha`), the letters names and their shorthands can be found in [lua/greek.lua](https://github.com/niki-stefan/greek.nvim/blob/main/lua/greek.lua).

For example, to write "Kirye, eleison" (Lord, have mercy) [but without diacritics for the moment]:

```
gr[K]gr[n]gr[r]gr[i]gr[e], gr[e]gr[l]gr[e]gr[eta]gr[s]gr[o]gr[nu].
```

<img width="251" height="112" alt="screen_2026-11-21_13-15-30" src="https://github.com/user-attachments/assets/4bc74780-ce2c-4076-b7ba-b87ba487536b" />

