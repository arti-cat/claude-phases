# ADHD Cognitive Data Mapping & Analysis

## Overview
This document maps Claude Code's data outputs to specific ADHD cognitive patterns and provides analysis frameworks for building cognitive-aware statuslines and monitoring systems.

## Core Cognitive States & Data Sources

### 1. Focus State Detection

#### Primary Indicators
**Session Duration** (from Statusline JSON):
```json
"cost.total_duration_ms": 145000  // 2.4 minutes
```

**Context Switching** (from Hook Logs):
```bash
# Count directory changes per session
grep "cd " ~/.claude/bash-command-log.txt | wc -l
```

**Task Persistence** (from Transcript Analysis):
```bash
# Measure time between file operations
grep '"tool_name":"Write"' transcript.jsonl | jq -r '.timestamp'
```

#### Analysis Framework
```bash
#!/bin/bash
# Focus State Calculator
duration_ms=$(echo "$statusline_json" | jq -r '.cost.total_duration_ms')
dir_changes=$(grep "cd " ~/.claude/bash-command-log.txt | wc -l)
files_touched=$(grep '"tool_name":"Write"' transcript.jsonl | wc -l)

# Focus Score (0-100)
if [ "$duration_ms" -gt 3600000 ] && [ "$dir_changes" -lt 3 ]; then
  echo "HYPERFOCUS (95)"
elif [ "$duration_ms" -gt 1800000 ] && [ "$dir_changes" -lt 5 ]; then
  echo "DEEP_FOCUS (80)"
elif [ "$duration_ms" -gt 600000 ]; then
  echo "FOCUSED (60)"
else
  echo "SCATTERED (30)"
fi
```

### 2. Energy Level Assessment

#### Primary Indicators
**Productivity Velocity** (from Statusline JSON):
```json
"cost.total_lines_added": 156,
"cost.total_lines_removed": 23,
"cost.total_duration_ms": 145000
```

**API Response Patterns** (from CLI JSON Output):
```json
"duration_api_ms": 800,
"duration_ms": 1234
```

**Tool Usage Intensity** (from Hook Logs):
```bash
# Tools per minute calculation
total_tools=$(grep "Tool:" ~/.claude/tool-usage.log | wc -l)
session_minutes=$(( duration_ms / 60000 ))
intensity=$(( total_tools / session_minutes ))
```

#### Energy Level Calculator
```bash
#!/bin/bash
# Energy Assessment Algorithm
lines_per_minute=$(echo "scale=2; $lines_added / ($duration_ms / 60000)" | bc)
api_efficiency=$(echo "scale=2; $duration_api_ms / $duration_ms * 100" | bc)

if (( $(echo "$lines_per_minute > 10" | bc -l) )); then
  echo "HIGH_ENERGY (90)"
elif (( $(echo "$lines_per_minute > 5" | bc -l) )); then
  echo "MODERATE_ENERGY (70)"
elif (( $(echo "$lines_per_minute > 1" | bc -l) )); then
  echo "LOW_ENERGY (40)"
else
  echo "FATIGUE (20)"
fi
```

### 3. Context Switching Analysis

#### Data Sources
**Directory Navigation** (from Bash Command Logs):
```bash
grep "cd \|pushd \|popd " ~/.claude/bash-command-log.txt
```

**File Access Patterns** (from Tool Logs):
```bash
grep '"tool_name":"Read"' transcript.jsonl | jq -r '.tool_input.file_path'
```

**Project Boundary Crossing** (from Statusline JSON):
```json
"workspace.current_dir": "/home/user/project-a",
"workspace.project_dir": "/home/user/project-b"
```

#### Context Switch Metrics
```bash
#!/bin/bash
# Context Switching Analysis
current_dir=$(echo "$statusline_json" | jq -r '.workspace.current_dir')
project_dir=$(echo "$statusline_json" | jq -r '.workspace.project_dir')

# Directory stability score
if [ "$current_dir" = "$project_dir" ]; then
  dir_stability=100
else
  # Calculate distance from project root
  dir_depth=$(echo "$current_dir" | tr '/' '\n' | wc -l)
  project_depth=$(echo "$project_dir" | tr '/' '\n' | wc -l)
  dir_stability=$(( 100 - (dir_depth - project_depth) * 10 ))
fi

echo "Directory Stability: $dir_stability%"
```

### 4. Hyperfocus Detection

#### Warning Thresholds
- **Duration**: >2 hours (7,200,000ms)
- **Minimal Context Switching**: <3 directory changes
- **High Tool Usage**: >30 operations/hour
- **Consistent API Timing**: <20% variance in response times

#### Hyperfocus Detection Algorithm
```bash
#!/bin/bash
# Hyperfocus Warning System
duration_ms=$(echo "$statusline_json" | jq -r '.cost.total_duration_ms')
session_hours=$(echo "scale=2; $duration_ms / 3600000" | bc)

# Check multiple indicators
dir_changes=$(grep "cd " ~/.claude/bash-command-log.txt | wc -l)
tool_usage=$(grep "Tool:" ~/.claude/tool-usage.log | wc -l)
tools_per_hour=$(echo "scale=0; $tool_usage / $session_hours" | bc)

# Hyperfocus criteria
if (( $(echo "$session_hours > 2" | bc -l) )) &&
   [ "$dir_changes" -lt 3 ] &&
   (( $(echo "$tools_per_hour > 30" | bc -l) )); then
  echo "⚠️ HYPERFOCUS DETECTED - Consider taking a break"
  echo "Session: ${session_hours}h | Switches: $dir_changes | Activity: $tools_per_hour/h"
fi
```

## Data Correlation Patterns

### 1. Cognitive Load Indicators

#### High Cognitive Load Signs
- API response time >1000ms
- Decreased lines added per minute
- Increased error rates in tool usage
- Longer gaps between user prompts

```bash
# Cognitive Load Assessment
api_ratio=$(echo "scale=2; $duration_api_ms / $duration_ms * 100" | bc)
if (( $(echo "$api_ratio > 80" | bc -l) )); then
  echo "HIGH_COGNITIVE_LOAD"
fi
```

#### Low Cognitive Load Signs
- Fast API responses <500ms
- Consistent tool usage patterns
- High lines added/removed ratio
- Steady interaction rhythm

### 2. Attention Sustainability Metrics

#### Sustained Attention Indicators
```bash
# Attention Span Calculator
session_start=$(head -1 transcript.jsonl | jq -r '.timestamp')
session_end=$(tail -1 transcript.jsonl | jq -r '.timestamp')

# Calculate gaps between interactions
jq -r '.timestamp' transcript.jsonl | \
awk 'NR>1{print ($1 - prev)} {prev=$1}' | \
awk '{sum+=$1; if($1>300) gaps++} END{print "Avg gap:", sum/NR, "Long gaps:", gaps}'
```

#### Attention Fragmentation Detection
```bash
# Fragmentation Score (0-100, lower is more fragmented)
total_interactions=$(wc -l < transcript.jsonl)
long_gaps=$(jq -r '.timestamp' transcript.jsonl | \
           awk 'NR>1{if($1-prev > 300) count++} {prev=$1} END{print count+0}')

fragmentation_score=$(( 100 - (long_gaps * 100 / total_interactions) ))
echo "Attention Continuity: $fragmentation_score%"
```

## Real-time Cognitive State Monitoring

### Statusline Integration Example
```bash
#!/bin/bash
# Cognitive State Statusline
input=$(cat)

# Extract base metrics
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')

# Calculate cognitive indicators
session_minutes=$(( duration_ms / 60000 ))
productivity=$(echo "scale=1; $lines_added / $session_minutes" | bc)

# Get context switching data
dir_changes=$(grep "cd " ~/.claude/bash-command-log.txt 2>/dev/null | wc -l)

# Determine cognitive state
if [ "$session_minutes" -gt 120 ] && [ "$dir_changes" -lt 3 ]; then
  state="🔥 HYPERFOCUS"
elif [ "$session_minutes" -gt 30 ] && (( $(echo "$productivity > 5" | bc -l) )); then
  state="⚡ FLOW"
elif [ "$dir_changes" -gt 10 ]; then
  state="🌀 SCATTERED"
else
  state="📚 LEARNING"
fi

# Display with metrics
echo "$state ${session_minutes}m | ${productivity} lines/min | 📁 ${current_dir##*/}"
```

## Historical Pattern Analysis

### Session Pattern Recognition
```bash
#!/bin/bash
# Analyze historical patterns from transcript files
for transcript in ~/.claude/projects/*/*.jsonl; do
  if [ -f "$transcript" ]; then
    session_id=$(basename "$transcript" .jsonl)
    start_time=$(head -1 "$transcript" | jq -r '.timestamp')
    end_time=$(tail -1 "$transcript" | jq -r '.timestamp')

    duration=$(( $(date -d "$end_time" +%s) - $(date -d "$start_time" +%s) ))
    tool_count=$(grep '"type":"tool_call"' "$transcript" | wc -l)

    echo "$session_id,$duration,$tool_count"
  fi
done | sort -t, -k2 -nr > session_patterns.csv
```

### Weekly Cognitive Trends
```bash
#!/bin/bash
# Weekly pattern analysis
awk -F, '
BEGIN { print "Week,Avg_Duration,Avg_Tools,Sessions" }
{
  week = strftime("%Y-W%U", $2)
  duration[week] += $2
  tools[week] += $3
  count[week]++
}
END {
  for (w in duration) {
    printf "%s,%.0f,%.1f,%d\n", w, duration[w]/count[w], tools[w]/count[w], count[w]
  }
}' session_patterns.csv | sort
```

## Intervention Triggers

### Break Reminders
```bash
# Hyperfocus intervention
if [ "$duration_ms" -gt 7200000 ]; then  # 2 hours
  echo "🚨 Break recommended - You've been coding for 2+ hours"
fi
```

### Focus Optimization
```bash
# Context switching intervention
if [ "$dir_changes" -gt 15 ]; then
  echo "💡 High context switching detected - Consider task batching"
fi
```

### Energy Management
```bash
# Energy level intervention
if (( $(echo "$productivity < 1" | bc -l) )) && [ "$session_minutes" -gt 30 ]; then
  echo "🔋 Low productivity detected - Consider break or task switch"
fi
```

## Data Export & Analysis

### CSV Export for Analysis
```bash
#!/bin/bash
# Export cognitive metrics to CSV
echo "timestamp,session_id,duration_minutes,lines_added,dir_changes,cognitive_state"

for transcript in ~/.claude/projects/*/*.jsonl; do
  # Extract and calculate metrics
  # Output CSV row
done > cognitive_metrics.csv
```

### Integration with External Tools
```bash
# Send metrics to external monitoring
curl -X POST http://monitoring-endpoint/metrics \
  -H "Content-Type: application/json" \
  -d "{
    \"session_id\": \"$session_id\",
    \"cognitive_state\": \"$state\",
    \"focus_score\": $focus_score,
    \"energy_level\": $energy_level,
    \"timestamp\": \"$(date -Iseconds)\"
  }"
```