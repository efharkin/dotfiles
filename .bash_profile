# Customize prompt.
export PS1="\W $ "

# Alias commands.
alias ls="ls -G"
alias tree="tree -C"

. ~/.git-completion.bash

# Function for finding git merge conflicts
gitcheckmerge () {
    if [ $# != 2 ]; then
        echo "usage: gitcheckmerge branch1 branch2"
        return 1
    fi
    git merge-tree $(git merge-base "$1" "$2") "$1" "$2" | grep "changed in both" -A 3
    return 0
}

# Commands for versioning config files.
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"


#%% SETUP FOR SPECIFIC PROGRAMS

# TexLive
if [ -d /usr/local/texlive/2019 ]; then
	export PATH="$PATH:/usr/local/texlive/2019/bin/x86_64-darwin"
	#export MANPATH="$MANPATH:/usr/local/texlive/2019/texmf-dist/doc/man"
	#export INFOPATH="$INFOPATH:/usr/local/texlive/2019/texmf-dist/doc/info"
fi

# added by Miniconda3 4.6.14 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(CONDA_REPORT_ERRORS=false '/miniconda3/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    \eval "$__conda_setup"
else
    if [ -f "/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/miniconda3/etc/profile.d/conda.sh"
        CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda init <<<

export PATH="$HOME/.cargo/bin:$PATH"
