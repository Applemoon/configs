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

  return 0
}

shopt -s cdspell
source ~/.git-prompt.sh

PS1='\e]0;\u@\H\a' # title

PS1="$PS1"'\e[38;5;136m' # dark yellow
PS1="$PS1"'['
PS1="$PS1"'\[\033[93m\]' # yellow
PS1="$PS1"'\w' # path
PS1="$PS1"'\e[38;5;136m' # dark yellow
PS1="$PS1"']'

PS1="$PS1"'\[\033[34m\]' # blue
PS1="$PS1"'$(__git_ps1 " ['
PS1="$PS1"'\[\033[94m\]' # cyan
PS1="$PS1"'%s' # git branch
PS1="$PS1"'\[\033[34m\]' # blue
PS1="$PS1"']")'

PS1="$PS1"'\[\033[0m\] ' # white
PS1="$PS1"'\A'

PS1="$PS1"'\[\033[91m\]' # red
PS1="$PS1"' ➤' # arrow 
PS1="$PS1"'\[\033[0m\] ' # white



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
alias edge='/c/Windows/explorer.exe microsoft-edge:ya.ru'
alias hi='history | tail'
alias weather='curl wttr.in'

function exp { cd $1; explorer .; cd -; }
function cdl { cd $1; pwd; ls; }
function chrome { '/c/Program Files (x86)/Google/Chrome/Application/chrome.exe' $(cygpath -w $1); }
function subl { '/c/Program Files/Sublime Text 3/subl.exe' $(cygpath -w $1); }

cd
