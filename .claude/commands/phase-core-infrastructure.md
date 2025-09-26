---
allowed-tools: [Read, Write, MultiEdit, Bash(jq:*)]
argument-hint: Build the foundational statusline script architecture with modular components
description: Execute Phase 2 - Core Infrastructure for ADHD Cognitive Statusline
model: claude-sonnet-4-20250514
---

# Core Infrastructure Phase

Build the foundational statusline script architecture with modular, extensible components for cognitive state analysis.

## Current Status 

**Phase 1 Research & Analysis: SUCCESSFULLY COMPLETED** 🎯
**Ready to proceed to Phase 2: Core Infrastructure Development**

Files Generated in phase 1: 

1. `research/statusline-json-analysis.md` - Claude Code data structure analysis @research/statusline-json-analysis.md`
2. `research/cognitive-state-mapping.md` - Cognitive state framework @research/cognitive-state-mapping.md
3. `research/adhd-behavioral-patterns.md` - ADHD-specific pattern research @research/adhd-behavioral-patterns.md
4. `research/detection-algorithms.md` - Core algorithm implementations @research/detection-algorithms.md
5. `research/algorithm-specifications.md` - Mathematical specifications @research/algorithm-specifications.md
6. `research/phase-1-summary.md` - Summary document @research/phase-1-summary.md

## Objectives

1. **Create Statusline Script Entry Point**
   - Build main `~/.claude/statusline.sh` script
   - Implement JSON parsing with jq
   - Create modular function architecture
   - Set up extensible framework for analysis modules

2. **JSON Data Extraction System**
   - Parse Claude Code session data
   - Extract duration, file changes, directory changes
   - Handle missing or incomplete data gracefully
   - Create data validation and sanitization

3. **Modular Analysis Framework**
   - Design plugin-style cognitive analysis modules
   - Create helper functions for data processing
   - Implement state calculation utilities
   - Build threshold management system

4. **Integration Architecture**
   - Ensure proper Claude Code statusline integration
   - Handle script execution environment
   - Implement error handling and fallbacks
   - Create debugging and logging utilities

## Technical Requirements

- **Bash scripting** with proper error handling
- **jq for JSON parsing** and data extraction
- **Modular function design** for maintainability
- **Extensible architecture** for future cognitive modules

## Expected Deliverables

- Complete `~/.claude/statusline.sh` script
- Modular analysis function library
- JSON parsing and data extraction utilities
- Integration testing with Claude Code statusline system

Focus on creating a solid foundation that can support complex cognitive analysis algorithms.