if ! [[ $PATH =~ $HOME/.local/bin:$HOME/bin: ]]; then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

eval "$(mise activate bash)"

if command -v gh > /dev/null 2>&1; then
  GITHUB_TOKEN="$(gh auth token)"
  export GITHUB_TOKEN
fi

eval "$(zoxide init bash)"
