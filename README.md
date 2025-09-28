# ADHD Cognitive Statusline for Claude Code

**Real-time cognitive state assessment designed specifically for developers with ADHD.**

This project represents the first systematic approach to ADHD-aware development tooling, integrating behavioral analysis directly into Claude Code's statusline to provide continuous cognitive state monitoring and proactive intervention.

## Table of Contents

- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [How It Works](#how-it-works)
- [Technical Architecture](#technical-architecture)
- [ADHD-Specific Features](#adhd-specific-features)
- [Installation Guide](#installation-guide)
- [Configuration](#configuration)
- [Documentation](#documentation)
- [Development](#development)

## Quick Start

### Current Status: Production Ready

This project is **complete and working**. The implementation lives in `~/.claude/` (your Claude Code configuration directory), not in this project directory.

**What you have:**
- Working ADHD statusline displaying cognitive states in real-time
- Modular system with 4 specialized analysis modules
- 6 ADHD-specific configuration profiles
- Complete hyperfocus prevention and energy tracking

**To verify your installation:**
```bash
# Check your statusline is working
~/.claude/adhd-statusline-configurable.sh

# View available profiles
~/.claude/modules/config-manager.sh list

# See current configuration
~/.claude/modules/config-manager.sh current
```

## Project Structure

### This Repository (claude-phases-adhd-statusline)
**Documentation and research project using the claude-phases system.**
```
├── research/                   # ADHD behavioral analysis and algorithms
├── docs/                      # Technical documentation and schemas
├── .claude/                   # Phase-based development system
└── README.md                  # This file
```

### Implementation Location (~/.claude/)
**Production system where the actual statusline lives.**
```
~/.claude/
├── adhd-statusline-configurable.sh    # Main statusline (459 lines)
├── statusline-simple-adhd.sh          # Lightweight version (81 lines)
├── modules/                            # Analysis modules
│   ├── config-manager.sh              # Profile system
│   ├── context-switching-analyzer.sh  # Attention tracking
│   ├── energy-assessment.sh           # Energy calculation
│   └── behavioral-analyzer.sh         # Pattern analysis
├── config/
│   └── adhd-profiles.json             # ADHD profile configurations
└── archive/                           # Development history
```

### Key Distinction
- **This project**: Documentation, research, development methodology
- **`~/.claude/`**: Actual working statusline and modules you use daily

## How It Works

### Real-Time Cognitive Assessment

The system analyzes your Claude Code session data to determine:

**Focus States:**
- **Deep Focus**: API ratio <8%, sustained attention
- **Focused**: API ratio <15%, good concentration
- **Scattered**: API ratio <30%, frequent context switching
- **Unfocused**: API ratio >30%, high help-seeking
- **Hyperfocus**: Duration >120min + high productivity + low API usage

**Energy Levels:**
- Calculated from productivity velocity with circadian adjustments
- Factors: lines of code per minute, session consistency, time of day
- Penalties for high context switching (30% reduction)

**Hyperfocus Prevention:**
- Progressive warnings: 90min → 120min → 180min → 240min
- Risk scoring: Duration + Context + Energy + API patterns
- Break recommendations before cognitive fatigue

### Data Flow

```
Claude Code JSON → Module Analysis → Cognitive Assessment → Statusline Display
```

1. **Input**: Claude Code session data (API calls, file changes, timestamps)
2. **Analysis**: 4 specialized modules process behavioral patterns
3. **Integration**: Results combined with ADHD profile settings
4. **Output**: Real-time cognitive state display in statusline

## Technical Architecture

### Core Components

**Primary Statusline:**
- `adhd-statusline-configurable.sh` (459 lines)
- Integrates all modules with fallback handling
- Sub-300ms execution for real-time responsiveness
- Profile-aware threshold adjustments

**Analysis Modules:**
- **config-manager.sh**: ADHD profile management, JSON validation
- **context-switching-analyzer.sh**: Attention fragmentation scoring
- **energy-assessment.sh**: Circadian-aware productivity calculation
- **behavioral-analyzer.sh**: Pattern recognition and classification

### Module Integration

Each module operates independently but enhanced when combined:

```bash
# Modules can work standalone
~/.claude/modules/energy-assessment.sh 100 30 15 25 morning

# Or integrated through main statusline
~/.claude/adhd-statusline-configurable.sh
```

**Data Dependencies:**
- No hard dependencies between modules
- Graceful degradation when modules unavailable
- JSON-based communication for loose coupling

## ADHD-Specific Features

### Attention Regulation
- **Context Switching Analysis**: Tracks directory changes, branch switches, tool usage
- **Fragmentation Scoring**: 0-100 scale attention consistency measurement
- **Cognitive Load Penalties**: Reduced energy scores for high task-switching

### Hyperfocus Management
- **Mathematical Detection**: Duration + Productivity + API ratio thresholds
- **Progressive Intervention**: Gentle escalation from check-ins to break requirements
- **Risk Assessment**: Multi-factor scoring prevents burnout

### Personalized Profiles
- **Inattentive**: Lower switching tolerance, extended hyperfocus detection
- **Hyperactive**: Higher switching tolerance, shorter hyperfocus windows
- **Combined**: Balanced settings for mixed presentation
- **Sensitive/Intensive**: Customized for stimulation sensitivity levels

### Circadian Integration
- **Morning Peak**: Enhanced thresholds during 9-11 AM clarity periods
- **Post-lunch Dip**: Adjusted expectations during 1-3 PM energy reduction
- **Evening Risk**: Increased hyperfocus susceptibility 8-11 PM

## Installation Guide

### Current Installation (Already Working)

If you see cognitive states in your statusline, you're already set up. Your configuration:

```json
// ~/.claude/settings.json or .claude/settings.local.json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/adhd-statusline-configurable.sh",
    "padding": 0
  }
}
```

### Manual Installation

If you need to install from scratch:

```bash
# 1. Verify files exist
ls ~/.claude/adhd-statusline-configurable.sh
ls ~/.claude/modules/

# 2. Test statusline
~/.claude/adhd-statusline-configurable.sh

# 3. Add to Claude Code settings
echo '{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/adhd-statusline-configurable.sh",
    "padding": 0
  }
}' > ~/.claude/settings.json
```

### Dependencies

Required system tools:
```bash
# Ubuntu/Debian
sudo apt-get install jq bc

# macOS
brew install jq bc
```

## Configuration

### ADHD Profile Selection

```bash
# View available profiles
~/.claude/modules/config-manager.sh list

# Available profiles:
# - default: Balanced settings for most ADHD developers
# - inattentive: Optimized for primarily inattentive presentation
# - hyperactive: Optimized for hyperactive-impulsive presentation
# - combined: Settings for combined presentation
# - sensitive: Lower thresholds for overstimulation sensitivity
# - intensive: Higher thresholds for intensive development periods

# Switch profiles
~/.claude/modules/config-manager.sh set hyperactive
```

### Custom Thresholds

Create `~/.claude/config/user_profile.json` to override settings:

```json
{
  "thresholds": {
    "hyperfocus": {
      "warning_duration_hours": 1.5,
      "critical_risk_score": 70
    },
    "focus": {
      "scattered_max_switches": 6
    }
  },
  "display": {
    "compact_mode": true,
    "show_progress_bars": false
  }
}
```

### Visual Customization

```bash
# Get current visual settings
~/.claude/modules/config-manager.sh visual

# Modify in profile configuration for:
# - Color themes (ANSI colors, themes for accessibility)
# - Progress bar styles (ASCII, Unicode, disabled)
# - Alert escalation (subtle, prominent, blinking)
# - Compact mode for reduced visual clutter
```

## Documentation

### Technical Documentation

**Module Documentation:**
- [modules/README.md](docs/modules/README.md) - Integration overview
- [modules/config-manager-documentation.md](docs/modules/config-manager-documentation.md) - Profile system
- [modules/context-switching-analyzer-documentation.md](docs/modules/context-switching-analyzer-documentation.md) - Attention tracking
- [modules/energy-assessment-documentation.md](docs/modules/energy-assessment-documentation.md) - Energy calculation
- [modules/behavioral-analyzer-documentation.md](docs/modules/behavioral-analyzer-documentation.md) - Pattern analysis

**Architecture Documentation:**
- [docs/statusline/](docs/statusline/) - Claude Code statusline integration
- [docs/data-outputs/](docs/data-outputs/) - JSON schemas and data formats
- [research/](research/) - ADHD behavioral patterns and algorithms

### Research Foundation

**ADHD Behavioral Analysis:**
- [research/adhd-behavioral-patterns.md](research/adhd-behavioral-patterns.md) - Core behavior mapping
- [research/detection-algorithms.md](research/detection-algorithms.md) - Mathematical models
- [research/algorithm-specifications.md](research/algorithm-specifications.md) - Implementation details

**Implementation Lessons:**
- [docs/project_docs/](docs/project_docs/) - Development insights and lessons learned

## Development

### Project History

This project was developed using the claude-phases system with 6 phases:

1. **Research & Analysis** - ADHD behavioral patterns and cognitive mapping
2. **Core Infrastructure** - Statusline architecture and data flow analysis
3. **Cognitive Detection** - Mathematical algorithms for behavioral analysis
4. **Visual Display** - ADHD-sensitive visual feedback systems
5. **Configuration** - Personalized profile system for ADHD presentations
6. **Integration & Testing** - Production validation and deployment

### Development Files

**Evolution Archive:**
- `~/.claude/archive/statusline-development/` - 7 implementation versions
- `~/.claude/archive/adhd-statusline-legacy/` - Prototype modules

**Current Development:**
- All development complete, system in production use
- Future enhancements can extend existing modular architecture

### Testing and Validation

```bash
# Validate system integrity
~/.claude/validate-adhd-system.sh

# Test individual modules
~/.claude/modules/config-manager.sh validate
~/.claude/modules/energy-assessment.sh help
~/.claude/modules/context-switching-analyzer.sh help

# Debug mode
export ADHD_STATUSLINE_DEBUG=1
~/.claude/adhd-statusline-configurable.sh
```

## Privacy and Data

### Local-Only Processing
- All cognitive behavioral data stored locally in `~/.claude/`
- No external transmission or cloud storage
- Complete user control over personal cognitive patterns

### Data Files
- `~/.claude/logs/` - Session analysis and behavioral patterns
- `~/.claude/config/` - Profile settings and customizations
- `~/.claude/history.jsonl` - Claude Code session tracking

## Support

### Troubleshooting

**Common Issues:**
1. **No statusline output**: Check jq and bc are installed
2. **Wrong profile active**: Use `config-manager.sh set <profile>`
3. **Module errors**: Enable debug mode with `export ADHD_STATUSLINE_DEBUG=1`
4. **Performance issues**: Switch to lightweight version `statusline-simple-adhd.sh`

**Debug Information:**
```bash
# Check module availability
ls ~/.claude/modules/

# Test module functionality
~/.claude/modules/config-manager.sh help

# Check configuration
~/.claude/modules/config-manager.sh current
```

### ADHD-Specific Considerations

**For Inattentive Presentation:**
- Use `inattentive` profile for extended hyperfocus detection
- Enable visual progress bars for external motivation
- Consider `sensitive` profile for lower stimulation thresholds

**For Hyperactive Presentation:**
- Use `hyperactive` profile for higher context switching tolerance
- Enable compact mode to reduce visual clutter
- Consider `intensive` profile for high-productivity periods

**For Combined Presentation:**
- Start with `combined` profile and adjust based on daily patterns
- Use custom thresholds to fine-tune sensitivity
- Monitor energy patterns for optimal configuration

## Innovation Impact

This project represents several firsts in software development tooling:

- **First real-time ADHD cognitive assessment** integrated into development environment
- **First behavioral proxy system** using coding patterns as cognitive indicators
- **First mathematical ADHD modeling** with quantitative algorithms for subjective experiences
- **First proactive intervention system** for hyperfocus and cognitive fatigue prevention
- **First evidence-based neurodivergent profiles** with clinical research foundation

The technical approach demonstrates how development environment data can serve as powerful proxies for cognitive state assessment, opening new possibilities for inclusive and neurodiversity-aware tooling.

---

**Note**: This tool is designed to support developers with ADHD and is not a medical diagnostic tool. For clinical ADHD assessment and treatment, please consult with healthcare professionals.