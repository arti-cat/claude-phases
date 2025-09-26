# 🧠 ADHD-Friendly Development Guide

## ⚡ **ULTRA-QUICK START**
```bash
./scripts/dev-setup.sh    # See where you are now
cd ../claude-phases-develop && claude    # Start working
```

## 🎯 **DECISION TREE - PICK ONE**
```
🤔 What do I want to do right now?

├─ 🔧 Fix/improve the template          → Stay here, run `claude`
├─ 🌟 Add a new feature                 → `cd ../claude-phases-develop && claude`
├─ 🧪 Try a crazy experiment           → `cd ../claude-phases-experimental && claude`
├─ 🧪 Test if my changes work          → `cd ../test-integration && claude`
├─ 😵 I'm completely lost              → `./scripts/dev-setup.sh`
└─ 🆘 Something is broken              → See PANIC MODE section below ↓
```

---

*Quick context restoration and clear development workflows for the claude-phases project*

## 🎯 **What Is This Project?**

**claude-phases** is a reusable template system that creates phase-based development workflows for any project. Users copy it to their projects, customize PLAN.md, run `/plan`, and get auto-generated phase commands.

**Current Status:** ✅ Public template ready for users

## 🚀 **Quick Start - Jump Back In**

### **I Want To...**

| Goal | Command | Location |
|------|---------|----------|
| 🔧 **Work on main template** | `claude` | `claude-phases/` |
| 🌟 **Add new features** | `cd ../claude-phases-develop && claude` | `claude-phases-develop/` |
| 🧪 **Try experimental ideas** | `cd ../claude-phases-experimental && claude` | `claude-phases-experimental/` |
| 🧪 **Test with real project** | `cd ../test-integration && claude` | `test-integration/` |
| 📋 **See all worktrees** | `git worktree list` | Any directory |

### **Current State Check**
```bash
# Where am I and what's happening?
pwd && git branch --show-current && git status --short

# What worktrees exist?
git worktree list

# Recent work?
git log --oneline -5
```

## 🌳 **Development Strategy**

### **Branch Structure**
```
main                    # ✅ Stable public template (users copy this)
├── develop            # 🔄 Next release integration
├── feature/*          # 🌟 Individual improvements
├── experimental/*     # 🧪 Radical experiments
├── release/*          # 📦 Version preparation
└── hotfix/*           # 🚨 Critical fixes
```

### **Worktree Layout**
```
~/dev/00_RELEASE/
├── claude-phases/              # Main template (main branch)
├── claude-phases-develop/      # Integration work (develop branch)
├── claude-phases-experimental/ # Wild experiments (experimental/*)
├── test-integration/           # Test environment (test/integration)
└── claude-phases-feature-*/    # Individual features (feature/*)
```

## 🔄 **Common Workflows**

### **Starting a New Feature**
```bash
# 1. Create feature branch and worktree
git worktree add ../claude-phases-feature-NAME -b feature/descriptive-name

# 2. Start working
cd ../claude-phases-feature-NAME
claude

# 3. Test the feature
cp -r .claude/ ../test-integration/
cd ../test-integration && claude
```

### **Experimental Research**
```bash
# 1. Create experiment worktree
git worktree add ../claude-phases-experiment-NAME -b experimental/research-topic

# 2. Go wild with ideas
cd ../claude-phases-experiment-NAME
claude
# Try anything! This is isolated from users.
```

### **Testing Changes**
```bash
# 1. Copy your changes to test environment
cp -r .claude/ ../test-integration/

# 2. Test as if you're a user
cd ../test-integration
# Edit PLAN.md to simulate different project types
# Run /plan and test generated commands
claude
```

### **Ready to Release**
```bash
# 1. Merge to develop
git checkout develop
git merge feature/your-feature

# 2. Test integration
cd ../claude-phases-develop
claude

# 3. Create release when ready
git worktree add ../claude-phases-release-v1.x -b release/v1.x
```

## 📁 **Project Structure Understanding**

### **Core Files** *(What users get)*
```
claude-phases/
├── CLAUDE.md           # 🧠 Project context (generic template)
├── PLAN.md            # 📋 Example plan structure
├── README.md          # 📖 User instructions
└── .claude/
    ├── commands/
    │   ├── plan.md            # 🎯 Main /plan command
    │   ├── init-project-context.md  # 🔄 Template→Project transform
    │   └── validate-plan.md   # ✅ Validation command
    └── agents/
        └── planner.md         # 🤖 Core planner intelligence
```

### **Development Files** *(Not copied to user projects)*
```
claude-phases/
├── DEVELOPMENT.md     # 📚 This guide
├── CONTRIBUTING.md    # 🤝 Contribution guidelines
└── docs/             # 📄 Additional documentation
```

## 🧪 **Testing Strategy**

### **Test Types**
1. **Template Tests** - Does the template work when copied?
2. **Planner Tests** - Does `/plan` generate good commands?
3. **Cross-Stack Tests** - Works with React, Python, Docker, etc?
4. **User Experience Tests** - Is workflow intuitive?

### **Testing Environments**
```bash
# React project simulation

cd ../test-integration
echo "# React E-commerce App..." > PLAN.md
/plan && /phase-frontend-setup

# Python API simulation
echo "# FastAPI Backend..." > PLAN.md
/plan && /phase-backend-api

# Full-stack simulation
echo "# Full-stack SaaS..." > PLAN.md
/plan && /phase-database-setup
```

## 🎯 **Focus Areas for Development**

### **High-Impact Improvements**
- 🤖 **Planner Intelligence** - Better phase detection and tool assignment
- 📚 **Context7 Integration** - Smarter documentation fetching
- 🔧 **Tool Detection** - More accurate technology recognition
- 📋 **PLAN.md Templates** - Pre-built templates for common stacks

### **Experimental Ideas**
- 🧪 **AI-Generated PLAN.md** - Generate plans from project descriptions
- 🔄 **Phase Dependencies** - Automatic prerequisite detection
- 📊 **Progress Tracking** - Visual progress through phases
- 🎨 **Custom Templates** - Industry-specific plan templates

## 🚨 **PANIC MODE - I'M LOST!**

### **🆘 Emergency Context Recovery**
```bash
./scripts/dev-setup.sh    # Shows everything - where am I?
git worktree list         # What do I have?
git log --oneline -3      # What was I doing?
```

### **🔥 Something Broke?**
```bash
# Quick backup first
git stash push -m "PANIC BACKUP"

# Create emergency fix
git worktree add ../claude-phases-HOTFIX -b hotfix/emergency
cd ../claude-phases-HOTFIX && claude
```

### **🧹 Start Completely Fresh**
```bash
# Nuclear option - removes all worktrees
./scripts/dev-setup.sh    # Will rebuild everything
```

## 💡 **Development Tips**

### **ADHD-Friendly Practices**
- ✅ **Single Focus** - One worktree = one task
- 📝 **Document Everything** - Update this guide as you learn
- 🔄 **Context Switching** - Use worktrees to pause/resume work
- 🎯 **Clear Goals** - Each branch has specific purpose
- 📊 **Visual Progress** - Use git graph to see relationships

### **Claude Code Integration**
```bash
# Always start Claude in the right directory
cd claude-phases-develop && claude

# Use continue to pick up previous conversations
claude --continue

# Multiple Claude sessions for parallel work
claude # In one worktree
cd ../claude-phases-experimental && claude # In another
```

### **Useful Aliases** *(Add to ~/.bashrc)*
```bash
alias cptree='git worktree list'
alias cpdev='cd ~/dev/00_RELEASE/claude-phases-develop'
alias cpexp='cd ~/dev/00_RELEASE/claude-phases-experimental'
alias cptest='cd ~/dev/00_RELEASE/test-integration'
alias cpmain='cd ~/dev/00_RELEASE/claude-phases'
```

## 📚 **Learning Resources**

- [Git Worktree Documentation](https://git-scm.com/docs/git-worktree)
- [Claude Code Best Practices](/docs) (use `/docs common-workflows`)
- [Context7 MCP Documentation](https://github.com/context7/context7)

## 🤝 **Contributing Guidelines**

### **Before Starting**
1. 📋 Create/update TODO in relevant issue
2. 🌿 Create feature branch and worktree
3. 🧪 Test thoroughly in test environment
4. 📝 Update documentation

### **Code Standards**
- ✅ Each phase agent gets minimal required tools
- 📚 Use Context7 for up-to-date documentation
- 🔧 Prefer modern tooling (UV for Python, etc.)
- 📋 Follow existing PLAN.md structure patterns

### **Pull Request Checklist**
- [ ] 🧪 Tested in multiple project types
- [ ] 📝 Documentation updated
- [ ] 🤖 Planner generates correct commands
- [ ] 🔧 No breaking changes to public API
- [ ] ✅ All phase agents work correctly

---

## 🎉 **You've Got This!**

This project is designed to be picked up and resumed easily. Each worktree is a different context, each branch has a clear purpose, and this guide will always be here to remind you what you were thinking.

**When in doubt:** Start with `git worktree list` and `git log --oneline -5` to see what's happening.

**Remember:** The main branch is for users. Everything else is your playground.