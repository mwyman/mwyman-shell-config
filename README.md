mwyman-shell-config
===================

I've needed to recreate my bash shell profile more often than I care to, and
decided that I should really setup a Github repo that would contain my shell
setup.

# Automated Setup

To configure your shell, it is recommended to use the following script (change "mwyman-shell-config" to be whatever path you might have cloned into):

```bash
$> mwyman-shell-config/setup.py
```

# Manual Setup

To configure your shell to use the Github configuration, add the following lines to the various configuration files.

Please keep the "Begin"/"End" comments in the files, as there may be an automated setup script coming that will honor these to ensure it doesn't double-configure.

## Bash

Add the following lines to your `.bashrc`, `.bash_profile`, or `.profile` file (depending on your system):

```bash
# Begin Github shell config
# Setup my preferred bash settings (based on my github branch).
export GITHUB_SHELL_CONFIG=${HOME}/mwyman-shell-config
if [ -e "${GITHUB_SHELL_CONFIG}/bash/profile.sh" ]; then
  source "${GITHUB_SHELL_CONFIG}/bash/profile.sh"
fi
# End Github shell config
```

## Vim

Add the following lines to your `~/.vimrc` file:

```vim
" Begin Github vim config
so ${GITHUB_SHELL_CONFIG}/vim/vimrc.vim
" End Github vim config
```

## Git

Add the following lines to your `~/.gitconfig` file (please note that it does not seem that Git yet supports `${HOME}` or other environment variables in the config).

```ini
# Begin Github git config
[include]
  path = <_path to repo_>/git/config.gitconfig
[core]
  excludesfile = <_path to repo_>/git/config.gitignore
# End Github git config
```
