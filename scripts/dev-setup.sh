#!/bin/bash
# ADHD-Friendly Development Setup Script
# Run this to quickly set up or restore your development environment

set -e

echo "🧠 Claude Phases - Development Setup"
echo "=================================="

# Check if we're in the right directory
if [[ ! -f "CLAUDE.md" ]] || [[ ! -d ".claude" ]]; then
    echo "❌ Please run this from the claude-phases directory"
    exit 1
fi

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}📋 Current Status:${NC}"
echo "Working directory: $(pwd)"
echo "Current branch: $(git branch --show-current)"
echo

echo -e "${BLUE}🌿 Branches:${NC}"
git branch -a

echo
echo -e "${BLUE}🌳 Worktrees:${NC}"
git worktree list

echo
echo -e "${YELLOW}💡 Quick Navigation:${NC}"
echo "Main template:     cd $(pwd)"
echo "Develop branch:    cd $(pwd)/../claude-phases-develop"
echo "Experimental:      cd $(pwd)/../claude-phases-experimental"
echo "Test integration:  cd $(pwd)/../test-integration"

echo
echo -e "${YELLOW}🚀 Start Working:${NC}"
echo "Template work:     claude"
echo "Feature work:      cd ../claude-phases-develop && claude"
echo "Experiments:       cd ../claude-phases-experimental && claude"
echo "Testing:           cd ../test-integration && claude"

echo
echo -e "${GREEN}✅ Development environment ready!${NC}"
echo "📖 See DEVELOPMENT.md for detailed workflows"