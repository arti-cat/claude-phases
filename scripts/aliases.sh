#!/bin/bash
# ADHD-Friendly Development Aliases
# Source this file to get helpful shortcuts: source scripts/aliases.sh

# Navigation aliases
alias cpmain='cd ~/dev/00_RELEASE/claude-phases'
alias cpdev='cd ~/dev/00_RELEASE/claude-phases-develop'
alias cpexp='cd ~/dev/00_RELEASE/claude-phases-experimental'
alias cptest='cd ~/dev/00_RELEASE/test-integration'

# Quick status checks
alias cpstatus='echo "🌿 Branch: $(git branch --show-current)" && echo "📍 Location: $(pwd)" && echo "📊 Status:" && git status --short'
alias cptree='git worktree list'
alias cplog='git log --oneline --graph --all -10'

# Development shortcuts
alias cpclean='git worktree prune && git branch -d $(git branch | grep -E "(feature|experimental|hotfix)/" | tr -d " ")'
alias cpbackup='git stash push -m "ADHD backup $(date)" && echo "💾 Work backed up to stash"'

# Quick setup
alias cpsetup='~/dev/00_RELEASE/claude-phases/scripts/dev-setup.sh'

echo "🧠 ADHD-Friendly aliases loaded!"
echo "Try: cpstatus, cptree, cpdev, cpexp, cptest"