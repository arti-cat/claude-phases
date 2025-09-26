---
allowed-tools: [Read, Write, MultiEdit, Bash(jq:*)]
argument-hint: Build the foundational statusline script architecture with modular components
description: Execute Phase 2 - Core Infrastructure for ADHD Cognitive Statusline
model: claude-sonnet-4-20250514
---

# Core Infrastructure Phase

Build the foundational statusline script architecture with modular, extensible components for cognitive state analysis.

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