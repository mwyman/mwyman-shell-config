# Zsh profile, to be included by the real .zshrc.
#
#
#

realpath() {
  # Catch this result by using $() or ``.
  python -c 'import os.path, sys; print os.path.abspath(sys.argv[1])' $1
}

_git_root_directory() {
  echo "$(git rev-parse --show-toplevel 2>/dev/null)"
}

_hg_root_directory() {
  echo "$(hg root 2>/dev/null)"
}

cdroot() {
  local GIT_ROOT="$(_git_root_directory)"
  if [ -n "${GIT_ROOT}" ]; then
    cd "${GIT_ROOT}"
    return 0
  fi

  local HG_ROOT="$(_hg_root_directory)"
  if [ -n "${HG_ROOT}" ]; then
    cd "${HG_ROOT}"
    return 0
  fi

  return 1
}

_cd_git_project() {
  if [ -n "$1" ]; then
    local PROJECT_SUBDIR=$(git config --file "$1/.git/config" --get mjw.project-root 2>/dev/null)
    if [ -n "${PROJECT_SUBDIR}" ]; then
      cd "$1/${PROJECT_SUBDIR}"
      return 0
    fi
  fi
  return 1
}

_cd_hg_project() {
  if [ -n "$1" ]; then
    local PROJECT_SUBDIR=$(hg config --repository "$1" mjw.project-root 2>/dev/null)
    if [ -n "${PROJECT_SUBDIR}" ]; then
      cd "$1/${PROJECT_SUBDIR}"
      return 0
    fi
  fi
  return 1
}

# Function/command to change to the current git/mercurial repo "project" directory.
cdproj() {
  local GIT_ROOT=$(_git_root_directory)
  if [ -n "${GIT_ROOT}" ]; then
    _cd_git_project "${GIT_ROOT}"
    if [ $? -eq 0 ]; then
      return 0
    else
      echo "No \"mjw.project-root\" defined in Git repository: ${GIT_ROOT}"
      echo "To set, run:"
      echo "\tgit config --add mjw.project-root <path>"
      return 1
    fi
  fi

  local HG_ROOT=$(_hg_root_directory)
  if [ -n "${HG_ROOT}" ]; then
    _cd_hg_project "${HG_ROOT}"
    if [ $? -eq 0 ]; then
      return 0
    else
      echo "No \"mjw.project-root\" defined in Mercurial repository: ${HG_ROOT}"
      echo "To set, run \"hg config --local --edit\" and add:"
      echo "\t[mjw]"
      echo "\tproject-root = <path>"
      return 1
    fi
  fi

  _cd_git_project "$(git config --global mjw.default-repo-root)"
  if [ $? -eq 0 ]; then return 0; fi

  _cd_hg_project "$(hg config mjw.default-repo-root)"
  if [ $? -eq 0 ]; then return 0; fi

  echo "Error: no \"mjw.default-repo-root\" defined in global Git or Mercurial configs"
  return 1
}

alias compile_arm64='xcrun --sdk iphoneos clang -arch arm64'
alias compile_armv7='xcrun --sdk iphoneos clang -arch armv7'
alias compile_x64='xcrun --sdk iphonesimulator clang -arch x86_64'
alias compile_swift_arm64='swiftc -sdk $(xcrun --sdk iphoneos --show-sdk-path) -target arm64-apple-ios$(xcrun --sdk iphoneos --show-sdk-platform-version)'
alias compile_swift_armv7='swiftc -sdk $(xcrun --sdk iphoneos --show-sdk-path) -target armv7-apple-ios$(xcrun --sdk iphoneos --show-sdk-platform-version)'
alias compile_swift_x64='swiftc -sdk $(xcrun --sdk iphonesimulator --show-sdk-path) -target x86_64-apple-ios$(xcrun --sdk iphonesimulator --show-sdk-platform-version)'


###############################################################################
# Oh-my-zsh stuff
###############################################################################

# Theme to load
ZSH_THEME="agnoster"
DEFAULT_USER="mwyman"
DISABLE_AUTO_UPDATE="true"
plugins=(git mercurial osx)

github_setup() {
  local CURRENT_OS=$(uname)
  local CURRENT_DIR=$(dirname "${(%):-%x}")

  # Have a global shell variable indicating where this shell is setup.
  export MW_GITHUB_SHELL=$(realpath "${CURRENT_DIR}/..")

  if [ -d "${HOME}/bin" ]; then
    # Add ~/bin to the path.
    export PATH=${PATH}:${HOME}/bin
  fi

  if [ -d "${HOME}/.homebrew" ]; then
    # Add the user-local homebrew directory to the path.
    export PATH=${PATH}:${HOME}/.homebrew/bin
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${HOME}/.homebrew/lib
  fi

  if [ -d "${MW_GITHUB_SHELL}/bin" ]; then
    # Add our github-based scripts/bin dir to the path, appending it so that
    # we don't find ourselves somehow entirely borking our shell by committing
    # something stupid somewhere.
    export PATH=${PATH}:${MW_GITHUB_SHELL}/bin
  fi

  # Include our aliases.
  if [ -f "${CURRENT_DIR}/aliases.zsh" ]; then
    source "${CURRENT_DIR}/aliases.zsh"
  fi

  # Check for oh-my-zsh installation.
  if [ -n "${OH_MY_ZSH_PATH}" ]; then
    export ZSH="${OH_MY_ZSH_PATH}"
  elif [ -f "${CURRENT_DIR}/oh-my-zsh/oh-my-zsh.sh" ]; then
    export ZSH="${CURRENT_DIR}/oh-my-zsh"
  fi

  source "${ZSH}/oh-my-zsh.sh"

  # Set up fuzzy history search
  # start typing + [Up-Arrow] - fuzzy find history forward
  if [[ "${terminfo[kcuu1]}" != "" ]]; then
    autoload -U up-line-or-beginning-search
    zle -N up-line-or-beginning-search
    bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
  fi

  # start typing + [Down-Arrow] - fuzzy find history backward
  if [[ "${terminfo[kcud1]}" != "" ]]; then
    autoload -U down-line-or-beginning-search
    zle -N down-line-or-beginning-search
    bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
  fi
}

# Perform the actual setup.
github_setup

# Cleanup (no reason for the function to linger in the global namespace).
unset -f github_setup

## Fix up some agnoster themes for light viewing:
prompt_context() {
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment default default "%(!.%{%F{yellow}%}.)$USER@%m"
  fi
}

prompt_dir() {
  prompt_segment cyan black '%~'
}

prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    prompt_segment cyan black "(`basename $virtualenv_path`)"
  fi
}
