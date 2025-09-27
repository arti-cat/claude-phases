# Claude Code Statusline Documentation

## Overview

This documentation covers the official Claude Code statusline system, providing comprehensive information about the JSON data structure, best practices, and categorized use cases for building cognitive-aware statuslines.

## Directory Structure

```
docs/statusline/
├── README.md                           # This file
├── best-practices/
│   └── official-guidelines.md          # Official Anthropic guidelines
├── schema/
│   └── anthropic-official-schema.json  # JSON schema definition
├── examples/
│   └── raw-json-sample.json           # Sample JSON data
└── categories/
    └── data-categories.md              # Data field categorization
```

## Key Findings

### Data Source Authority
- **JSON Structure**: Officially defined by Anthropic (not community-created)
- **Hook System**: Part of Claude Code's built-in hook architecture
- **Update Frequency**: Maximum 300ms, triggered by conversation changes
- **Data Format**: Standardized across all Claude Code installations

### Core Data Categories

1. **Session Identity** - Session tracking and context management
2. **Workspace Navigation** - Directory and project awareness
3. **Model Information** - AI model and system details
4. **Performance Metrics** - Cost, duration, and API timing
5. **Productivity Data** - Code lines added/removed

### ADHD-Specific Applications

The official data structure provides excellent foundations for:
- **Focus State Detection** through session duration and productivity patterns
- **Context Switching Analysis** via workspace directory changes
- **Energy Level Assessment** using code velocity and API response times
- **Hyperfocus Detection** through extended session patterns

## Usage for Cognitive Statuslines

### Basic Implementation
```bash
#!/bin/bash
input=$(cat)
duration=$(echo "$input" | jq -r '.cost.total_duration_ms')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added')
echo "Focus: ${duration}ms | Productivity: $lines_added lines"
```

### Advanced Cognitive Analysis
The data categories document shows how to combine multiple fields for sophisticated ADHD-aware cognitive state detection.

## Next Steps

1. Use the schema for validation in your statusline scripts
2. Reference the data categories for cognitive algorithm design
3. Follow the official guidelines for best performance
4. Extend with community tools for additional context (git, time, etc.)

## Files Description

- **official-guidelines.md**: Best practices from Anthropic documentation
- **anthropic-official-schema.json**: JSON Schema for validation
- **raw-json-sample.json**: Real-world example of statusline data
- **data-categories.md**: Organized field categories for different use cases