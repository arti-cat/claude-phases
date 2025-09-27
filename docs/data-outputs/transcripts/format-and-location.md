# Claude Code Transcript Files

## Overview
Transcript files (.jsonl) contain the complete conversation history and are the most comprehensive source of behavioral data for ADHD cognitive analysis.

## File Location & Structure

### Standard Path
```
~/.claude/projects/PROJECT_NAME/SESSION_ID.jsonl
```

### Path Components
- **PROJECT_NAME**: Based on the directory name where Claude Code was started
- **SESSION_ID**: UUID format (e.g., `12345678-1234-5678-9012-123456789012`)
- **Extension**: `.jsonl` (JSON Lines format - one JSON object per line)

### Example Paths
```
~/.claude/projects/my-awesome-project/abc123def456ghi789.jsonl
~/.claude/projects/web-app/12345678-1234-5678-9012-123456789012.jsonl
```

## File Format

### JSONL Structure
Each line in the transcript file is a complete JSON object representing one conversation turn or event.

### Sample Transcript Entry
```json
{
  "timestamp": "2024-01-15T14:30:25.123Z",
  "type": "user_message",
  "content": "Help me implement a new feature",
  "session_id": "abc123def456ghi789",
  "message_id": "msg_001"
}
```

### Common Entry Types
- `user_message` - User input
- `assistant_message` - Claude's response
- `tool_call` - Tool execution request
- `tool_result` - Tool execution result
- `system_event` - Session start/end, errors

## ADHD Behavioral Data Available

### Session Patterns
- **Session Duration**: Time between first and last entries
- **Activity Gaps**: Time intervals between messages
- **Session Frequency**: Number of sessions per day/week

### Interaction Patterns
- **Message Length**: User input complexity over time
- **Response Time**: Delays between user messages
- **Topic Switching**: Content analysis for context changes

### Tool Usage Patterns
- **Directory Changes**: Workspace navigation frequency
- **File Operations**: Code editing patterns
- **Command Execution**: Terminal usage behavior

## Data Extraction Examples

### Session Duration Analysis
```bash
# Get session start and end times
head -1 transcript.jsonl | jq '.timestamp'
tail -1 transcript.jsonl | jq '.timestamp'
```

### Tool Usage Frequency
```bash
# Count tool calls by type
grep '"type":"tool_call"' transcript.jsonl | jq '.tool_name' | sort | uniq -c
```

### Directory Change Detection
```bash
# Extract directory changes
grep '"tool_name":"Bash"' transcript.jsonl | \
  jq -r 'select(.tool_input.command | startswith("cd ")) | .tool_input.command'
```

## Cognitive State Indicators

### Focus State Metrics
- **Sustained Work**: Long periods without directory changes
- **Deep Focus**: Extended sessions with consistent tool usage
- **Fragmented Attention**: Frequent context switching between files/directories

### Energy Level Indicators
- **Productivity Velocity**: File edits and code changes per time unit
- **Response Latency**: Time between Claude responses and user follow-ups
- **Command Complexity**: Bash command sophistication over session

### Hyperfocus Detection
- **Session Length**: Sessions >2 hours
- **Tool Consistency**: High ratio of file operations vs. navigation
- **Low Context Switching**: Minimal directory changes

## File Management

### Automatic Creation
- Created automatically when Claude Code starts in a new directory
- New session ID generated for each conversation restart

### File Retention
- Files persist until manually deleted
- No automatic cleanup by Claude Code
- Can grow large with extensive usage

### Privacy Considerations
- Contains complete conversation history
- May include sensitive file paths and content
- Consider encryption for sensitive projects

## Integration with ADHD Statusline

### Real-time Access
The transcript path is available in statusline JSON:
```json
{
  "transcript_path": "/home/user/.claude/projects/my-project/session.jsonl"
}
```

### Live Analysis
```bash
# Monitor current session in real-time
tail -f "$transcript_path" | jq '.timestamp, .type'
```

### Historical Analysis
```bash
# Analyze all sessions for a project
for file in ~/.claude/projects/my-project/*.jsonl; do
  echo "Session: $(basename $file)"
  jq -r '.timestamp' "$file" | head -1
  jq -r '.timestamp' "$file" | tail -1
done
```