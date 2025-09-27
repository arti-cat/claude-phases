# Claude Code Statusline: Official Guidelines

## Overview

The Claude Code statusline is an **official Anthropic feature** that provides real-time session context through a standardized JSON data structure. This is not a community extension - it's built into Claude Code itself.

## Official JSON Structure (by Anthropic)

The JSON object passed to statusline scripts is **officially defined by Anthropic** and contains:

### Core Session Data
- `hook_event_name`: Always "Status" for statusline hooks
- `session_id`: Unique session identifier
- `transcript_path`: Path to conversation transcript
- `cwd`: Current working directory

### Model Information
- `model.id`: Technical model identifier
- `model.display_name`: Human-readable model name

### Workspace Context
- `workspace.current_dir`: Current working directory
- `workspace.project_dir`: Original project directory

### Performance Metrics
- `cost.total_cost_usd`: Session cost in USD
- `cost.total_duration_ms`: Total session duration
- `cost.total_api_duration_ms`: API call duration
- `cost.total_lines_added`: Lines of code added
- `cost.total_lines_removed`: Lines of code removed

### System Info
- `version`: Claude Code version
- `output_style.name`: Current theme/style

## Official Best Practices

### Performance
- Updates triggered by conversation changes
- Maximum update frequency: 300ms
- Keep processing lightweight

### Output Format
- First line of stdout becomes statusline text
- Support for ANSI color codes
- Keep output concise

### Script Requirements
- Must be executable
- Output to stdout only
- Handle JSON parsing gracefully

## Configuration Methods

### 1. Settings File
```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh",
    "padding": 0
  }
}
```

### 2. Interactive Setup
```bash
/statusline
```

## Supported Languages

Anthropic officially supports statusline scripts in:
- Bash (with jq for JSON parsing)
- Python
- Node.js
- Any executable that can read stdin and write stdout

## Data Source Distinction

**Official Anthropic Data**: All core JSON fields listed above
**Community Extensions**: Git information, advanced metrics, budget tracking, etc.

The base JSON structure is standardized and maintained by Anthropic as part of Claude Code's hook system.