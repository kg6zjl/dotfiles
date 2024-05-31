export PATH="$HOME/.asdf/bin:$HOME/.asdf/shims:${HOME}/bin:${HOME}/go/bin:/opt/homebrew/bin:/opt/homebrew/sbin:${HOME}/Library/Python/3.*/bin:$(/usr/bin/getconf PATH)"
export HISTCONTROL=ignorespace:ignoredupes:erasedups
export DIRENV_LOG_FORMAT=
export BASH_SILENCE_DEPRECATION_WARNING=1
export SHORT_SHELL="$(echo $(basename $SHELL))"

unset KUBECONFIG && export KUBECONFIG=${HOME}/.kube/config

alias gs="git status"
alias ga="git add \$(git status -s | grep '^M\|^??' | awk '{ print $2 }' | pick)"
alias gd="git rm \$(git status -s | grep '^D' | awk '{ print $2 }' | pick)"
alias ll="ls -lah"
alias icd="cd \`ls -d -1 */ | pick\`"
alias ip="curl -s http://checkip.amazonaws.com"
alias tf="terraform"
alias tg="terragrunt"
alias k="kubectl"
alias kgp="kubectl get pods" # kube switch context
alias ksc="switch --show-preview=false" # kube switch context
alias kns="switch namespace" # kube namespace
alias tfinit="rm -rf .terra* && terraform init"
alias tfplan="terraform plan -out tfplan && echo 'or run tfapply'"
alias tfapply='terraform apply "tfplan"'
alias tginit="rm -rf .terragrunt-cache && terragrunt init"
alias tgplan="rm -rf .terragrunt-cache && terragrunt plan"
alias tgapply="rm -rf .terragrunt-cache && terragrunt apply"
alias lg="lazygit"
alias pd="podman"

# set up prompt
eval "$(oh-my-posh --init --shell ${SHORT_SHELL} --config ${HOME}/oh-my-posh.omp.json)"

# setup mcfly for history
eval "$(mcfly init ${SHORT_SHELL})"

# setup home brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# setup direnv
eval "$(direnv hook ${SHORT_SHELL})"

# setup asdf
. /opt/homebrew/opt/asdf/libexec/asdf.sh

# setup switcher
source <(switcher init ${SHORT_SHELL})

function git_master_branch() {
    master_branch=$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)
}

function git_branch() {
    branch="$(git branch 2> /dev/null | sed -e '/^[^*]/d' | tr -d '* ')"
    echo ${branch}
}

function gp() { # git push the current branch and set upstream tracking
    unset branch
    git_master_branch
    branch=$(git_branch)
    if [[ "$branch" != *"$master_branch"* ]]; then
        git push -u origin $branch
    elif [[ "$branch" == *"$master_branch"* ]]; then
        echo "refusing to push to master/main branch. create a branch and try again."
    fi
}

function gm() { # git checkout master and git pull
    git_master_branch # trigger the function to try and determine if master or main
    git checkout $master_branch
    checkoutrc=$?
    branch=$(git_branch)
    if [[ $(echo "$branch" | grep -v 'master\|main') || $checkoutrc != 0 ]]; then
        echo "Failed to checkout ${master_branch}"
    else
        git pull
        if [[ $? != 0 ]]; then
            echo "Failed to pull ${master_branch}"
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

function pr() { #get url of repo to start pr process in a browser
    branch=$(git_branch)
    echo "https://$(git ls-remote --get-url | sed 's|ssh:\/\/||g' | sed 's/git@//g' | sed 's/.git//g' | tr ':' '/')/merge_requests/new?merge_request[source_branch]=$branch"
}

function mkcd() {
    mkdir -p "${1}" && cd "${1}"
}

function mkvenv() {
    if [[ ! -z "$1" ]]; then
        venv_path="${HOME}/venvs/${1}"
        echo "Making new venv here: ${venv_path}"
        python -m venv ${venv_path}
        touch .envrc && echo "\nsource ${venv_path}/bin/activate\n" >> .envrc
    else
        echo "Please pass a venv name"
    fi
}