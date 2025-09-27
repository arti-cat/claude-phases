# Claude Code CLI Output Formats

## Overview
Claude Code supports multiple output formats for different use cases, from human-readable text to structured data for programmatic analysis.

## Output Format Types

### 1. Text Format (Default)
**Usage**: Human-readable output for interactive use
**Flag**: `--output-format text` (default)

```bash
claude -p "Explain file src/components/Header.tsx"
```

**Output Example**:
```
This is a React component that renders the main header...
```

**ADHD Applications**:
- Direct reading and comprehension
- Quick feedback for immediate understanding
- Interactive conversation flow

### 2. JSON Format
**Usage**: Structured output with metadata for analysis
**Flag**: `--output-format json`

```bash
claude -p "Analyze this code for bugs" --output-format json
```

**Output Structure**:
```json
{
  "type": "result",
  "subtype": "success",
  "total_cost_usd": 0.003,
  "is_error": false,
  "duration_ms": 1234,
  "duration_api_ms": 800,
  "num_turns": 6,
  "result": "The response text here...",
  "session_id": "abc123"
}
```

**Available Fields**:
- `type`: Response type ("result")
- `subtype`: "success", "error_max_turns", "error_during_execution"
- `total_cost_usd`: Financial cost of the interaction
- `duration_ms`: Total processing time
- `duration_api_ms`: API response time
- `num_turns`: Number of conversation turns
- `result`: Actual response content
- `session_id`: Session identifier
- `is_error`: Boolean error status

**ADHD Applications**:
- Cost tracking per cognitive session
- Performance analysis (response times)
- Session duration monitoring
- Automated data processing

### 3. Stream-JSON Format
**Usage**: Real-time event streaming for live monitoring
**Flag**: `--output-format stream-json`

```bash
cat log.txt | claude -p 'parse this log file for errors' --output-format stream-json
```

**Output Example**:
```json
{"type":"assistant","content":"I'll analyze this log file..."}
{"type":"tool_use","name":"Grep","input":{"pattern":"ERROR"}}
{"type":"tool_result","success":true,"output":"Found 3 errors"}
{"type":"result","subtype":"success","result":"Analysis complete"}
```

**ADHD Applications**:
- Real-time progress monitoring
- Live cognitive load assessment
- Immediate feedback on focus state
- Stream processing for statusline updates

## Data Extraction & Processing

### JSON Parsing Examples

#### Extract Response Content
```bash
result=$(claude -p "Generate code" --output-format json)
code=$(echo "$result" | jq -r '.result')
```

#### Extract Performance Metrics
```bash
cost=$(echo "$result" | jq -r '.total_cost_usd')
duration=$(echo "$result" | jq -r '.duration_ms')
api_time=$(echo "$result" | jq -r '.duration_api_ms')
```

#### Extract Session Information
```bash
session_id=$(echo "$result" | jq -r '.session_id')
turns=$(echo "$result" | jq -r '.num_turns')
```

### Stream Processing Examples

#### Monitor Live Progress
```bash
claude -p "Complex task" --output-format stream-json | \
while IFS= read -r line; do
  event_type=$(echo "$line" | jq -r '.type')
  echo "Event: $event_type at $(date)"
done
```

#### Extract Tool Usage Patterns
```bash
claude -p "Analyze project" --output-format stream-json | \
jq -r 'select(.type == "tool_use") | "\(.name): \(.input | keys[])"'
```

## Cognitive Analysis Applications

### Session Performance Tracking
```bash
# Batch analysis of multiple queries
for query in "task1" "task2" "task3"; do
  result=$(claude -p "$query" --output-format json)
  echo "$query: $(echo "$result" | jq -r '.duration_ms')ms"
done
```

### Cost-per-Focus Analysis
```bash
# Track cognitive efficiency
result=$(claude -p "Focus-intensive task" --output-format json)
cost=$(echo "$result" | jq -r '.total_cost_usd')
duration=$(echo "$result" | jq -r '.duration_ms')
echo "Cost per minute: $(echo "scale=6; $cost / ($duration / 60000)" | bc)"
```

### API Response Time Patterns
```bash
# Collect response times for cognitive load analysis
claude -p "Quick task" --output-format json | jq '.duration_api_ms' >> response_times.log
```

## Integration with Other Data Sources

### Combine with Statusline Data
```bash
#!/bin/bash
# Enhanced statusline with CLI data
input=$(cat)  # Statusline JSON
session_id=$(echo "$input" | jq -r '.session_id')

# Get latest CLI result for session
latest_result=$(claude -p "status check" --output-format json)
cli_duration=$(echo "$latest_result" | jq -r '.duration_ms')

echo "Session: $session_id | Latest: ${cli_duration}ms"
```

### Correlate with Transcript Data
```bash
# Cross-reference CLI results with transcript
result=$(claude -p "Analysis task" --output-format json)
session_id=$(echo "$result" | jq -r '.session_id')
transcript_path="~/.claude/projects/*/$(echo $session_id)*.jsonl"
echo "Result cost: $(echo "$result" | jq -r '.total_cost_usd')"
echo "Transcript location: $transcript_path"
```

## ADHD-Specific Output Processing

### Focus State Assessment
```bash
# Analyze response patterns for focus indicators
result=$(claude -p "$USER_PROMPT" --output-format json)
api_ratio=$(echo "$result" | jq -r '(.duration_api_ms / .duration_ms) * 100')

if (( $(echo "$api_ratio > 80" | bc -l) )); then
  echo "High cognitive load detected"
elif (( $(echo "$api_ratio < 20" | bc -l) )); then
  echo "Processing delay - possible distraction"
else
  echo "Normal cognitive processing"
fi
```

### Energy Level Detection
```bash
# Track response speed over time
for i in {1..5}; do
  start_time=$(date +%s%3N)
  result=$(claude -p "Simple task $i" --output-format json)
  end_time=$(date +%s%3N)

  total_time=$((end_time - start_time))
  api_time=$(echo "$result" | jq -r '.duration_api_ms')

  echo "Task $i: Total ${total_time}ms, API ${api_time}ms"
done
```

### Session Efficiency Metrics
```bash
# Calculate cognitive efficiency over session
session_start=$(date +%s)
total_cost=0
total_tasks=0

for task in "${tasks[@]}"; do
  result=$(claude -p "$task" --output-format json)
  cost=$(echo "$result" | jq -r '.total_cost_usd')
  total_cost=$(echo "$total_cost + $cost" | bc)
  ((total_tasks++))
done

session_duration=$(( $(date +%s) - session_start ))
echo "Session efficiency: $total_tasks tasks in ${session_duration}s"
echo "Average cost per task: $(echo "scale=6; $total_cost / $total_tasks" | bc)"
```

## Error Handling & Edge Cases

### Handle Error Responses
```bash
result=$(claude -p "Task" --output-format json)
is_error=$(echo "$result" | jq -r '.is_error')

if [ "$is_error" = "true" ]; then
  subtype=$(echo "$result" | jq -r '.subtype')
  echo "Error type: $subtype"
else
  echo "Success: $(echo "$result" | jq -r '.result')"
fi
```

### Stream Processing Error Handling
```bash
claude -p "Task" --output-format stream-json | \
while IFS= read -r line; do
  if echo "$line" | jq -e '.type == "error"' > /dev/null; then
    echo "Error detected: $(echo "$line" | jq -r '.message')"
    break
  fi
done
```

## Best Practices

### Performance Optimization
- Use stream-json for real-time monitoring
- Cache JSON results to avoid repeated parsing
- Process large datasets in batches

### Data Privacy
- JSON format may contain sensitive information
- Filter output before logging
- Consider data retention policies

### Integration Patterns
- Combine multiple formats for comprehensive analysis
- Use JSON for automation, text for human review
- Stream-json for real-time cognitive monitoring