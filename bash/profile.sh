# Bash profile, to be included by the real .bash_profile or .profile
#
#
# Interesting keystrokes to remember:
#   CTRL-A/CTRL-E move cursor to beginning/end of the line
#   CTRL-U/CTRL-K delete from cursor to beginning/end of the line
#
# Use !! to resue last command
# Use !$ to reuse last item in last command (cat TODO.txt; rm !$)
# use !100 to execute the 100th item in the command history
#
# Copy/paste to/from the Mac clipboard with pbcopy/pbpaste

realpath() {
  # Catch this result by using $() or ``.
  python -c 'import os.path, sys; print os.path.abspath(sys.argv[1])' $1
}

# Wrap the setup logic inside a function, enabling us to hide temporary
# variables using 'local'.
github_setup() {
  local CURRENT_OS=$(uname)
  local CURRENT_DIR=$(dirname "${BASH_SOURCE[0]}")

  # Have a global shell variable indicating where this shell is setup.
  export MW_GITHUB_SHELL=$(realpath "${CURRENT_DIR}/..")

  if [ -d "${MW_GITHUB_SHELL}/bin" ]; then
    # Add our github-based scripts/bin dir to the path, appending it so that
    # we don't find ourselves somehow entirely borking our shell by commiting
    # something stupid somewhere.
    export PATH=${PATH}:${MW_GITHUB_SHELL}/bin
  fi

  # Include our aliases
  if [ -f "${CURRENT_DIR}/alias.sh" ]; then
    source "${CURRENT_DIR}/alias.sh"
  fi

  # Bring in our color definitions
  if [ -f "${CURRENT_DIR}/colors.sh" ]; then
    source "${CURRENT_DIR}/colors.sh"
  fi

  # Setup git TAB-completion and the shell prompt hooks
  # Attempt to use Xcode's built-in completion (may be newer)
  if [ -n "$(which xcode-select)" ]; then
    local XCODE_DIR=$(xcode-select --print-path)

    local GIT_COMPLETION_SH="${XCODE_DIR}/usr/share/git-core/git-completion.bash"
    local GIT_PROMPT_SH="${XCODE_DIR}/usr/share/git-core/git-prompt.sh"
  else
    local GIT_COMPLETION_SH="${CURRENT_DIR}/git-completion.sh"
    local GIT_PROMPT_SH="${CURRENT_DIR}/git-prompt.sh"
  fi

  if [ -f "${GIT_COMPLETION_SH}" ]; then
    source "${GIT_COMPLETION_SH}"
  fi

  if [ -f "${GIT_PROMPT_SH}" ]; then
    source "${GIT_PROMPT_SH}"

    # Show unsaged ('*') and staged ('+') file status in the prompt
    export GIT_PS1_SHOWDIRTYSTATE=1

    # Show '$' if the stash is non-empty
    export GIT_PS1_SHOWSTASHSTATE=1

    # Show untracked (%) file status in the prompt
    export GIT_PS1_SHOWUNTRACKEDFILES=1

    # Show the difference between HEAD and its upstream, with
    # a '<' indicating you're behind, '>' indicating you're ahead.
    # A '<>' indicates divergence and '=' indicating no difference.
    #export GIT_PS1_SHOWUPSTREAM="auto"

    # Show color hints
    #export GIT_PS1_SHOWCOLORHINTS=1
  fi

  # Make sure our TAB-completion in BASH is case-insensitive
  if [ -f "${CURRENT_DIR}/input.inputrc" ]; then
    export INPUTRC="${CURRENT_DIR}/input.inputrc"
  fi

  # Exclude file extensions from bash tab-completion (Mac DS_Store and vim undo)
  export FIGNORE=DS_Store:un~

  # Enable colorized command-line output on Mac
  export CLICOLOR=1
  export LSCOLORS=Exfxcxdxbxegedabagacad

  # Add bindings to up/down keys to enable searching history:
  # $ ssh <up> # will search history for ssh calls.
  if [ "${CURRENT_OS}" == "Darwin" ]; then
    bind '"\e[A":history-search-backward'   # up arrow key
    bind '"\e[B":history-search-forward'    # down arrow key
  fi

  # Setup the shell prompt:
  # uname (git branch) dirname$ 
  export PS1="\[${Blue}\]\u\[${BRed}\]\$(__git_ps1) \[${Purple}\]\W\[${Green}\]\$\[${Color_Off}\] "
}

# Perform the actual setup
github_setup

# Cleanup (no reason for the function to linger in the global namespace)
unset -f github_setup

