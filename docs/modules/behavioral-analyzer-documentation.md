# Behavioral Analyzer Module Documentation

**File**: `/home/bch/.claude/modules/behavioral-analyzer.sh`
**Size**: 8.0k (228 lines)
**Purpose**: ADHD behavioral pattern recognition through tool velocity, task switching, and error pattern analysis

## 🎯 Core Function

Processes hook logs to identify ADHD-specific behavioral patterns including tool velocity, task switching frequency, error patterns, and fatigue indicators for comprehensive cognitive state assessment.

## 📁 Log Files

```bash
~/.claude/logs/
├── context-switching.log  # Tool usage events (PRE_USE, POST_USE)
└── bash-commands.log      # Command history with success/failure tracking
```

## 🚀 CLI Commands

### Analysis Commands
```bash
# Tool velocity analysis
~/.claude/modules/behavioral-analyzer.sh velocity session-123 3600

# Task switching behavior
~/.claude/modules/behavioral-analyzer.sh switching session-123 3600

# Error pattern analysis
~/.claude/modules/behavioral-analyzer.sh errors session-123 3600

# Comprehensive behavioral assessment
~/.claude/modules/behavioral-analyzer.sh assessment session-123 3600
```

### Time Window Variations
```bash
# Last 30 minutes (1800 seconds)
~/.claude/modules/behavioral-analyzer.sh assessment current-session 1800

# Last 2 hours (7200 seconds)
~/.claude/modules/behavioral-analyzer.sh velocity session-123 7200

# Default 1 hour if not specified
~/.claude/modules/behavioral-analyzer.sh switching current-session
```

## 📊 Data Formats

### Input: Log Entry Formats
```bash
# context-switching.log (tool usage tracking)
timestamp,session_id,event_type,tool_name,success_flag
1699123456,current-session,PRE_USE,grep_tool
1699123500,current-session,POST_USE,grep_tool,true
1699123600,current-session,POST_USE,edit_tool,false

# bash-commands.log (command tracking)
timestamp,session_id,command,exit_code
1699123456,current-session,ls -la,0
1699123500,current-session,grep "pattern" file.txt,0
1699123600,current-session,invalid-command,127
```

### Output: Tool Velocity Analysis
```json
{
    "tool_velocity": 2.3,
    "error_rate": 8.5,
    "pattern": "stable",
    "tool_count": 23
}
```

### Output: Task Switching Analysis
```json
{
    "switch_frequency": 5.2,
    "attention_span": 11.5,
    "focus_quality": "moderate",
    "switch_count": 7
}
```

### Output: Error Pattern Analysis
```json
{
    "syntax_errors": 2,
    "retry_rate": 15.5,
    "fatigue_indicators": ["high_retry_rate"],
    "total_commands": 45
}
```

### Output: Comprehensive Assessment
```json
{
    "session_id": "current-session",
    "time_window": 3600,
    "timestamp": 1699123456,
    "tool_velocity": {
        "tool_velocity": 2.3,
        "error_rate": 8.5,
        "pattern": "stable",
        "tool_count": 23
    },
    "task_switching": {
        "switch_frequency": 5.2,
        "attention_span": 11.5,
        "focus_quality": "moderate",
        "switch_count": 7
    },
    "error_patterns": {
        "syntax_errors": 2,
        "retry_rate": 15.5,
        "fatigue_indicators": ["high_retry_rate"],
        "total_commands": 45
    }
}
```

## 🔧 Key Functions

### `analyze_tool_velocity(session_id, time_window)`
- **Purpose**: Detect energy levels and cognitive patterns through tool usage speed
- **Metrics**:
  - **Tool Velocity**: Tools used per minute (0-5+ typical range)
  - **Error Rate**: Percentage of failed tool operations
  - **Tool Count**: Total tools used in window
- **Behavioral Patterns**:
  - **"hyperactive"**: velocity >3.0 - rapid tool switching, possible manic state
  - **"scattered"**: velocity >1.5 + error_rate >15% - unfocused rushing
  - **"low_energy"**: velocity <0.5 - cognitive fatigue or depression
  - **"fatigue"**: error_rate >25% - mental exhaustion
  - **"stable"**: balanced velocity and error rate
- **ADHD Features**: Identifies hyperfocus bursts vs. scattered attention patterns

### `analyze_task_switching(session_id, time_window)`
- **Purpose**: Measure attention span and focus quality through context switches
- **Metrics**:
  - **Switch Frequency**: Context switches per hour
  - **Attention Span**: Average time between switches (minutes)
  - **Switch Count**: Total context switches in window
- **Focus Quality Categories**:
  - **"hyperfocus"**: 0 switches - extended single-task focus
  - **"focused"**: ≤2 switches - sustained attention
  - **"moderate"**: 3-5 switches - normal development flow
  - **"scattered"**: 6-10 switches - elevated task switching
  - **"chaotic"**: >10 switches - severe attention fragmentation
- **ADHD Features**: Detects hyperfocus episodes and attention regulation issues

### `analyze_error_patterns(session_id, time_window)`
- **Purpose**: Identify fatigue and cognitive overload through error analysis
- **Error Types**:
  - **Syntax Errors**: Command syntax mistakes
  - **Command Not Found**: Typing errors, tool confusion
  - **Permission Denied**: Context switching confusion
- **Fatigue Indicators**:
  - **"high_syntax_errors"**: >3 syntax errors - cognitive fatigue
  - **"high_retry_rate"**: >20% retry rate - working memory issues
  - **"command_overload"**: >50 commands - possible hyperfocus/overwhelm
- **ADHD Features**: Correlates error patterns with attention regulation difficulties

### `generate_behavioral_assessment(session_id, time_window)`
- **Purpose**: Comprehensive analysis combining all behavioral dimensions
- **Integration**: Combines velocity, switching, and error analyses
- **Output**: Complete behavioral profile for cognitive state assessment

## 🧠 ADHD-Specific Features

### Hyperactivity Detection
- **Tool Velocity >3.0**: Rapid task switching indicative of hyperactive episodes
- **High Switch Frequency**: Difficulty sustaining attention on single tasks
- **Command Overload**: >50 commands may indicate hyperfocus or manic productivity

### Inattention Indicators
- **Low Tool Velocity <0.5**: Possible cognitive fatigue or depression
- **High Error Rate >25%**: Working memory difficulties
- **Scattered Pattern**: High velocity + high errors = unfocused rushing

### Hyperfocus Recognition
- **Zero Context Switches**: Extended single-task focus
- **Sustained High Velocity**: Consistent tool usage without breaks
- **Low Error Rate**: High accuracy during focused periods

### Fatigue Assessment
- **Increasing Error Rate**: Cognitive resources depleting over time
- **Retry Patterns**: Repeated commands indicate working memory issues
- **Syntax Error Clustering**: Multiple syntax errors suggest mental exhaustion

## 🔌 Integration Points

### With Context Switching Analyzer
```bash
# Enhanced context analysis
enhanced_data=$(~/.claude/modules/context-switching-analyzer.sh current enhanced 3600)
behavioral_data=$(echo "$enhanced_data" | jq '.behavioral_analysis')
context_data=$(echo "$enhanced_data" | jq '.context_analysis')
```

### With Energy Assessment
```bash
# Get behavioral pattern for energy calculation
assessment=$(~/.claude/modules/behavioral-analyzer.sh assessment current-session 3600)
pattern=$(echo "$assessment" | jq -r '.tool_velocity.pattern')
error_rate=$(echo "$assessment" | jq -r '.tool_velocity.error_rate')

# Use in energy penalty calculations
if [[ "$pattern" == "fatigue" ]]; then
    energy_penalty=0.6
elif [[ "$pattern" == "scattered" ]]; then
    energy_penalty=0.8
fi
```

### With Main Statusline
```bash
# Get behavioral assessment for statusline display
assessment=$(~/.claude/modules/behavioral-analyzer.sh assessment current-session 3600)

# Extract key indicators
velocity=$(echo "$assessment" | jq -r '.tool_velocity.tool_velocity')
focus_quality=$(echo "$assessment" | jq -r '.task_switching.focus_quality')
fatigue_indicators=$(echo "$assessment" | jq -r '.error_patterns.fatigue_indicators[]')

# Display behavioral state
echo "Behavior: velocity=$velocity focus=$focus_quality"
```

## 💡 Usage Examples

### Basic Pattern Recognition
```bash
# Analyze current session behavior
~/.claude/modules/behavioral-analyzer.sh assessment current-session 3600

# Output:
{
    "session_id": "current-session",
    "time_window": 3600,
    "tool_velocity": {
        "tool_velocity": 2.3,
        "error_rate": 8.5,
        "pattern": "stable"
    },
    "task_switching": {
        "switch_frequency": 5.2,
        "focus_quality": "moderate"
    },
    "error_patterns": {
        "syntax_errors": 2,
        "retry_rate": 15.5,
        "fatigue_indicators": ["high_retry_rate"]
    }
}
```

### Pattern-Based Interventions
```bash
# Check for hyperactive patterns
assessment=$(~/.claude/modules/behavioral-analyzer.sh assessment current-session 1800)
pattern=$(echo "$assessment" | jq -r '.tool_velocity.pattern')
velocity=$(echo "$assessment" | jq -r '.tool_velocity.tool_velocity')

if [[ "$pattern" == "hyperactive" ]]; then
    echo "⚡ Hyperactive pattern detected - consider taking a break"
elif [[ "$pattern" == "scattered" ]]; then
    echo "💫 Scattered attention - try focusing on single task"
elif [[ "$pattern" == "fatigue" ]]; then
    echo "😴 Fatigue detected - consider rest or easier tasks"
fi
```

### Focus Quality Assessment
```bash
# Analyze attention span and focus quality
switching_data=$(~/.claude/modules/behavioral-analyzer.sh switching current-session 3600)
focus_quality=$(echo "$switching_data" | jq -r '.focus_quality')
attention_span=$(echo "$switching_data" | jq -r '.attention_span')

case "$focus_quality" in
    "hyperfocus")
        echo "🔥 Hyperfocus detected - remember to take breaks"
        ;;
    "focused")
        echo "🎯 Good focus - maintain current approach"
        ;;
    "scattered")
        echo "💫 Scattered attention - try reducing distractions"
        ;;
    "chaotic")
        echo "🌀 High fragmentation - intervention recommended"
        ;;
esac
```

### Fatigue Monitoring
```bash
# Monitor cognitive fatigue indicators
error_data=$(~/.claude/modules/behavioral-analyzer.sh errors current-session 3600)
fatigue_indicators=$(echo "$error_data" | jq -r '.fatigue_indicators[]' 2>/dev/null)
error_rate=$(echo "$error_data" | jq -r '.retry_rate')

if [[ -n "$fatigue_indicators" ]]; then
    echo "⚠️ Fatigue indicators detected: $fatigue_indicators"
    if (( $(echo "$error_rate > 20" | bc -l) )); then
        echo "📉 High retry rate ($error_rate%) - working memory strain"
    fi
fi
```

## 📈 Algorithm Details

### Tool Velocity Calculation
```bash
# Tools per minute calculation
velocity = (tool_count * 60) / time_window_seconds

# Error rate calculation
error_rate = (error_count * 100) / tool_count

# Pattern classification
if velocity > 3.0:
    pattern = "hyperactive"
elif velocity > 1.5 && error_rate > 15:
    pattern = "scattered"
elif velocity < 0.5:
    pattern = "low_energy"
elif error_rate > 25:
    pattern = "fatigue"
else:
    pattern = "stable"
```

### Attention Span Calculation
```bash
# Average time between context switches
if switch_count > 1:
    attention_span = time_window / switch_count / 60  # Convert to minutes
elif switch_count == 0:
    attention_span = time_window / 60  # Full window = one long focus period
```

### Focus Quality Assessment
```bash
if switch_count == 0:
    focus_quality = "hyperfocus"
elif switch_count <= 2:
    focus_quality = "focused"
elif switch_count <= 5:
    focus_quality = "moderate"
elif switch_count <= 10:
    focus_quality = "scattered"
else:
    focus_quality = "chaotic"
```

## ⚠️ Error Conditions

### Missing Log Files
- **No Logs**: Returns default structure with zero values
- **Empty Logs**: Processes available data, returns minimal metrics
- **Corrupt Entries**: Skips malformed lines, continues processing

### Invalid Sessions
- **Unknown Session**: Processes all available data matching timeframe
- **No Matching Data**: Returns zero metrics with valid structure

### Mathematical Edge Cases
- **Division by Zero**: Protected by conditional checks
- **bc Unavailable**: Falls back to integer arithmetic where possible

## 🎨 Visual Integration

### Pattern Indicators
```bash
# Behavioral pattern emoji mapping
case "$pattern" in
    "hyperactive") echo "⚡" ;;
    "scattered")   echo "💫" ;;
    "low_energy")  echo "🔸" ;;
    "fatigue")     echo "😴" ;;
    "stable")      echo "🎯" ;;
esac
```

### Focus Quality Display
```bash
# Focus quality visualization
case "$focus_quality" in
    "hyperfocus") echo "🔥" ;;
    "focused")    echo "🎯" ;;
    "moderate")   echo "⚡" ;;
    "scattered")  echo "💫" ;;
    "chaotic")    echo "🌀" ;;
esac
```

## 🔄 Return Codes

- **0**: Success - valid behavioral analysis returned
- **1**: Unknown command or invalid parameters
- **Graceful Degradation**: Missing data results in zero metrics, not failures

## 📊 Performance

- **Execution Time**: <200ms for typical 1-hour analysis
- **Memory Usage**: Minimal - uses awk for efficient log processing
- **Scalability**: Performance degrades gracefully with large log files
- **Log Rotation**: Designed to work with standard log rotation schemes