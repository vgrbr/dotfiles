export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

export PATH=$PATH:$HOME/.jenv/bin:/$HOME/.rvm/gems/ruby-1.9.3-p385/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/share/npm/bin:$HOME/.rvm/bin
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_60.jdk/Contents/Home
export CLICOLOR=1
export LC_ALL=en_US.UTF-8
export rvm_path=$HOME/.rvm

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
source $(brew --prefix)/etc/bash_completion.d/git-prompt.sh
source ~/.bash_git
source ~/.hbase
source ~/.aliases
export LSCOLORS=ExFxCxDxBxegedabagacad
code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
