# Adding Custom Data & ASCII to Claude Code Statusline

## Overview
You can extensively customize Claude Code's statusline by combining Anthropic's official JSON data with your own custom data sources, ASCII art, colors, and real-time information.

## How the Statusline System Works

### Architecture
```
Claude Code → JSON Data → Your Script → stdout → Statusline Display
    ↓              ↓            ↓           ↓
Session State → stdin pipe → Processing → First line only
```

### Update Mechanism
- **Trigger**: Conversation changes (user input, responses, tool calls)
- **Frequency**: Maximum 300ms intervals
- **Data Flow**: JSON via stdin → script processing → stdout to display
- **Constraint**: Only first line of stdout becomes the statusline

## Official Anthropic Data Available

```json
{
  "hook_event_name": "Status",
  "session_id": "abc123...",
  "transcript_path": "/path/to/conversation.jsonl",
  "cwd": "/current/working/directory",
  "model": {
    "id": "claude-3-5-sonnet-20241022",
    "display_name": "Claude 3.5 Sonnet"
  },
  "workspace": {
    "current_dir": "/current/working/directory",
    "project_dir": "/original/project/directory"
  },
  "version": "1.2.34",
  "output_style": {
    "name": "default"
  },
  "cost": {
    "total_cost_usd": 0.12345,
    "total_duration_ms": 145000,
    "total_api_duration_ms": 23450,
    "total_lines_added": 156,
    "total_lines_removed": 23
  }
}
```

## Adding Custom Data Sources

### 1. Git Information
```bash
#!/bin/bash
input=$(cat)

# Get official Claude data
session_duration=$(echo "$input" | jq -r '.cost.total_duration_ms')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added')

# Add custom git data
git_branch=$(git branch --show-current 2>/dev/null || echo "no-git")
git_status=$(git status --porcelain 2>/dev/null | wc -l)

echo "🌿 $git_branch ($git_status) | ⏱️ ${session_duration}ms | 📝 $lines_added lines"
```

### 2. Time-Based Information
```bash
#!/bin/bash
input=$(cat)

# Official data
model=$(echo "$input" | jq -r '.model.display_name')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd')

# Custom time data
current_time=$(date +"%H:%M")
weekday=$(date +"%a")

echo "⏰ $weekday $current_time | 🤖 $model | 💰 \$$(printf '%.4f' $cost)"
```

### 3. System Metrics
```bash
#!/bin/bash
input=$(cat)

# Official cognitive data
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms')
api_duration=$(echo "$input" | jq -r '.cost.total_api_duration_ms')

# Custom system data
cpu_usage=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | cut -d% -f1)
memory_pressure=$(memory_pressure | grep "System-wide memory free percentage" | awk '{print $5}')

echo "🧠 ${duration_ms}ms | ⚡ API:${api_duration}ms | 💻 CPU:${cpu_usage}% | 🎯 Mem:${memory_pressure}%"
```

### 4. File System Context
```bash
#!/bin/bash
input=$(cat)

# Official data
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
project_dir=$(echo "$input" | jq -r '.workspace.project_dir')

# Custom file system data
dir_name=$(basename "$current_dir")
file_count=$(ls -1 | wc -l)
git_files_changed=$(git status --porcelain 2>/dev/null | wc -l)

echo "📁 $dir_name ($file_count files) | 🔄 $git_files_changed changed"
```

## ANSI Colors & ASCII Art Support

### Full Color Support
```bash
#!/bin/bash
input=$(cat)
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms')

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Color-coded status based on session duration
if [ "$duration_ms" -gt 7200000 ]; then  # >2 hours
  status="${RED}🔥 HYPERFOCUS${NC}"
elif [ "$duration_ms" -gt 1800000 ]; then  # >30 min
  status="${GREEN}⚡ FOCUSED${NC}"
else
  status="${BLUE}📚 LEARNING${NC}"
fi

echo -e "$status | ${CYAN}$(date +%H:%M)${NC} | ${YELLOW}$(basename $(pwd))${NC}"
```

### ASCII Art Integration
```bash
#!/bin/bash
input=$(cat)
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added')

# ASCII progress bars
if [ "$lines_added" -gt 100 ]; then
  progress="████████████"
elif [ "$lines_added" -gt 50 ]; then
  progress="████████░░░░"
elif [ "$lines_added" -gt 20 ]; then
  progress="████░░░░░░░░"
else
  progress="█░░░░░░░░░░░"
fi

echo "📊 [$progress] $lines_added lines"
```

### Unicode & Emoji Support
```bash
#!/bin/bash
input=$(cat)
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added')

# Unicode box drawing characters
border="┃"
separator="┊"

# Emoji based on productivity
if [ "$lines_added" -gt 50 ]; then
  mood="🚀"
elif [ "$lines_added" -gt 20 ]; then
  mood="⚡"
elif [ "$lines_added" -gt 5 ]; then
  mood="✨"
else
  mood="🌱"
fi

echo "$border $mood $separator $(( duration_ms / 60000 ))m $separator $lines_added lines $border"
```

## Persistent State & Data Collection

### State Persistence Between Updates
```bash
#!/bin/bash
input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id')
STATE_FILE="$HOME/.claude/statusline-state-$session_id.json"

# Load previous state
if [ -f "$STATE_FILE" ]; then
  prev_lines=$(jq -r '.lines_added // 0' "$STATE_FILE")
else
  prev_lines=0
fi

# Current state
current_lines=$(echo "$input" | jq -r '.cost.total_lines_added')
lines_delta=$((current_lines - prev_lines))

# Save state
echo "{\"lines_added\": $current_lines, \"last_update\": \"$(date -Iseconds)\"}" > "$STATE_FILE"

# Display with delta
if [ "$lines_delta" -gt 0 ]; then
  echo "📈 +$lines_delta lines | Total: $current_lines"
else
  echo "📝 $current_lines lines"
fi
```

### Hook-Based Data Collection
```bash
#!/bin/bash
# Save this as ~/.claude/hooks/cognitive-tracker.sh
input=$(cat)
hook_event=$(echo "$input" | jq -r '.hook_event_name')

case "$hook_event" in
  "PreToolUse")
    tool_name=$(echo "$input" | jq -r '.tool_name')
    timestamp=$(date +%s)
    echo "$timestamp,$tool_name" >> ~/.claude/tool-usage.log
    ;;
  "Status")
    # Use collected data in statusline
    recent_tools=$(tail -10 ~/.claude/tool-usage.log 2>/dev/null | wc -l)
    duration=$(echo "$input" | jq -r '.cost.total_duration_ms')
    echo "🔧 $recent_tools tools | ⏱️ ${duration}ms"
    ;;
esac
```

## Advanced ADHD Cognitive Integration

### Multi-Source Cognitive Assessment
```bash
#!/bin/bash
input=$(cat)

# Official Anthropic data
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added')
api_duration=$(echo "$input" | jq -r '.cost.total_api_duration_ms')

# Custom behavioral data
session_minutes=$((duration_ms / 60000))
productivity_rate=$(echo "scale=1; $lines_added / $session_minutes" | bc 2>/dev/null || echo "0")
cognitive_load=$(echo "scale=0; $api_duration * 100 / $duration_ms" | bc 2>/dev/null || echo "0")

# Time-based circadian awareness
current_hour=$(date +%H)
if [ "$current_hour" -ge 9 ] && [ "$current_hour" -le 11 ]; then
  circadian="🌅 PEAK"
elif [ "$current_hour" -ge 14 ] && [ "$current_hour" -le 16 ]; then
  circadian="☀️ GOOD"
else
  circadian="🌙 LOW"
fi

# Hyperfocus detection
if [ "$duration_ms" -gt 7200000 ]; then
  warning=" ⚠️ BREAK!"
else
  warning=""
fi

echo "$circadian | 🧠 ${cognitive_load}% load | 📈 ${productivity_rate}/min$warning"
```

### Historical Pattern Integration
```bash
#!/bin/bash
input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id')
HISTORY_FILE="$HOME/.claude/session-history.csv"

# Current session data
current_duration=$(echo "$input" | jq -r '.cost.total_duration_ms')
current_lines=$(echo "$input" | jq -r '.cost.total_lines_added')

# Calculate averages from history
if [ -f "$HISTORY_FILE" ]; then
  avg_duration=$(awk -F, '{sum+=$2; count++} END {print (count>0) ? int(sum/count) : 0}' "$HISTORY_FILE")
  avg_lines=$(awk -F, '{sum+=$3; count++} END {print (count>0) ? int(sum/count) : 0}' "$HISTORY_FILE")

  # Compare to personal baseline
  if [ "$current_duration" -gt $((avg_duration * 150 / 100)) ]; then
    duration_trend="📈"
  elif [ "$current_duration" -lt $((avg_duration * 50 / 100)) ]; then
    duration_trend="📉"
  else
    duration_trend="➡️"
  fi
else
  duration_trend="🆕"
fi

echo "$duration_trend $((current_duration/60000))m | 📝 $current_lines lines | 📊 vs avg: ${avg_duration:-0}ms"

# Update history on session end (implement in SessionEnd hook)
```

## Performance Optimization

### Efficient Data Access
```bash
#!/bin/bash
input=$(cat)

# Cache expensive operations
CACHE_FILE="/tmp/claude-statusline-cache"
CACHE_TIMEOUT=30  # seconds

if [ -f "$CACHE_FILE" ] && [ $(($(date +%s) - $(stat -f %m "$CACHE_FILE"))) -lt $CACHE_TIMEOUT ]; then
  # Use cached data
  cached_data=$(cat "$CACHE_FILE")
else
  # Expensive operation (git, system metrics, etc.)
  cached_data=$(git log --oneline -1 2>/dev/null || echo "no-git")
  echo "$cached_data" > "$CACHE_FILE"
fi

# Combine with real-time Claude data
duration=$(echo "$input" | jq -r '.cost.total_duration_ms')
echo "🌿 $cached_data | ⏱️ ${duration}ms"
```

### Async Background Processing
```bash
#!/bin/bash
input=$(cat)

# Quick display (always under 300ms)
duration=$(echo "$input" | jq -r '.cost.total_duration_ms')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added')

# Start background analysis (don't wait for it)
{
  session_id=$(echo "$input" | jq -r '.session_id')
  # Complex cognitive analysis here
  # Results saved for next update
} &

echo "⚡ ${duration}ms | 📝 $lines_added lines"
```

## Configuration & Setup

### Settings File Integration
```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/cognitive-statusline.sh",
    "padding": 0
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/cognitive-tracker.sh"
          }
        ]
      }
    ]
  }
}
```

### Multiple Language Support
**Python Example:**
```python
#!/usr/bin/env python3
import json
import sys
import subprocess
from datetime import datetime

# Read official Claude data
data = json.load(sys.stdin)
duration_ms = data['cost']['total_duration_ms']
lines_added = data['cost']['total_lines_added']

# Add custom git data
try:
    branch = subprocess.check_output(['git', 'branch', '--show-current'],
                                   stderr=subprocess.DEVNULL).decode().strip()
except:
    branch = "no-git"

# ADHD-aware formatting
session_hours = duration_ms / 3600000
if session_hours > 2:
    status = "🔥 HYPERFOCUS"
elif session_hours > 0.5:
    status = "⚡ FOCUSED"
else:
    status = "📚 LEARNING"

print(f"{status} | 🌿 {branch} | 📝 {lines_added} lines | ⏰ {datetime.now():%H:%M}")
```

This comprehensive system allows you to create rich, personalized statuslines that combine Claude Code's official session data with your own custom information, ASCII art, colors, and real-time cognitive assessment for ADHD awareness.