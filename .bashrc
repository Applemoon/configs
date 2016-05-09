[[ "$-" != *i* ]] && return


function cd
{
  local x2 the_new_dir adir index
  local -i cnt

  if [[ $1 ==  "--" ]]; then
    dirs -v
    return 0
  fi

  the_new_dir=$1
  [[ -z $1 ]] && the_new_dir=$HOME

  if [[ ${the_new_dir:0:1} == '-' ]]; then
    #
    # Extract dir N from dirs
    index=${the_new_dir:1}
    [[ -z $index ]] && index=1
    adir=$(dirs +$index)
    [[ -z $adir ]] && return 1
    the_new_dir=$adir
  fi
 
  #
  # '~' has to be substituted by ${HOME}
  [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"

  #
  # Now change to the new dir and add to the top of the stack
  pushd "${the_new_dir}" > /dev/null
  [[ $? -ne 0 ]] && return 1
  the_new_dir=$(pwd)

  #
  # Trim down everything beyond 11th entry
  popd -n +11 2>/dev/null 1>/dev/null

  #
  # Remove any other occurence of this dir, skipping the top of the stack
  for ((cnt=1; cnt <= 10; cnt++)); do
    x2=$(dirs +${cnt} 2>/dev/null)
    [[ $? -ne 0 ]] && return 0
    [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
    if [[ "${x2}" == "${the_new_dir}" ]]; then
      popd -n +$cnt 2>/dev/null 1>/dev/null
      cnt=cnt-1
    fi
  done

  settitle
  return 0
}

shopt -s cdspell
source ~/.git-prompt.sh

PPP='\n'

PPP="$PPP"'\[\033[93m\]' # yellow
PPP="$PPP"'[\w]' # path

PPP="$PPP"'\[\033[94m\]' # cyan
PPP="$PPP"'$(__git_ps1 " [%s]")' # git branch

PPP="$PPP"'\[\033[0m\] ' # white
PPP="$PPP"'\A'

PPP="$PPP"'\[\033[91m\]' # red
PPP="$PPP"' ➤' # arrow 
PPP="$PPP"'\[\033[0m\] ' # white

PS1="$PPP"

alias df='df -h'
alias whence='type -a'                        # where, of a sort
alias grep='grep --color'                     # show differences in colour
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour
alias ls='ls -hF --color=tty'                 # classify files in colour
alias l='ls -lA'                              # long list
alias la='ls -A'                              # all but . and ..
alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias go='git checkout '
alias gk='gitk --all&'
alias gx='gitx --all'
alias up='cd ..'
alias up2='cd ../..'
alias up3='cd ../../..'
alias hi='history | tail'
alias weather='curl wttr.in'
alias cal='cal -m'
alias cs='cygstart'

alias д='l'
alias ды='ls'
alias св='cd'
alias ьлвшк='mkdir'
alias учз='exp'
alias свд='cdl'
alias гз='up'
alias гз2='up2'
alias гз3='up3'
alias руфв='head'
alias ефшд='tail'
alias сфе='cat'
alias рш='hi'
alias пше='git'
alias пс='gc'
alias пщ='go'
alias пв='gd'
alias мш='vi'
alias мшь='vim'
alias сз='cp'
alias ьм='mv'
alias кь='rm'
alias учше='exit'

function exp { 
  if [ $# -eq 0 ]
    then
      explorer .; 
    else
      explorer $(cygpath -w $1); 
  fi
}
function cdl { cd $1; pwd; ls; }
function subl { 
  if [ $# -eq 0 ]
    then
      '/c/Program Files/Sublime Text 3/subl.exe';
    else
      '/c/Program Files/Sublime Text 3/subl.exe' $(cygpath -w $1);
  fi
}
function settitle () 
{ 
  if [ $# -eq 0 ]
    then
      PS1="$PPP"'\e]0;$PWD\a'
    else
      PS1="$PPP\e]0;$1\a"
  fi
}
function mkcd { mkdir $1; cd $1; }
function mamaot {
  if [ $# -eq 0 ]
    then
      DIRNAME="otchet"
    else
      DIRNAME=$1
  fi
  
  mkdir $DIRNAME
  for filename in `gs --porcelain | cut -d' ' -f3`
  do
    cp --parents "$filename" $DIRNAME
  done
  zip -r otchet.zip $DIRNAME
  rm -r $DIRNAME
}

settitle

cd

