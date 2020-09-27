# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/efharkin/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git vi-mode)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"
alias fzp="fzf --preview='head -$LINES {}'"

prompt_context() {}

prompt_virtualenv() {
  # Get the name of the virtual environment if one is active
  if [[ -n $VIRTUAL_ENV ]]; then
    local env_label=" $(basename $VIRTUAL_ENV) "
  fi

  # Get the name of the Anaconda environment if one is active
  if [[ -n $CONDA_PREFIX ]]; then
    local conda_env_label="$(echo "\ue288" $(basename $CONDA_PREFIX))"

    if [[ -n $env_label ]]; then
      env_label+="+ $conda_env_label "
    else
      local env_label=" $conda_env_label "
    fi
  fi

  # Draw prompt segment if a virtual/conda environment is active
  if [[ -n $env_label ]]; then
    color=cyan
    prompt_segment $color $PRIMARY_FG
    print -Pn $env_label
  fi
}

prompt_dir() {
    # Get the path from home, root, or git repo to the working directory
    if [ -d .git ]; then
        # If the current directory is the top level of a git repo,
        # just add the name of the repo to the prompt and exit.
        prompt_segment blue $CURRENT_FG
        print -Pn "$(echo '\ue803' $(basename $(pwd)))"
        return 0
    elif $(git rev-parse > /dev/null 2>&1); then
        # If we're in a git repo, get the path from the top of the repo to the
        # working directory.
        local abs_path_=$(pwd)
        local git_toplevel="$(git rev-parse --show-toplevel)"
        local path_=${abs_path_#$git_toplevel}
    else
        # If we aren't in a git repo, get the path from either root or home to
        # the working directory.
        local abs_path_=$(pwd)
        local path_=${abs_path_#$HOME}

        if [[ $abs_path_ != $path_ ]]; then
            local path_="~/$path_"
        else
            local from_root=1
        fi
    fi

    # Shorten the path by truncating each directory (except the current one) to
    # only one letter.
    local path_as_array=(${(s:/:)path_})
    local length_of_path=${#path_as_array[@]}
    local shrunken_path=""
    if [[ $length_of_path != 0 ]]; then
        for i in {1..$length_of_path}; do
            if [[ $i != 1 || $git_toplevel ]]; then
                shrunken_path+="/"
            fi
            if [[ $i != $length_of_path ]]; then
                local elem="$path_as_array[$i]"
                shrunken_path+="${elem[0,1]}"
            else
                local elem="$path_as_array[$i]"
                shrunken_path+="$elem"
            fi
        done
    fi

    if [[ $from_root ]]; then
        local shrunken_path="/"$shrunken_path
    elif [[ $git_toplevel ]]; then
        local shrunken_path=$(echo "\ue803 $(basename $git_toplevel)")$shrunken_path
    fi

    # Draw the prompt
    prompt_segment blue $CURRENT_FG
    print -Pn "$shrunken_path"
}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

