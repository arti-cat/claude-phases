# ADHD Cognitive Statusline Project Plan

Build an ADHD-aware cognitive state tracker that displays real-time mental state assessment in Claude Code's statusline, based on session behavior patterns.

## Research & Analysis

Research cognitive indicators available in Claude Code's statusline JSON data and design behavioral pattern detection algorithms.

**Goals:**
- Use Context7 to fetch current Claude Code statusline documentation
- Map JSON data fields (duration, lines added/removed, cwd changes) to cognitive states
- Research ADHD-specific behavioral patterns in coding sessions
- Design detection algorithms for focus, energy, and context-switching states

**Technologies:**
- Context7 MCP for documentation
- Claude Code statusline JSON structure
- Behavioral analysis patterns
- Cognitive science principles

## Core Infrastructure

Build the foundational statusline script architecture with modular, extensible components.

**Goals:**
- Create statusline script entry point and JSON parsing
- Build modular architecture for analysis functions
- Implement helper functions for data extraction
- Set up extensible framework for cognitive analysis modules

**Technologies:**
- Bash scripting
- jq for JSON parsing
- Modular function design
- Claude Code statusline integration

## Cognitive Detection Engine

Implement the core cognitive state detection algorithms using session behavioral data.

**Goals:**
- Implement focus state detection based on session duration patterns
- Build energy level assessment using productivity velocity
- Create context switching detection from directory/project changes
- Develop hyperfocus warning system for extended sessions

**Technologies:**
- Mathematical analysis algorithms
- Pattern recognition logic
- Threshold-based state detection
- Time-series behavioral analysis

## Visual Display System

Create the visual output system with color-coded indicators and actionable messaging.

**Goals:**
- Design color-coded cognitive state indicators (🟢🟡🔴)
- Implement contextual messaging ("Take break", "Good flow", "Hyperfocus warning")
- Create emoji-based state visualization
- Build theme system for different visual styles
- Some people find that many colors and emojis are distracting, cater for them

**Technologies:**
- ANSI color codes
- Unicode emoji support
- String formatting
- Visual design patterns

## Configuration Framework

Build user-customizable configuration system for personalized cognitive thresholds.

**Goals:**
- Create JSON-based configuration file system
- Implement user-customizable thresholds for cognitive states
- Build personality-based configuration profiles
- Add runtime configuration loading and validation

**Technologies:**
- JSON configuration files
- Default/override configuration patterns
- File system operations
- Configuration validation

## Integration & Testing

Test the cognitive assessment accuracy against real coding sessions and validate the complete system.

**Goals:**
- Test cognitive state accuracy against real Claude Code sessions
- Validate integration with existing statusline system
- Create testing framework for behavioral pattern validation
- Document system performance and accuracy metrics

**Technologies:**
- Testing frameworks
- Session data analysis
- Performance validation
- Documentation systems

---

## Project Context

This project serves a dual purpose:
1. **Build** an innovative ADHD cognitive support tool for developers
2. **Test** the claude-phases planning system with a non-traditional project structure

## Expected Learning Outcomes

- How well does the planner handle behavioral/cognitive science projects?
- Can the system generate appropriate tools for script-based (non-web) projects?
- Does Context7 integration work effectively for fetching current documentation?
- How does the phase execution work for analysis and research-heavy phases?

## Success Metrics

- Generated phase commands match the project's unique requirements
- Context7 successfully fetches Claude Code statusline documentation
- Each phase agent receives appropriate tools for its specific tasks
- Complete statusline implementation provides accurate cognitive feedback