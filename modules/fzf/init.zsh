#
# Set up FZF, the command line fuzzy finder.
#
# Authors:
#   Bimal <bimaleal@gmail.com>
#

# Load dependencies.
pmodload 'editor'

# Add manually installed fzf to path
if [[ -s "$HOME/.fzf/bin/fzf" ]]; then
  path=("$HOME/.fzf/bin" $path)
fi

if (( ! $+commands[fzf] )); then
  return 1
fi

# Source module files.
source "${0:h}/external/shell/key-bindings.zsh"
source "${0:h}/external/shell/completion.zsh"
source "${0:h}/colors.zsh"

# Set default options
# Use fd or ripgrep or ag if available
if (( $+commands[rg] )); then
  export FZF_DEFAULT_COMMAND="fd --type f"
  _fzf_compgen_path() {
    fd --type f "$1"
  }
elif (( $+commands[rg] )); then
  export FZF_DEFAULT_COMMAND="rg --files --smart-case --glob '!.git/*'"
  _fzf_compgen_path() {
    rg --files "$1"
  }
elif (( $+commands[ag] )); then
  export FZF_DEFAULT_COMMAND="ag -g ''"
  _fzf_compgen_path() {
    ag -g '' "$1"
  }
fi

export FZF_TMUX=1
export FZF_HEIGHT=40%
export FZF_TMUX_HEIGHT=40%
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--height ${FZF_HEIGHT} --reverse --inline-info --color ${fzf_colors[Gruvbox]}"

# Show preview on Ctrl-T
export FZF_CTRL_T_OPTS="--preview '(bat --style=numbers --color=always {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"

# Show directory content on ALT-C, if tree command is installed
if (( $+commands[tree] )); then
  export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
fi

# Integration with z
if zstyle -t ':prezto:module:z' loaded; then
  unalias z

  function z() {
    if [[ -z "$*" ]]; then
      cd "$(_z -l 2>&1 | sed 's/^[0-9,.]* *//' | fzf-tmux +s --tac)"
    else
      _last_z_args="$@"
      _z "$@"
    fi
  }

  function zz() {
    cd "$(_z -l 2>&1 | sed 's/^[0-9,.]* *//' | fzf-tmux -q "$_last_z_args")"
  }

  #
  # Aliases
  #
  alias j=z
  alias jj=zz
fi

#
# Key Bindings
#
export FZF_COMPLETION_TRIGGER=',,'

if [[ -n "$key_info" ]]; then
  # vi
  bindkey -r "$key_info[Control]T"
  bindkey -M viins "$key_info[Control]P" fzf-file-widget
  bindkey -M viins "$key_info[Control]O" fzf-cd-widget
fi
