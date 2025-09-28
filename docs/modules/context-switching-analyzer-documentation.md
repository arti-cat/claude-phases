# Context Switching Analyzer Module Documentation

**File**: `/home/bch/.claude/modules/context-switching-analyzer.sh`
**Size**: 5.9k (186 lines)
**Purpose**: ADHD attention fragmentation detection and context switching analysis

## 🎯 Core Function

Tracks directory changes, branch switches, and tool usage to calculate attention fragmentation scores and provide visual indicators for focus state assessment.

## 📁 Log Files

```bash
~/.claude/logs/
├── context-switching.log  # Directory changes, branch switches, editor opens
└── bash-commands.log      # Command history for tool usage analysis
```

## 🚀 CLI Commands

### Basic Analysis
```bash
# Get fragmentation metrics for current session
~/.claude/modules/context-switching-analyzer.sh current-session metrics

# Get visual emoji indicator
~/.claude/modules/context-switching-analyzer.sh current-session indicator

# Get text assessment
~/.claude/modules/context-switching-analyzer.sh current-session assessment

# Get comprehensive behavioral analysis
~/.claude/modules/context-switching-analyzer.sh current-session enhanced 3600
```

### Time Window Analysis
```bash
# Last 30 minutes (1800 seconds)
~/.claude/modules/context-switching-analyzer.sh session-123 enhanced 1800

# Last 2 hours (7200 seconds)
~/.claude/modules/context-switching-analyzer.sh session-123 metrics 7200
```

## 📊 Data Formats

### Input: Log Entry Format
```bash
# context-switching.log format:
timestamp,session_id,event_type,additional_data
1699123456,current-session,DIRECTORY_CHANGE,/home/user/project1
1699123500,current-session,BRANCH_SWITCH,feature/new-feature
1699123600,current-session,EDITOR_OPEN,src/main.js
1699123700,current-session,PRE_USE,grep_tool
```

### Output: Metrics JSON
```json
{
    "session_id": "current-session",
    "time_window": "1_hour",
    "directory_changes": 5,
    "branch_changes": 2,
    "editor_switches": 8,
    "total_switches": 15,
    "tool_usage": 12,
    "fragmentation_score": 75,
    "timestamp": 1699123456
}
```

### Output: Enhanced Analysis
```json
{
    "context_analysis": {
        "session_id": "current-session",
        "fragmentation_score": 45,
        "total_switches": 9
    },
    "behavioral_analysis": {
        "tool_velocity": 2.1,
        "error_rate": 8.5,
        "pattern": "stable"
    },
    "integrated_score": {
        "timestamp": 1699123456,
        "session_id": "current-session",
        "window_seconds": 3600
    }
}
```

## 🔧 Key Functions

### `get_context_metrics(session_id)`
- **Purpose**: Calculate fragmentation score and switching metrics for last hour
- **Algorithm**:
  - Counts directory changes, branch switches, editor opens
  - Calculates fragmentation score: 0-100 (higher = more scattered)
  - Score = switches × multiplier (5 for ≤8 switches, 6 for 8-15, 100 for >15)
- **ADHD Feature**: Quantifies attention fragmentation patterns

### `get_context_indicator(fragmentation_score)`
- **Purpose**: Visual emoji representation of focus state
- **Thresholds**:
  - 🎯 (0-15): Very focused work
  - ⚡ (16-40): Normal switching
  - 💫 (41-70): Medium fragmentation
  - 🌀 (71-100): High fragmentation - scattered attention
- **ADHD Feature**: Immediate visual feedback for attention state

### `get_context_assessment(fragmentation_score)`
- **Purpose**: Text-based assessment categories
- **Categories**:
  - **focused** (0-15): Sustained attention
  - **dynamic** (16-40): Normal task switching
  - **switching** (41-70): Elevated context switching
  - **scattered** (71-100): High attention fragmentation

### `get_enhanced_behavioral_context(session_id, time_window)`
- **Purpose**: Integration with behavioral analyzer for comprehensive assessment
- **ADHD Feature**: Combines attention fragmentation with velocity patterns
- **Output**: Combined context + behavioral analysis JSON

## 🧠 ADHD-Specific Features

### Attention Fragmentation Scoring
- **0-15**: Deep focus state - optimal for ADHD productivity
- **16-40**: Manageable switching - normal development patterns
- **41-70**: Elevated switching - potential attention regulation issues
- **71-100**: Scattered attention - intervention recommended

### Context Switch Categories
- **Directory Changes**: Project/folder navigation frequency
- **Branch Switches**: Git workflow fragmentation
- **Editor Switches**: File jumping patterns
- **Tool Usage**: Command/tool switching frequency

### Time Window Analysis
- **Default**: 1 hour (3600 seconds) - optimal for ADHD attention spans
- **Configurable**: Support for 30min, 2hr, or custom windows
- **Real-time**: Updated continuously as logs accumulate

## 🔌 Integration Points

### With Behavioral Analyzer
```bash
# Automatic integration when behavioral-analyzer.sh is available
enhanced_data=$(~/.claude/modules/context-switching-analyzer.sh current enhanced)
behavioral_pattern=$(echo "$enhanced_data" | jq -r '.behavioral_analysis.pattern')
```

### With Main Statusline
```bash
# Get current fragmentation state
metrics=$(~/.claude/modules/context-switching-analyzer.sh current metrics)
score=$(echo "$metrics" | jq -r '.fragmentation_score')
indicator=$(~/.claude/modules/context-switching-analyzer.sh current indicator)

# Use in statusline display
echo "Focus: $indicator Score: $score"
```

### With Config Manager
```bash
# Context thresholds from active profile
profile=$(~/.claude/modules/config-manager.sh current)
thresholds=$(~/.claude/modules/config-manager.sh context "$profile")
scattered_threshold=$(echo "$thresholds" | jq -r '.scattered_threshold')

# Compare against profile-specific thresholds
if [[ $score -gt $scattered_threshold ]]; then
    echo "⚠️ High fragmentation for profile: $profile"
fi
```

## 💡 Usage Examples

### Basic Assessment
```bash
# Get current attention state
~/.claude/modules/context-switching-analyzer.sh current-session assessment
# Output: "switching"

# Get visual indicator
~/.claude/modules/context-switching-analyzer.sh current-session indicator
# Output: 💫

# Get detailed metrics
~/.claude/modules/context-switching-analyzer.sh current-session metrics
# Output: {"fragmentation_score": 45, "total_switches": 9, "directory_changes": 3...}
```

### Time Window Analysis
```bash
# Last 30 minutes for quick check
metrics=$(~/.claude/modules/context-switching-analyzer.sh current metrics)
score=$(echo "$metrics" | jq -r '.fragmentation_score')

if [[ $score -gt 70 ]]; then
    echo "🌀 High fragmentation - consider taking a break"
elif [[ $score -lt 15 ]]; then
    echo "🎯 Deep focus - great session!"
fi
```

### Integration Pattern
```bash
# Get comprehensive analysis
enhanced=$(~/.claude/modules/context-switching-analyzer.sh current enhanced 3600)

# Extract key metrics
context_score=$(echo "$enhanced" | jq -r '.context_analysis.fragmentation_score')
behavioral_pattern=$(echo "$enhanced" | jq -r '.behavioral_analysis.pattern // "unknown"')
tool_velocity=$(echo "$enhanced" | jq -r '.behavioral_analysis.tool_velocity // 0')

# Combined assessment
if [[ $context_score -gt 60 ]] && [[ "$behavioral_pattern" == "scattered" ]]; then
    echo "⚠️ High fragmentation + scattered behavior - intervention recommended"
fi
```

## 📈 Algorithm Details

### Fragmentation Score Calculation
```bash
# Linear scaling for low switching (0-8 switches)
if [[ $total_switches -le 8 ]]; then
    fragmentation_score=$((total_switches * 5))  # Max 40

# Accelerated scaling for medium switching (9-15 switches)
elif [[ $total_switches -le 15 ]]; then
    fragmentation_score=$((total_switches * 6))  # 48-90

# Maximum fragmentation for high switching (>15 switches)
else
    fragmentation_score=100
fi
```

### Time Window Processing
```bash
# AWK pattern for filtering log entries
awk -F, -v since="$hour_ago" '$1 >= since'  # Timestamp filtering
grep "DIRECTORY_CHANGE" | wc -l             # Count specific events
```

## ⚠️ Error Conditions

### Missing Log Files
- **Empty Logs**: Returns zero metrics, creates empty log files
- **Malformed Entries**: Skips invalid lines, continues processing
- **Permission Issues**: Graceful fallback to default values

### Invalid Sessions
- **Unknown Session**: Processes available data, warns about session mismatch
- **No Data**: Returns default structure with zero values

## 🎨 Visual Indicators

### Emoji States
- 🎯 **Focused** (0-15): Deep work, minimal switching
- ⚡ **Dynamic** (16-40): Normal development flow
- 💫 **Switching** (41-70): Elevated task switching
- 🌀 **Scattered** (71-100): High fragmentation, needs intervention

### Assessment Text
- **"focused"**: Sustained attention on single task/area
- **"dynamic"**: Healthy switching between related tasks
- **"switching"**: Moderate attention fragmentation
- **"scattered"**: High fragmentation, attention regulation issues

## 🔄 Return Codes

- **0**: Success - valid metrics returned
- **1**: Unknown command or invalid parameters
- **Auto-fallback**: Missing logs result in zero metrics, not errors

## 📊 Performance

- **Execution Time**: <100ms for typical 1-hour window
- **Memory Usage**: Minimal - processes logs via awk/grep
- **Log File Size**: Efficient - only stores essential switching events