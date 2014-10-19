mwyman-shell-config
===================

I've needed to recreate my bash shell profile more often than I care to, and
decided that I should really setup a Github repo that would contain my shell
setup.

# Setup

## Bash

Add the following lines to your `.bashrc`, `.bash_profile`, or `.profile` file (depending on your system):

```
GITHUB_CONFIG=<_path to repo_>
if [ -e "${GITHUB_CONFIG}/bash/profile.sh" ]; then
  source "${GITHUB_CONFIG}/bash/profile.sh"
fi
```

## Vim

Add the following lines to your `~/.vimrc` file:

```
so ${GITHUB_CONFIG}/vim/vimrc.vim
```

## Git

Add the following lines to your `~/.gitconfig` file (please note that it does not seem that Git yet supports `${HOME}` or other environment variables in the config).

```
[include]
  path = <_path to repo_>/git/config.gitconfig

[core]
  excludesfile = <_path to repo_>/git/config.gitignore
```
