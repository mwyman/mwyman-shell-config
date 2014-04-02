# Bash profile, to be included by the real .bash_profile or .profile
#
#

CURRENT_DIR=$(dirname "${BASH_SOURCE[0]}")

# Include our aliases
source "${CURRENT_DIR}/alias.sh"

# Bring in our color definitions
source "${CURRENT_DIR}/colors.sh"

# Setup git TAB-completion and the shell prompt hooks
source "${CURRENT_DIR}/git-completion.sh"
source "${CURRENT_DIR}/git-prompt.sh"

# Make sure our TAB-completion in BASH is case-insensitive
INPUTRC="${CURRENT_DIR}/input.inputrc"

PS1="\[${Blue}\]\u\[${BRed}\]\$(__git_ps1) \[${Purple}\]\W\[${Green}\]\$\[${Color_Off}\] "

