[![Mac Build](https://github.com/kg6zjl/dotfiles/actions/workflows/build_mac.yml/badge.svg)](https://github.com/kg6zjl/dotfiles/actions/workflows/build_mac.yml) [![Linux Build](https://github.com/kg6zjl/dotfiles/actions/workflows/build_linux.yml/badge.svg)](https://github.com/kg6zjl/dotfiles/actions/workflows/build_linux.yml)

# dotfiles
Framework for my basic dev env. Trying to make it darwin and linux friendly!

# setup
```
# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# brew install a few deps
brew install direnv go-task

# generate a new ssh-key if you need one
task ssh-key

# kick off the setup
task setup
```

# TODO
- setup Alacritty for cross-platform terminal emulator: https://alacritty.org/
- move file management to GNU Stow: https://www.gnu.org/software/stow/
    - taskfile feels nice for the rest, but file management will be easier with Stow
- swap asdf for pkgx: https://github.com/pkgXdev/pkgx
    - asdf is nice in some ways, but slow and the plugins seem prone to issue
    - i think i'll go the route of pkgx, pyenv, tfswitch, etc with direnv as the trigger for managing versions of things per directory
