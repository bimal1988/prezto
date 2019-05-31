#
# Set up FZF, the command line fuzzy finder.
#
# Authors:
#   Bimal <bimaleal@gmail.com>
#

# Load dependencies.
pmodload 'editor'

# Source module files.
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Set default options
export FZF_DEFAULT_COMMAND="rg --files --hidden --smart-case --follow --glob '!.git/*'"
export FZF_TMUX=1
export FZF_CTRL_T_OPTS="--preview '(bat --style=numbers --color=always {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
export FZF_COMPLETION_TRIGGER=',,'

#
# Key Bindings
#

if [[ -n "$key_info" ]]; then
  # vi
  bindkey -r "$key_info[Control]T"
  bindkey -M viins "$key_info[Control]P" fzf-file-widget
  bindkey -M viins "$key_info[Control]O" fzf-cd-widget
fi
