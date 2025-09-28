# Project Structure: Documentation vs Implementation

This document clarifies the relationship between this repository and the actual working implementation.

## Two-Part System

### Part 1: This Repository (claude-phases-adhd-statusline)
**Location**: `/home/bch/dev/00_RELEASE/claude-phases-adhd-statusline/`
**Purpose**: Documentation, research, and development methodology

```
claude-phases-adhd-statusline/
├── README.md                    # Main project documentation
├── CLAUDE.md                    # Project status and feature summary
├── PROJECT-STRUCTURE.md         # This file - explains the split
├── research/                    # ADHD behavioral research
│   ├── adhd-behavioral-patterns.md
│   ├── detection-algorithms.md
│   ├── algorithm-specifications.md
│   └── cognitive-state-mapping.md
├── docs/                        # Technical documentation
│   ├── modules/                 # Module-specific documentation
│   ├── statusline/              # Claude Code integration docs
│   ├── data-outputs/            # JSON schemas and formats
│   └── project_docs/            # Implementation lessons
└── .claude/                     # Phase-based development system
    ├── commands/phase-*.md      # Generated development commands
    └── agents/phase-*.md        # Specialized development agents
```

### Part 2: Working Implementation (~/.claude/)
**Location**: `~/.claude/` (Claude Code configuration directory)
**Purpose**: Production system you use daily

```
~/.claude/
├── adhd-statusline-configurable.sh    # Main statusline (459 lines)
├── statusline-simple-adhd.sh          # Lightweight option (81 lines)
├── modules/                            # Analysis modules
│   ├── config-manager.sh              # Profile management
│   ├── context-switching-analyzer.sh  # Attention tracking
│   ├── energy-assessment.sh           # Energy calculation
│   └── behavioral-analyzer.sh         # Pattern analysis
├── config/
│   ├── adhd-profiles.json             # ADHD profile configurations
│   └── settings.json                  # Claude Code settings
├── logs/                               # Session data and analysis
├── archive/
│   ├── statusline-development/        # 7 evolutionary versions
│   └── adhd-statusline-legacy/         # Prototype modules
└── validate-adhd-system.sh            # System integrity testing
```

## Why This Split?

### Development Methodology
This project was built using the **claude-phases system**, which separates:
- **Planning and documentation** (this repository)
- **Implementation** (live system in ~/.claude/)

### Benefits of This Structure

**For Users:**
- Documentation doesn't clutter your working directory
- Implementation lives where Claude Code expects it
- Clean separation between "learning about it" vs "using it"

**For Developers:**
- Research and methodology preserved for future reference
- Working system can be updated without affecting documentation
- Clear evolution from prototype to production

**For ADHD Developers:**
- Reduced cognitive load: documentation vs daily-use files separated
- Working system easily accessible in ~/.claude/
- Research available when needed but not distracting

## File Relationships

### Documentation Points to Implementation

**README.md references:**
```bash
# Commands point to ~/.claude/
~/.claude/adhd-statusline-configurable.sh
~/.claude/modules/config-manager.sh list
```

**Module documentation explains:**
- How to use files in ~/.claude/modules/
- CLI commands and integration patterns
- Configuration in ~/.claude/config/

### Implementation References Documentation

**Module help systems:**
```bash
~/.claude/modules/config-manager.sh help
# Points users back to documentation for detailed explanations
```

**Configuration comments:**
- Profile files reference research/adhd-behavioral-patterns.md
- Algorithm implementations cite research/detection-algorithms.md

## Daily Usage Pattern

### What You Work With Daily
```bash
# These are your daily tools
~/.claude/adhd-statusline-configurable.sh    # Your statusline
~/.claude/modules/config-manager.sh          # Profile switching
~/.claude/config/adhd-profiles.json          # Your settings
```

### What You Reference When Needed
```bash
# These you consult for understanding/customization
./research/adhd-behavioral-patterns.md       # Why it works this way
./docs/modules/config-manager-documentation.md  # Detailed CLI reference
./README.md                                   # Complete feature overview
```

## Installation Relationship

### This Repository Setup
```bash
# Clone for documentation and research
git clone <repo> claude-phases-adhd-statusline
cd claude-phases-adhd-statusline
# Read documentation, understand the system
```

### Working System Setup
```bash
# Implementation is already in ~/.claude/
ls ~/.claude/adhd-statusline-configurable.sh
~/.claude/modules/config-manager.sh list
# Use the system daily
```

## Update Workflow

### Documentation Updates
```bash
# Work in this repository
cd claude-phases-adhd-statusline
vim README.md
git commit -m "Update documentation"
```

### Implementation Updates
```bash
# Work directly in ~/.claude/
vim ~/.claude/modules/config-manager.sh
~/.claude/validate-adhd-system.sh
# Changes take effect immediately
```

## Key Points for ADHD Developers

### Cognitive Load Management
- **Documentation here**: When you need to understand or learn
- **Implementation in ~/.claude/**: When you need to use or configure
- **No confusion** about which files to edit for what purpose

### Focus-Friendly Design
- **Single responsibility**: Each location has clear purpose
- **Predictable locations**: Always know where to find what you need
- **Reduced context switching**: Related files grouped logically

### Practical Usage
- **Daily work**: Stay in ~/.claude/ for configuration and usage
- **Learning/troubleshooting**: Come to this repository for understanding
- **Customization**: Both locations depending on what you're customizing

This structure supports both the immediate needs of daily ADHD-aware development and the longer-term understanding of how the system works and why it was designed this way.