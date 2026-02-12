# shellcheck disable=SC1090,SC1094,SC2155

[[ $- == *i* ]] && source -- "$HOME/.local/share/blesh/ble.sh" --attach=none --rcfile "$HOME/.config/bash/bleshrc.bash"

export BASH_CONF_DIRS="$BASH_CONFIG_DIR/conf.d"

if [ -d "$BASH_CONF_DIRS" ]; then
  for rc in "$BASH_CONF_DIRS"/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi
unset rc

# Exports
export EDITOR="nvim"
export FZF_DEFAULT_OPTS="--layout=reverse --exact --border=bold --border=rounded --margin=3% --color=dark"
export HISTCONTROL=ignoredup:erasedups
export MANPAGER="nvim +Man!"
export PAGER="bat"
export SUDO_EDITOR="$XDG_DATA_HOME/bob/nvim-bin/nvim"
export TERM="xterm-256color"
export VISUAL="nvim -R"

# Vi Mode
set -o vi
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'

# Don't do anything if not in interactive mode
[[ $- != *i* ]] && return

# PATH exports
[ -d "$HOME/.bin" ] && PATH="$HOME/.bin:$PATH"
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/Applications" ] && PATH="$HOME/Applications:$PATH"
[ -d "/var/lib/flatpak/exports/bin/" ] && PATH="/var/lib/flatpak/exports/bin/:$PATH"

# Set the XDG-related env vars if they don't exist
[ -z "$XDG_CACHE_HOME" ] && export XDG_CACHE_HOME="$HOME/.cache"
[ -z "$XDG_CONFIG_HOME" ] && export XDG_CONFIG_HOME="$HOME/.config"
[ -z "$XDG_DATA_HOME" ] && export XDG_DATA_HOME="$HOME/.local/share"

## Options

shopt -s autocd       # change to named directory
shopt -s cdspell      # autocorrects cd misspellings
shopt -s checkwinsize # checks term size when bash regains control
shopt -s cmdhist      # save multi-line commands in history as single line
shopt -s dotglob
shopt -s expand_aliases # expand aliases
shopt -s histappend     # do not overwrite history

bind "set completion-ignore-case on" # ignore upper and lowercase when TAB completion

# Aliases

alias ..="cd .."
alias ...="cd ../.."

alias vi="nvim"
alias vim="nvim"

alias ls="eza -al --color=always --group-directories-first"
alias la="eza -a --color=always --group-directories-first"
alias ll="eza -l --color=always --group-directories-first"
alias lt="eza -aT --color=always --group-directories-first"

alias df="df -h"
alias free="free -m"
alias grep="grep --color auto"

alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem="ps auxf | sort -nr -k 4"
alias pscpu="ps auxf | sort -nr -k 3"

alias jctl="journalctl -p 3 -xb"

alias cat="bat"

# Shell Completions
export BASH_COMPLETION_DIR="$XDG_DATA_HOME/bash-completion/completions"
[ ! -d bash_completion_dir ] && mkdir -p "$BASH_COMPLETION_DIR"

# TODO: Make carapace specs of these cli programs below along with many others
[ ! -f "$BASH_COMPLETION_DIR/bob" ] && bob complete bash >> "$BASH_COMPLETION_DIR/bob"
[ ! -f "$BASH_COMPLETION_DIR/mise" ] && mise completion bash --include-bash-completion-lib >> "$BASH_COMPLETION_DIR/mise"
[ ! -f "$BASH_COMPLETION_DIR/ruff" ] && ruff generate-shell-completion bash >> "$BASH_COMPLETION_DIR/ruff"
[ ! -f "$BASH_COMPLETION_DIR/uv" ] && uv generate-shell-completion bash >> "$BASH_COMPLETION_DIR/uv"
[ ! -f "$BASH_COMPLETION_DIR/uvx" ] && uvx --generate-shell-completion bash >> "$BASH_COMPLETION_DIR/uvx"
[ ! -f "$BASH_COMPLETION_DIR/zig" ] && curl -sLo "$BASH_COMPLETION_DIR/zig" "https://codeberg.org/ziglang/shell-completions/raw/branch/master/_zig.bash"
[ ! -f "$BASH_COMPLETION_DIR/sqlc" ] && sqlc completion bash > "$BASH_COMPLETION_DIR/sqlc"

# Misc.

eval "$(mise activate bash)"

export CARAPACE_BRIDGES="zsh,fish,bash,inshellisense"
source <(carapace _carapace)

export GITHUB_TOKEN="$(gh auth token)"

eval "$(zoxide init bash)"

eval "$(starship init bash)"

setup_blesh() {
  local data_dir="$XDG_DATA_HOME/blesh"

  if [ ! -d "$data_dir" ]; then
    echo "Installing ble.sh"

    local tmp_dir="/tmp/blesh-install"
    [ ! -d "$tmp_dir" ] && mkdir "$tmp_dir"

    git clone --recursive https://github.com/akinomyoga/ble.sh.git "$tmp_dir" > /dev/null
    cd "$tmp_dir" || return
    {
      make
      make INSDIR="$data_dir" install
    } > /dev/null

    echo "Successfully installed ble.sh"
    rm -rf "$tmp_dir"
  fi
}

setup_blesh

[[ ! ${BLE_VERSION-} ]] || ble-attach
