#---set path locations---#
export GOPATH=${HOME}/go

# full reset of path, and then add customizations
export PATH="$(/usr/bin/getconf PATH):${HOME}/bin:/opt/homebrew/bin:${HOME}/.local/bin:/usr/local/opt/ruby/bin:${GOPATH}/bin:/usr/local/sbin:/usr/local/bin"

#---set default shell location---#
cd $HOME/git/

#-----Set History Control-----#
export HISTCONTROL=ignorespace:ignoredups:erasedupes
echo "Bash history control settings: "$HISTCONTROL

#-----Pip Config-----#
export PIP_REQUIRE_VIRTUALENV=true

#-----Venv/Direnv Config-----#
export VIRTUAL_ENV_DISABLE_PROMPT=1
export DIRENV_LOG_FORMAT=
eval "$(direnv hook bash)"

#-----Add kubectl configs-----#
unset KUBECONFIG && export KUBECONFIG=$HOME/.kube/config
for config in $(grep -irl 'kind: Config' $HOME/.kube | sort | uniq);
do
    export KUBECONFIG=$KUBECONFIG:$config
done

alias rk="kubectl"
alias k="kubectl"
alias tf="terraform"
alias ll="ls -lah"
alias pd="podman"
alias kgp="kubctl get pods"

# use gnu sed on mac
if [[ "$OSTYPE" == *"darwin"* ]]; then
    alias sed=gsed
fi

##########################
#-----Bash Functions-----#
##########################

function notes() { #print list of all .bash_profile functions (via comments - excluding those with "ignore" in comment)
    grep "^function" $HOME/.bash_profile | grep -vi 'ignore' | sed 's/function//g' | sed 's/()//g' | tr -d '{}' | sort
}

function pass() { #generate a unique password of n length, ie: pass 16
    if [[ "$OSTYPE" == *"darwin"* ]]; then
        eval pwgen -Bs $1 1 | tr -d '\n' | pbcopy;
    else
        eval pwgen -Bs $1 1 | tr -d '\n';
    fi
}

function dot() { #jump to dotfile dir
    cd $HOME/git/dotfiles
    git status
    if [ "$1" = "pull" ]; then
        git checkout master
        git pull
    fi
}

function bashp() { #copy in latest dotfiles and source it
    cp $HOME/git/dotfiles/files/bash_profile_customizations.sh $HOME/.bash_profile
    cp $HOME/git/dotfiles/files/aws-config $HOME/.aws/config
    cp $HOME/git/dotfiles/files/vimrc $HOME/.vimrc
    source $HOME/.bash_profile
}

function utc() { #print current time in various regions
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

function ip() { #get my current external ip
    eval curl -s http://checkip.amazonaws.com/
}

function regions() { #fetch regions and display names from aws
    aws --region us-east-1 lightsail get-regions | jq -r '.regions[] | "\(.name) - \(.displayName)"' | sort
}

function kns () { #switch between kube namespaces (kubectl get namespaces to see available)
    kubectl config set-context $(kubectl config current-context) --namespace=$1
}

function kube-namespace () { #automatically switch namespace when default is empty (ignore)
    echo "Checking for pods in default namespace..."
    kubectl get pods 2>&1 | grep 'No resources found.'
    rc=$?
    if [[ $rc == 0 ]]; then
        namespace=$(rk get namespaces | grep -v 'NAME\|cattle-system\|ingress-nginx\|kube-public\|kube-system\|default' | head -n 1 | awk '{ print $1 }')
        echo "Switching to $namespace"
        kubectl config set-context $(kubectl config current-context) --namespace=$namespace
    fi
}

function gp() { # git push the current branch and set upstream tracking
    unset branch
    branch=$(parse_git_branch | tr -d '()')
    if [[ "$branch" != *"master"* ]]; then
        git push -u origin $branch
    elif [[ "$branch" == *"master"* ]]; then
        echo "refusing to push to master branch. create a branch and try again."
    fi
}

function gm() { # git checkout master and git pull
    git checkout master
    checkoutrc=$?
    branch=$(parse_git_branch | tr -d '()')
    if [[ "$branch" != *"master"* || $checkoutrc != 0 ]]; then
        echo "Failed to checkout master"
    else
        git pull
        if [[ $? != 0 ]]; then
            echo "Failed to pull master"
        fi
    fi
}

function gb() { # git checkout master, git pull, git checkout -b branch_name
    gm #call gm function that git checkout master, git pull
    if [[ ! -z "$1" ]]; then
        git checkout -b $1
    else
        echo "You must pass a branch name"
    fi
}

if [[ "$OSTYPE" == *"darwin"* ]]; then
    function code() { #open dir or file in VS Code (osx only), WSL does this natively
        VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $*
    }
fi

function pr() { #get url of repo to start pr process in a browser
    branch=$(parse_git_branch | tr -d '()')
    echo "https://$(git ls-remote --get-url | sed 's|ssh:\/\/||g' | sed 's/git@//g' | sed 's/.git//g' | tr ':' '/')/pull/new/$branch"
}

function ssm() { #aws ssm - usage: ssm role:nginx group:b region:us-east-1
    args=("$@")
    END=`expr $# - 1`
    unset SEARCH OUTPUT REGION

    for i in $(seq 0 $END); do
        key=$(echo ${args[$i]} | cut -d':' -f1 | tr '-' '_')
        value=$(echo ${args[$i]} | cut -d':' -f2)
        if [ "$key" == "region" ]; then
            REGION=" --region ${value} "
        else
            SEARCH=${SEARCH}"\"Name=tag:${key},Values=${value}\" "
        fi
    done

    OUTPUT=$(eval aws ec2 describe-instances ${REGION} --filters ${SEARCH} | jq -r '.Reservations[].Instances[].InstanceId' | head -n1)
    eval aws ${REGION} ssm start-session --target ${OUTPUT}
}

