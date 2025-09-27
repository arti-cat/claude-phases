# Claude Code Statusline Architecture & Data Flow

## System Architecture

### Core Components
```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Claude Code   │────│  Hook System     │────│  Statusline     │
│   Session       │    │  (Status Event)  │    │  Script         │
│   Management    │    │                  │    │  Execution      │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│  Session State  │────│  JSON Generator  │────│  stdout Line 1  │
│  Tracking       │    │  (stdin pipe)    │    │  → Terminal     │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### Data Flow Pipeline

#### 1. Trigger Detection
- **Primary**: Conversation changes (user input, assistant responses, tool calls)
- **Secondary**: Workspace context changes (directory navigation)
- **Frequency**: Maximum 300ms intervals (rate-limited)
- **Event Type**: "Status" hook event in Claude Code's hook system

#### 2. Data Generation
Claude Code compiles current session state into structured JSON:
```json
{
  "hook_event_name": "Status",
  "session_id": "unique-session-identifier",
  "transcript_path": "/absolute/path/to/session.jsonl",
  "cwd": "/current/working/directory",
  "model": {
    "id": "technical-model-id",
    "display_name": "Human-readable-name"
  },
  "workspace": {
    "current_dir": "/current/directory/path",
    "project_dir": "/original/project/root"
  },
  "version": "claude-code-version",
  "output_style": {
    "name": "current-theme"
  },
  "cost": {
    "total_cost_usd": 0.00000,
    "total_duration_ms": 0,
    "total_api_duration_ms": 0,
    "total_lines_added": 0,
    "total_lines_removed": 0
  }
}
```

#### 3. Script Execution
- **Input Method**: JSON data piped via stdin
- **Execution Environment**: Sandboxed with limited permissions
- **Working Directory**: Current Claude Code working directory
- **Environment Variables**: `CLAUDE_PROJECT_DIR`, `TMPDIR=/tmp/claude/`
- **Timeout**: Must complete within 300ms to avoid UI blocking

#### 4. Output Processing
- **Display Rule**: Only first line of stdout becomes statusline
- **Character Support**: Full Unicode, ANSI colors, emojis
- **Length Limits**: Terminal width constraints
- **Error Handling**: Failed scripts don't crash Claude Code

## Hook System Integration

### Available Hook Events
```
SessionStart ──┐
               ├── Hook System ──→ Custom Scripts
UserPromptSubmit ──┤
               │
PreToolUse ────┤
               │
PostToolUse ───┤
               │
Status ────────┤  ← Statusline trigger
               │
Notification ──┤
               │
SessionEnd ────┘
```

### Hook Event Data Structures

#### Status Event (Statusline)
```json
{
  "hook_event_name": "Status",
  "session_id": "...",
  "transcript_path": "...",
  "cwd": "...",
  "model": {...},
  "workspace": {...},
  "version": "...",
  "output_style": {...},
  "cost": {...}
}
```

#### PreToolUse Event (Data Collection)
```json
{
  "hook_event_name": "PreToolUse",
  "session_id": "...",
  "transcript_path": "...",
  "cwd": "...",
  "tool_name": "Bash|Read|Write|etc",
  "tool_input": {
    "command": "...",
    "file_path": "...",
    "content": "..."
  }
}
```

#### PostToolUse Event (Result Analysis)
```json
{
  "hook_event_name": "PostToolUse",
  "session_id": "...",
  "transcript_path": "...",
  "cwd": "...",
  "tool_name": "...",
  "tool_input": {...},
  "tool_response": {
    "success": true,
    "output": "...",
    "exitCode": 0
  }
}
```

## Data Augmentation & Interception

### 1. Pre-Processing Data Collection
```bash
# Hook script for behavioral data collection
#!/bin/bash
input=$(cat)
hook_event=$(echo "$input" | jq -r '.hook_event_name')

case "$hook_event" in
  "PreToolUse")
    # Log tool usage for cognitive analysis
    tool_name=$(echo "$input" | jq -r '.tool_name')
    timestamp=$(date +%s)
    session_id=$(echo "$input" | jq -r '.session_id')
    echo "$timestamp,$session_id,$tool_name" >> ~/.claude/cognitive-log.csv
    ;;

  "Status")
    # Access collected data in statusline
    recent_activity=$(tail -5 ~/.claude/cognitive-log.csv | wc -l)
    # Continue with statusline generation...
    ;;
esac
```

### 2. External Data Source Integration
```bash
#!/bin/bash
# Multi-source data integration in statusline
input=$(cat)

# Official Claude Code data
session_id=$(echo "$input" | jq -r '.session_id')
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added')

# External data sources
git_branch=$(git branch --show-current 2>/dev/null || echo "no-repo")
current_time=$(date +"%H:%M")
system_load=$(uptime | awk -F'load average:' '{print $2}' | cut -d, -f1 | xargs)

# Custom cognitive state files
if [ -f ~/.claude/cognitive-state-$session_id.json ]; then
  cognitive_state=$(jq -r '.current_state' ~/.claude/cognitive-state-$session_id.json)
else
  cognitive_state="UNKNOWN"
fi

# Combined output
echo "$cognitive_state | 🌿 $git_branch | ⏰ $current_time | 📊 Load: $system_load"
```

### 3. State Persistence Mechanisms
```bash
#!/bin/bash
# Persistent state management across statusline updates
input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id')
STATE_DIR="$HOME/.claude/state"
SESSION_STATE="$STATE_DIR/session-$session_id.json"

mkdir -p "$STATE_DIR"

# Load previous state
if [ -f "$SESSION_STATE" ]; then
  prev_lines=$(jq -r '.lines_added // 0' "$SESSION_STATE")
  prev_time=$(jq -r '.last_update // 0' "$SESSION_STATE")
  update_count=$(jq -r '.update_count // 0' "$SESSION_STATE")
else
  prev_lines=0
  prev_time=0
  update_count=0
fi

# Current state
current_lines=$(echo "$input" | jq -r '.cost.total_lines_added')
current_time=$(date +%s)
lines_delta=$((current_lines - prev_lines))
time_delta=$((current_time - prev_time))
new_update_count=$((update_count + 1))

# Save updated state
cat > "$SESSION_STATE" << EOF
{
  "lines_added": $current_lines,
  "last_update": $current_time,
  "update_count": $new_update_count,
  "lines_delta": $lines_delta,
  "time_delta": $time_delta
}
EOF

# Display with historical context
echo "📈 +$lines_delta lines | 🔄 Update #$new_update_count | ⏱️ ${time_delta}s ago"
```

## Performance Architecture

### Execution Constraints
- **Time Limit**: 300ms maximum execution time
- **Memory**: Lightweight processing only
- **CPU**: Minimal computational overhead
- **I/O**: Limited file system access, no network calls recommended

### Optimization Strategies

#### 1. Caching Layer
```bash
#!/bin/bash
# Efficient caching for expensive operations
CACHE_DIR="$HOME/.claude/cache"
CACHE_TTL=30  # seconds

get_cached_or_compute() {
  local cache_key="$1"
  local cache_file="$CACHE_DIR/$cache_key"
  local compute_cmd="$2"

  if [ -f "$cache_file" ] && [ $(($(date +%s) - $(stat -f %m "$cache_file"))) -lt $CACHE_TTL ]; then
    cat "$cache_file"
  else
    eval "$compute_cmd" | tee "$cache_file"
  fi
}

# Usage in statusline
git_info=$(get_cached_or_compute "git_info" "git log --oneline -1 2>/dev/null")
system_info=$(get_cached_or_compute "system_info" "uptime | cut -d',' -f1")
```

#### 2. Background Processing
```bash
#!/bin/bash
# Async processing for complex analysis
input=$(cat)

# Fast display (synchronous)
duration=$(echo "$input" | jq -r '.cost.total_duration_ms')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added')

# Complex analysis (asynchronous - don't wait)
{
  session_id=$(echo "$input" | jq -r '.session_id')
  # Expensive cognitive analysis
  # Results saved for next statusline update
} &

# Immediate output
echo "⚡ ${duration}ms | 📝 $lines_added lines"
```

#### 3. Incremental Updates
```bash
#!/bin/bash
# Only recompute when necessary
input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id')
current_lines=$(echo "$input" | jq -r '.cost.total_lines_added')

LAST_LINES_FILE="$HOME/.claude/last-lines-$session_id"

if [ -f "$LAST_LINES_FILE" ]; then
  last_lines=$(cat "$LAST_LINES_FILE")
else
  last_lines=0
fi

# Only update cognitive state if significant change
if [ $((current_lines - last_lines)) -gt 5 ]; then
  # Recompute cognitive state
  echo "$current_lines" > "$LAST_LINES_FILE"
  # Update display
fi
```

## Error Handling & Reliability

### Graceful Degradation
```bash
#!/bin/bash
# Robust error handling
input=$(cat)

# Always provide fallback display
fallback_display() {
  echo "⚡ Claude Code Active"
}

# Try to parse JSON with fallback
if ! duration=$(echo "$input" | jq -r '.cost.total_duration_ms' 2>/dev/null); then
  fallback_display
  exit 0
fi

# Validate data before use
if [ "$duration" = "null" ] || [ -z "$duration" ]; then
  fallback_display
  exit 0
fi

# Continue with normal processing...
```

### Debug Mode Support
```bash
#!/bin/bash
# Debug-aware statusline
input=$(cat)

DEBUG_MODE=${CLAUDE_STATUSLINE_DEBUG:-false}
DEBUG_LOG="$HOME/.claude/statusline-debug.log"

debug_log() {
  if [ "$DEBUG_MODE" = "true" ]; then
    echo "[$(date -Iseconds)] $1" >> "$DEBUG_LOG"
  fi
}

debug_log "Statusline update triggered"
debug_log "Input JSON: $input"

# Normal processing with debug logging...
```

## Integration Points for ADHD Cognitive Analysis

### Real-Time Cognitive State Detection
```bash
#!/bin/bash
# Cognitive state pipeline
input=$(cat)

# Extract behavioral indicators
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms')
api_duration=$(echo "$input" | jq -r '.cost.total_api_duration_ms')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added')

# Calculate cognitive metrics
session_minutes=$((duration_ms / 60000))
cognitive_load=$((api_duration * 100 / duration_ms))
productivity_rate=$(echo "scale=1; $lines_added / $session_minutes" | bc 2>/dev/null || echo "0")

# ADHD-specific state detection
if [ "$duration_ms" -gt 7200000 ]; then  # >2 hours
  cognitive_state="HYPERFOCUS"
  alert="⚠️ BREAK NEEDED"
elif [ "$cognitive_load" -gt 80 ]; then
  cognitive_state="HIGH_LOAD"
  alert="🧠 PROCESSING"
elif [ "$productivity_rate" != "0" ] && [ $(echo "$productivity_rate > 5" | bc) -eq 1 ]; then
  cognitive_state="FLOW"
  alert="⚡ PRODUCTIVE"
else
  cognitive_state="LEARNING"
  alert="📚 EXPLORING"
fi

echo "$alert | State: $cognitive_state | Load: ${cognitive_load}%"
```

This architecture provides the foundation for building sophisticated ADHD-aware cognitive statuslines that can monitor behavioral patterns, detect focus states, and provide real-time feedback while respecting Claude Code's performance constraints and architectural boundaries.