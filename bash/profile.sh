# Bash profile, to be included by the real .bash_profile or .profile
#
#

CURRENT_DIR=$(dirname "${BASH_SOURCE[0]}")

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
  XCODE_DIR=$(xcode-select --print-path)

  GIT_COMPLETION_SH="${XCODE_DIR}/usr/share/git-core/git-completion.bash"
  GIT_PROMPT_SH="${XCODE_DIR}/usr/share/git-core/git-prompt.sh"
else
  GIT_COMPLETION_SH="${CURRENT_DIR}/git-completion.sh"
  GIT_PROMPT_SH="${CURRENT_DIR}/git-prompt.sh"
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
  INPUTRC="${CURRENT_DIR}/input.inputrc"
fi

# Enable colorized command-line output on Mac
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad

# Setup the shell prompt:
# uname (git branch) dirname$ 
PS1="\[${Blue}\]\u\[${BRed}\]\$(__git_ps1) \[${Purple}\]\W\[${Green}\]\$\[${Color_Off}\] "

