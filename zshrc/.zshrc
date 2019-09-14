#------------------------------------------------------------------------------
# oh-my-zsh
#------------------------------------------------------------------------------
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.

# oh-my-zsh-powerline-themeのインストール手順
# ref => https://github.com/jeremyFreeAgent/oh-my-zsh-powerline-theme.git
# menlo-powerlineのインストール手順
# ref => https://github.com/abertsch/Menlo-for-Powerline.git
ZSH_THEME="powerline"
POWERLINE_RIGHT_A="mixed"
POWERLINE_HIDE_HOST_NAME="true"
POWERLINE_FULL_CURRENT_PATH="true"
POWERLINE_SHOW_GIT_ON_RIGHT="true"
POWERLINE_DETECT_SSH="true"
export TERM="xterm-256color"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

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
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git ruby gem)

# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/local/bin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

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

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#------------------------------------------------------------------------------
# ディレクトリ操作
#------------------------------------------------------------------------------
# cdしたら自動的にls
function cd () {
  builtin cd $@ && ls -G;
}
# 削除をゴミ箱に変更
# % brew install trash
alias rm="trash"

#------------------------------------------------------------------------------
# 履歴
# ref => https://github.com/peco/peco
#------------------------------------------------------------------------------
alias his="fc -l -f 0 | sort -r | peco"

#------------------------------------------------------------------------------
# システム通知
# ref => http://qiita.com/kei_s/items/96ee6929013f587b5878
#------------------------------------------------------------------------------
#source ~/.zsh.d/zsh-notify/notify.plugin.zsh
#export SYS_NOTIFIER=/usr/local/bin/terminal-notifier
#export NOTIFY_COMMAND_COMPLETE_TIMEOUT=5

#------------------------------------------------------------------------------
# anyenv
# % brew install anyenv
#------------------------------------------------------------------------------
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init - zsh)"
for D in `ls $HOME/.anyenv/envs`
do
  export PATH="$HOME/.anyenv/envs/$D/bin:$PATH"
done

# ------------------------------------------------------------------------
# zsh-completions
# % brew install zsh-completions
# ------------------------------------------------------------------------
if [ -d ${HOME}/.zsh.d/zsh-completions/src ] ; then
   fpath=(${HOME}/.zsh.d/zsh-completions/src $fpath)
   compinit
fi

# ------------------------------------------------------------------------
# python
# ------------------------------------------------------------------------
export PYTHONPATH=$HOME/local/lib/python:$PYTHONPATH

# ------------------------------------------------------------------------
# vim
# ------------------------------------------------------------------------
export EDITOR=vim

