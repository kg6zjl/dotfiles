export PATH="${HOME}/bin:${HOME}/go/bin:${HOME}/Library/Python/3.*/bin:$HOME/.asdf/bin:$HOME/.asdf/shims:${PATH}:$(/usr/bin/getconf PATH)"
export HISTCONTROL=ignorespace:ignoredupes:erasedups

alias ll="ls -lah"
alias icd="cd \`ls -d -1 */ | pick\`"
alias mkcd="mkdir -p $1 && cd $1"
alias gs="git status"


eval "$(source /opt/homebrew/opt/asdf/libexec/asdf.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(direnv hook zsh)"

eval "$(oh-my-posh --init --shell zsh --config ${HOME}/oh-my-posh.omp.json)"