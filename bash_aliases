# Short versions of various Git commands
# The most important things to note here are:
# * Passing --show-signature to `git log` and `git show` to check commit signatures
# * Passing --autosquash to `git rebase -i` to automatically reorder squash and fixup commits
#   so that they will be merged into the commits they amend
alias s='git status'
alias l='git log --stat --show-signature'
alias c='git commit -a'
alias a='git commit -a --amend'
alias d='git diff'
alias dc='git diff --cached'
alias co='git checkout'
alias b='git branch'
alias show='git show --show-signature'
alias r='git rebase -i --autosquash'
alias rc='git rebase --continue'
alias squash='git commit -a --squash'
alias fixup='git commit -a --fixup'

# Open a tmux session of a specified name, regardless of whether it exists or not
# (usage: `topen session_name`)
alias topen='tmux new-session -A -s'

# Map `python` to `python3` on platforms like Debian which don't do this automatically
which python >/dev/null || alias python=python3
