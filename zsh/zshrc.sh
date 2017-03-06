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
  _cd_git_project "$(_git_root_directory)"
  if [ $? -eq 0 ]; then return 0; fi

  _cd_hg_project "$(_hg_root_directory)"
  if [ $? -eq 0 ]; then return 0; fi

  _cd_git_project "$(git config --global mjw.default-repo-root)"
  if [ $? -eq 0 ]; then return 0; fi

  _cd_hg_project "$(hg config --global mjw.default-repo-root)"
  if [ $? -eq 0 ]; then return 0; fi

  return 1
}

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
  echo "${CURRENT_DIR}"
  if [ -n "${OH_MY_ZSH_PATH}" ]; then
    export ZSH="${OH_MY_ZSH_PATH}"
  elif [ -f "${CURRENT_DIR}/oh-my-zsh/oh-my-zsh.sh" ]; then
    export ZSH="${CURRENT_DIR}/oh-my-zsh"
  fi

  source "${ZSH}/oh-my-zsh.sh"
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
