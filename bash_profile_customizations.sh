#-----Functions for Prompt-----#

#git branch function for prompt (ignore)
parse_git_branch() {
     echo "($(git branch 2> /dev/null | sed -e '/^[^*]/d' | tr -d '* ')) "
}

show_virtual_env() { #venv function for prompt (ignore)
  if [ -n "$VIRTUAL_ENV" ]; then
    echo "($(basename $VIRTUAL_ENV)) "
  fi
}

current_cluster() { #rancher cluster function for prompt (ignore)
  echo "($(kubectl config view -o template --template='{{ index . "current-context" }}' 2> /dev/null)) "
}

export -f show_virtual_env
export -f parse_git_branch
export -f current_rancher_cluster

export PS1="\[\033[33m\]\$(show_virtual_env)\[\033[00m\]\u@\h: \[\033[32m\]\w \[\033[33m\]\$(parse_git_branch)\[\033[33m\]\$(current_cluster)\[\033[00m\]\n$ "

#-----Set History Control-----#
export HISTCONTROL=ignorespace:ignoredups:erasedupes
echo "Bash history control settings: "$HISTCONTROL

#-----Pip Config-----#
export PIP_REQUIRE_VIRTUALENV=true

#-----Venv Config-----#
export VIRTUAL_ENV_DISABLE_PROMPT=1

#-----Add kubectl configs-----#
unset KUBECONFIG && export KUBECONFIG=$HOME/.kube/config
for config in $(grep -irl 'kind: Config' $HOME/.kube | sort | uniq);
do
    export KUBECONFIG=$KUBECONFIG:$config
done

##########################
#-----Bash Functions-----#
##########################

function notes () { #print list of all .bash_profile functions
    grep "^function" $HOME/.bash_profile | grep -vi 'ignore' | sed 's/function//g' | sed 's/()//g' | tr -d '{}' | sort
}

function pass() { #generate a unique password of n length, ie: pass 16
    if [[ "$OSTYPE" == *"darwin"* ]]; then
        eval pwgen -Bs $1 1 | tr -d '\n' | pbcopy;
    else
        eval pwgen -Bs $1 1 | tr -d '\n';
    fi
}

function code () { #open dir or file in VS Code
    VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $*
}

function dot () { #jump to dotfile dir
    cd $HOME/git/dotfiles
}

function bashp () { #copy in latest dotfiles and source it
    cp $HOME/git/dotfiles/files/bash_profile_customizations.sh $HOME/.bash_profile
    cp $HOME/git/dotfiles/files/aws-config $HOME/.aws/config
    cp $HOME/git/dotfiles/files/vimrc $HOME/.vimrc
    #cp $HOME/git/dotfiles/files/ssh-config $HOME/.ssh/config
    source $HOME/.bash_profile
}

function utc () { #print current time in various regions
    echo
    echo "Local: $(date) ($(date +'%I:%M %p'))"
    echo "UTC:   $(date -u) ($(date -u +'%I:%M %p'))"
    echo "------------"
    echo "EST:   $(TZ=America/New_York date) ($(TZ=America/New_York date +'%I:%M %p'))"
    echo "PST:   $(TZ=America/Los_Angeles date) ($(TZ=America/Los_Angeles date +'%I:%M %p'))"
    echo "UTC:   $(date -u) ($(date -u +'%I:%M %p'))"
    echo "LON:   $(TZ=Europe/London date) ($(TZ=Europe/London date +'%I:%M %p'))"
    echo "FRA:   $(TZ=Europe/Berlin date) ($(TZ=Europe/Berlin date +'%I:%M %p'))"
    echo "SING:  $(TZ=Singapore date) ($(TZ=Singapore date +'%I:%M %p'))"
    echo "SYD:   $(TZ=Australia/Sydney date) ($(TZ=Australia/Sydney date +'%I:%M %p'))"
    echo
}

function ip () { #get my current external ip
    eval curl -s http://checkip.amazonaws.com/
}
