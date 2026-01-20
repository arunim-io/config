bleopt editor="nvim"

function my/vim-load-hook {
  ble-import vim-surround
}

blehook/eval-after-load keymap_vi my/vim-load-hook
