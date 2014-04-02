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
if [ -f "${CURRENT_DIR}/git-completion.sh" && -f "${CURRENT_DIR}/git-prompt.sh" ]; then
  source "${CURRENT_DIR}/git-completion.sh"
  source "${CURRENT_DIR}/git-prompt.sh"
fi

# Make sure our TAB-completion in BASH is case-insensitive
if [ -f "${CURRENT_DIR}/input.inputrc" ]; then
  INPUTRC="${CURRENT_DIR}/input.inputrc"
fi

# Setup the shell prompt:
# uname (git branch) dirname$ 
PS1="\[${Blue}\]\u\[${BRed}\]\$(__git_ps1) \[${Purple}\]\W\[${Green}\]\$\[${Color_Off}\] "

