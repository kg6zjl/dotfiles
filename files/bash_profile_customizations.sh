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
export -f current_cluster

export PS1="\[\033[33m\]\$(show_virtual_env)\[\033[00m\]\u@\h: \[\033[32m\]\w \[\033[33m\]\$(parse_git_branch)\[\033[33m\]\$(current_cluster)\[\033[00m\]\n$ "

#---set default shell location---#
cd $HOME/git/

#---set path locations---#
export GOPATH=$HOME/go
export PATH=$PATH:$HOME/.local/bin:$HOME/bin:$GOPATH/bin

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
if [[ "$OSTYPE" == *"darwin"* ]]; then
    alias sed=gsed
fi

##########################
#-----Bash Functions-----#
##########################

function notes() { #print list of all .bash_profile functions (via comments - excluding those with "ignore" in comment)
    grep "^function" $HOME/.bash_profile | grep -vi 'ignore' | sed 's/function//g' | sed 's/()//g' | tr -d '{}' | sort
}

function yaynay() {
    curl -s https://yesno.wtf/api | jq -r '.answer'
}

function ssh-setup() { #setup default ssh key (ignore)
    if ssh-add -l | grep -q "$1"; then
        echo "ssh key $1 is ready"
    else
        eval $(ssh-agent -s)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            ssh-add -K $HOME/.ssh/$1
        else
            ssh-add $HOME/.ssh/$1
        fi
    fi
}

ssh-setup id_rsa

function awsenv() { #choose aws creds to push to env vars (example: awsenv tenable or awsenv reset)
    unset AWS_DEFAULT_PROFILE AWS_PROFILE AWS_SESSION_TOKEN AWS_SECRET_ACCESS_KEY AWS_ACCESS_KEY_ID AWS_SECURITY_TOKEN
    eval $(python3 $HOME/git/dotfiles/files/python-ini.py $HOME/.aws/credentials $1)
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
    #cp $HOME/git/dotfiles/files/ssh-config $HOME/.ssh/config
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

function rancher-config-url() { #get kube config and set rancher context - uses api (automatically called - ignore)
    mkdir -p $HOME/.kube/
    mkdir -p $HOME/.kubeconfigs
    CLUSTER_DATA=$(/usr/bin/curl -XGET -s -L "$RANCHER_URL/clusters?limit=-1&sort=name&name=$1" -H "cookie: R_SESS=$TOKEN")
    CONFIG_URL=$(echo $CLUSTER_DATA | jq -r '.data[].actions.generateKubeconfig')
    CLUSTER_ID=$(echo $CLUSTER_DATA | jq -r '.data[].id')
    
    echo "Setting up kubectl config for $1"
    /usr/bin/curl -XPOST -s -L $CONFIG_URL -H "cookie: R_SESS=$TOKEN" | jq -r '.config' | tee $HOME/.kubeconfigs/$1.config > $HOME/.kube/config
    
    echo "Setting up ranchercli for $1"
    PROJECT_ID=$(/usr/bin/curl -XGET -s -L "$RANCHER_URL/cluster/$CLUSTER_ID/namespaces?name=default" -H "cookie: R_SESS=$TOKEN" | jq -r '.data[].projectId' | awk '{ print $1 }')
    rancher login --context $PROJECT_ID -t "$TOKEN" $RANCHER_URL
}

function rancher-kube-config () { #get kube config for current rancher cluster - uses ranchercli (automatically called - ignore)
    cluster=$(rancher cluster | grep '^*' | awk '{ print $4 }')
    mkdir -p $HOME/.kube/
    mkdir -p $HOME/.kubeconfigs
    rancher clusters kf $cluster | tee $HOME/.kubeconfigs/$cluster.config > $HOME/.kube/config
    #cleanup to prevent cache errors
    rm -rf $HOME/.kube/http-cache/*
}

function rancher-prod () { #setup rancher for prod
    export RANCHER_URL=www.url.com
    export R_PROFILE="prod"
    TOKEN=$(credstash -p $R_PROFILE -r us-east-1 get rancher-cli-token)
    if [ -n "$1" ]; then
        rancher-config-url $1
    else
        rancher login -t "$TOKEN" $RANCHER_URL
        rancher-kube-config
    fi
    kube-namespace
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

function rgrep() { # recursive grep. example: `rg text`
    grep -irn $1 .
}

function kvpn() { #run telepresence on current context cluster
    echo "connecting to cluster, this takes a while..."
    telepresence --docker-run --rm -i -t path.to.repo.com/sre-ubuntu /bin/bash
}

function open() { #open a file using the default/associated app in windows
    #borrowed from https://superuser.com/a/1429272
    if [[ $WSL_DISTRO_NAME == *"Ubuntu"* ]]; then
        # get full unsymlinked filename
        file=$(readlink -e $1)
        dir=$(dirname "$file")
        base=$(basename "$file")
        # open item using default windows application
        (cd "$dir"; explorer.exe "$base")
    else
        open $1
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

function lint() { #run python linters and security checks against a python file
    dir=$(pwd)

    cd $HOME/venvs/black
    autopep8 -i $1
    bandit -ll -ii $1
    black $1
    pylint $1

    cd $dir
    safety check --bare $1
}

