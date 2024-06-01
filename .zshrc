HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
bindkey -v

case $OSTYPE in
darwin*)
    # Mac OS X
    zstyle :compinstall filename '/Users/eric/.zshrc'

    # Brew Coompletions
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    ;;
linux*)
    # Linux
    zstyle :compinstall filename '/home/eric/.zshrc'
    ;;
esac

autoload -Uz compinit
compinit

# Prompt
PROMPT='%B%~ $%b '

# Aliases
alias ls="ls --color"
alias ll="ls --color -la"
alias c="clear"
alias venv="virtualenv .venv"
alias activate="source .venv/bin/activate"

case $OSTYPE in
darwin*)
    # Mac OS X

    # Aliases
    alias update="brew update && brew upgrade && brew autoremove && brew cleanup"

    # Load Plugins
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /opt/homebrew/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
    ;;
linux*)
    # Linux

    # Conda
    [ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh	

    # Aliases
    alias open="xdg-open"

    # Load Plugins
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    ;;
esac
