# Claude Code Hook Logs & Debugging Data

## Overview
Hook logs and debugging data provide detailed insights into tool usage, user behavior, and system events that are invaluable for ADHD cognitive pattern analysis.

## Hook System Logs

### Bash Command Logging
**Purpose**: Track all bash commands executed by Claude Code
**Location**: `~/.claude/bash-command-log.txt`

#### Configuration
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "jq -r '\"\\(.tool_input.command) - \\(.tool_input.description // \"No description\")\"' >> ~/.claude/bash-command-log.txt"
          }
        ]
      }
    ]
  }
}
```

#### Log Format
```
cd /home/user/project - Change to project directory
ls -la - List files in current directory
git status - Check repository status
npm install - Install project dependencies
```

#### ADHD Analysis Applications
- **Context Switching**: Frequency of `cd` commands
- **Task Persistence**: Long sequences of related commands
- **Work Patterns**: Command types and timing

### Tool Usage Logs
**Purpose**: Monitor all tool executions with detailed metadata

#### PreToolUse Hook Data
```json
{
  "session_id": "abc123",
  "transcript_path": "/path/to/transcript.jsonl",
  "cwd": "/current/directory",
  "hook_event_name": "PreToolUse",
  "tool_name": "Write",
  "tool_input": {
    "file_path": "/path/to/file.txt",
    "content": "file content"
  }
}
```

#### PostToolUse Hook Data
```json
{
  "session_id": "abc123",
  "transcript_path": "/path/to/transcript.jsonl",
  "cwd": "/current/directory",
  "hook_event_name": "PostToolUse",
  "tool_name": "Write",
  "tool_input": {
    "file_path": "/path/to/file.txt",
    "content": "file content"
  },
  "tool_response": {
    "filePath": "/path/to/file.txt",
    "success": true
  }
}
```

#### Custom Tool Logging Script
```bash
#!/bin/bash
# Log tool usage with timestamps
input=$(cat)
timestamp=$(date -Iseconds)
tool_name=$(echo "$input" | jq -r '.tool_name')
echo "[$timestamp] Tool: $tool_name" >> ~/.claude/tool-usage.log
```

## Session Event Logs

### SessionStart Hook
**Trigger**: When Claude Code session begins
```json
{
  "session_id": "abc123",
  "transcript_path": "~/.claude/projects/.../session.jsonl",
  "hook_event_name": "SessionStart",
  "source": "startup"
}
```

**Source Types**:
- `startup` - Fresh Claude Code launch
- `resume` - Resuming existing session
- `clear` - After conversation clear
- `compact` - After context compaction

### SessionEnd Hook
**Trigger**: When Claude Code session terminates
```json
{
  "session_id": "abc123",
  "transcript_path": "~/.claude/projects/.../session.jsonl",
  "cwd": "/Users/...",
  "hook_event_name": "SessionEnd",
  "reason": "exit"
}
```

**Reason Types**:
- `exit` - Normal exit
- `clear` - Conversation cleared
- `logout` - User logout
- `prompt_input_exit` - Exit from prompt
- `other` - Other termination reasons

### User Behavior Logs

#### UserPromptSubmit Hook
**Trigger**: When user submits a prompt
```json
{
  "session_id": "abc123",
  "transcript_path": "/path/to/transcript.jsonl",
  "cwd": "/current/directory",
  "hook_event_name": "UserPromptSubmit",
  "prompt": "Write a function to calculate factorial"
}
```

#### Notification Hook
**Trigger**: System notifications
```json
{
  "session_id": "abc123",
  "transcript_path": "/path/to/transcript.jsonl",
  "cwd": "/current/directory",
  "hook_event_name": "Notification",
  "message": "Task completed successfully"
}
```

## Debugging & Verbose Logs

### Verbose Mode
**Enable**: `claude --verbose`
**Purpose**: Detailed turn-by-turn conversation output

#### Verbose Output Example
```
[DEBUG] Session started: abc123
[DEBUG] User prompt: "Help me debug this function"
[DEBUG] Model: claude-3-5-sonnet-20241022
[DEBUG] Tool call: Read(file_path="/path/to/file.js")
[DEBUG] Tool result: File content loaded (1247 chars)
[DEBUG] Assistant response: I can see the issue in your function...
[DEBUG] Session cost: $0.0045
```

### Debug Logging
**Enable**: `export ANTHROPIC_LOG=debug`
**Purpose**: Low-level request/response debugging

#### Debug Log Content
- HTTP request/response details
- API timing information
- Authentication flow
- Error stack traces
- Network connectivity issues

## Permission & Security Logs

### Permission Denial Logs
**Purpose**: Track denied tool access attempts

#### Auto-Approval Hook Example
```python
#!/usr/bin/env python3
import json
import sys

input_data = json.load(sys.stdin)
tool_name = input_data.get("tool_name", "")
tool_input = input_data.get("tool_input", {})

# Log all permission checks
with open("~/.claude/permission-log.txt", "a") as f:
    f.write(f"Permission check: {tool_name} - {tool_input}\n")

# Auto-approve documentation reads
if tool_name == "Read":
    file_path = tool_input.get("file_path", "")
    if file_path.endswith((".md", ".txt", ".json")):
        output = {
            "decision": "approve",
            "reason": "Documentation file auto-approved",
            "suppressOutput": True
        }
        print(json.dumps(output))
        sys.exit(0)
```

## ADHD-Specific Log Analysis

### Focus Pattern Detection
```bash
# Analyze session duration patterns
grep "SessionStart" ~/.claude/logs/*.log | \
while read line; do
  start_time=$(echo "$line" | jq -r '.timestamp')
  session_id=$(echo "$line" | jq -r '.session_id')
  # Find corresponding SessionEnd
  end_time=$(grep "SessionEnd.*$session_id" ~/.claude/logs/*.log | jq -r '.timestamp')
  # Calculate duration
  duration=$(date -d "$end_time" +%s) - $(date -d "$start_time" +%s)
  echo "Session $session_id: ${duration}s"
done
```

### Context Switching Analysis
```bash
# Count directory changes per session
session_id="abc123"
grep "cd " ~/.claude/bash-command-log.txt | \
grep -A1 -B1 "$session_id" | \
wc -l
```

### Tool Usage Patterns
```bash
# Analyze tool usage frequency over time
tail -f ~/.claude/tool-usage.log | \
awk '{print $2, $4}' | \
sort | uniq -c | \
sort -nr
```

### Hyperfocus Detection
```bash
# Detect extended coding sessions
grep "SessionStart\|SessionEnd" ~/.claude/logs/*.log | \
awk '/SessionStart/{start=$3} /SessionEnd/{if($3-start > 7200) print "Hyperfocus session:", start, "to", $3}'
```

## Log File Management

### Default Locations
- Bash commands: `~/.claude/bash-command-log.txt`
- Custom logs: User-defined paths
- System logs: Platform-specific locations

### Rotation & Cleanup
```bash
# Rotate logs daily
mv ~/.claude/bash-command-log.txt ~/.claude/logs/bash-$(date +%Y%m%d).log
touch ~/.claude/bash-command-log.txt
```

### Log Aggregation
```bash
# Combine all logs for analysis
cat ~/.claude/logs/*.log | \
jq -s 'sort_by(.timestamp)' > ~/.claude/combined-session-log.json
```

## Real-time Monitoring

### Live Hook Monitoring
```bash
# Monitor hooks in real-time
tail -f ~/.claude/bash-command-log.txt | \
while IFS= read -r line; do
  echo "[$(date)] Command: $line"
done
```

### Session Activity Stream
```bash
# Real-time session monitoring
#!/bin/bash
SESSION_LOG="/tmp/claude-session-monitor.log"

# Hook script that logs to monitored file
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "echo \"[$(date -Iseconds)] Tool: $(echo '$INPUT' | jq -r '.tool_name')\" >> $SESSION_LOG"
          }
        ]
      }
    ]
  }
}

# Monitor the log
tail -f "$SESSION_LOG"
```

## Integration with ADHD Statusline

### Hook Data in Statusline
```bash
#!/bin/bash
# Statusline script with hook data integration
input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id')

# Get recent tool usage
recent_tools=$(tail -10 ~/.claude/tool-usage.log | grep "$session_id" | wc -l)

# Display cognitive activity indicator
if [ "$recent_tools" -gt 5 ]; then
  echo "🔥 High Activity"
elif [ "$recent_tools" -gt 2 ]; then
  echo "⚡ Active"
else
  echo "💤 Idle"
fi
```

### Behavioral Pattern Alerts
```bash
# Alert on hyperfocus patterns
session_duration=$(echo "$input" | jq -r '.cost.total_duration_ms')
if [ "$session_duration" -gt 7200000 ]; then  # 2 hours
  echo "⚠️ Hyperfocus Alert - Consider Break"
fi
```