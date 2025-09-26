# Cognitive State Mapping for ADHD Developers

## Core Cognitive States

### 1. Focus States
- **Deep Focus**: Sustained attention with minimal context switching
- **Scattered Focus**: Frequent task/directory changes, fragmented attention
- **Hyperfocus**: Extended periods of intense concentration (risk state)
- **Unfocused**: Low productivity, high API usage (seeking direction)

### 2. Energy Levels
- **High Energy**: Peak productivity, efficient output
- **Medium Energy**: Moderate productivity, steady progress
- **Low Energy**: Reduced output, potential fatigue
- **Crash**: Post-hyperfocus energy depletion

### 3. Context Switching Patterns
- **Mono-tasking**: Single project/directory focus
- **Controlled Switching**: Intentional, productive task transitions
- **Chaotic Switching**: Rapid, unproductive context changes
- **Parallel Processing**: Multiple active projects

## JSON Field to Cognitive State Mapping

### Duration-Based Indicators

```bash
# Focus State Calculation
duration_minutes=$(echo "$duration_ms / 60000" | bc -l)

if [ $(echo "$duration_minutes > 120" | bc) -eq 1 ]; then
    focus_state="hyperfocus"
elif [ $(echo "$duration_minutes > 45" | bc) -eq 1 ]; then
    focus_state="deep_focus"
elif [ $(echo "$duration_minutes < 10" | bc) -eq 1 ]; then
    focus_state="scattered"
else
    focus_state="focused"
fi
```

### Productivity-Based Indicators

```bash
# Energy Level Calculation
net_productivity=$((lines_added - lines_removed))
productivity_rate=$(echo "scale=2; $net_productivity / ($duration_ms / 60000)" | bc -l)

if [ $(echo "$productivity_rate > 5" | bc) -eq 1 ]; then
    energy_level="high"
elif [ $(echo "$productivity_rate > 1" | bc) -eq 1 ]; then
    energy_level="medium"
elif [ $(echo "$productivity_rate > 0" | bc) -eq 1 ]; then
    energy_level="low"
else
    energy_level="crash"
fi
```

### Context Switching Detection

```bash
# Context Switch Analysis (requires historical data)
if [ "$current_dir" != "$project_dir" ]; then
    context_switch_level="high"
elif [ "$directory_changes_per_hour" -gt 3 ]; then
    context_switch_level="medium"
else
    context_switch_level="low"
fi
```

## ADHD-Specific Behavioral Patterns

### 1. Hyperfocus Detection Algorithm
```bash
detect_hyperfocus() {
    local duration_ms=$1
    local productivity_rate=$2
    local api_ratio=$3

    local duration_hours=$(echo "$duration_ms / 3600000" | bc -l)

    # Hyperfocus criteria:
    # - Duration > 90 minutes
    # - High productivity OR low API ratio (deep thought)
    # - Consistent engagement

    if [ $(echo "$duration_hours > 1.5" | bc) -eq 1 ]; then
        if [ $(echo "$productivity_rate > 3" | bc) -eq 1 ] || [ $(echo "$api_ratio < 0.3" | bc) -eq 1 ]; then
            echo "hyperfocus_detected"
            return 0
        fi
    fi

    echo "normal_focus"
    return 1
}
```

### 2. Attention Fragmentation Scoring
```bash
calculate_fragmentation_score() {
    local total_duration_ms=$1
    local api_duration_ms=$2
    local lines_produced=$3

    # High API ratio + low productivity = attention fragmentation
    local api_ratio=$(echo "scale=3; $api_duration_ms / $total_duration_ms" | bc -l)
    local productivity_per_api=$(echo "scale=3; $lines_produced / ($api_duration_ms / 1000)" | bc -l)

    # Fragmentation indicators:
    # - High API usage relative to session time
    # - Low productivity per API interaction
    # - Suggests seeking help frequently without sustained work

    local fragmentation_score=0

    if [ $(echo "$api_ratio > 0.5" | bc) -eq 1 ]; then
        fragmentation_score=$((fragmentation_score + 30))
    fi

    if [ $(echo "$productivity_per_api < 2" | bc) -eq 1 ]; then
        fragmentation_score=$((fragmentation_score + 40))
    fi

    if [ $(echo "$total_duration_ms < 1800000" | bc) -eq 1 ]; then  # < 30 min
        fragmentation_score=$((fragmentation_score + 30))
    fi

    echo $fragmentation_score
}
```

### 3. Executive Function Assessment
```bash
assess_executive_function() {
    local session_data="$1"

    # Extract metrics
    local duration_ms=$(echo "$session_data" | jq -r '.cost.total_duration_ms')
    local lines_added=$(echo "$session_data" | jq -r '.cost.total_lines_added')
    local lines_removed=$(echo "$session_data" | jq -r '.cost.total_lines_removed')
    local api_duration=$(echo "$session_data" | jq -r '.cost.total_api_duration_ms')

    # Executive function indicators:
    # 1. Task completion efficiency
    # 2. Goal-directed behavior (net productivity)
    # 3. Sustained effort over time

    local completion_efficiency=$(echo "scale=2; ($lines_added + $lines_removed) / ($duration_ms / 60000)" | bc -l)
    local goal_direction=$(echo "scale=2; $lines_added / ($lines_added + $lines_removed + 1)" | bc -l)
    local sustained_effort=$(echo "scale=2; ($duration_ms - $api_duration) / $duration_ms" | bc -l)

    # Scoring (0-100)
    local exec_score=0

    # Efficiency component (0-40)
    if [ $(echo "$completion_efficiency > 5" | bc) -eq 1 ]; then
        exec_score=$((exec_score + 40))
    elif [ $(echo "$completion_efficiency > 2" | bc) -eq 1 ]; then
        exec_score=$((exec_score + 25))
    elif [ $(echo "$completion_efficiency > 0.5" | bc) -eq 1 ]; then
        exec_score=$((exec_score + 10))
    fi

    # Goal direction component (0-30)
    if [ $(echo "$goal_direction > 0.7" | bc) -eq 1 ]; then
        exec_score=$((exec_score + 30))
    elif [ $(echo "$goal_direction > 0.5" | bc) -eq 1 ]; then
        exec_score=$((exec_score + 20))
    elif [ $(echo "$goal_direction > 0.3" | bc) -eq 1 ]; then
        exec_score=$((exec_score + 10))
    fi

    # Sustained effort component (0-30)
    if [ $(echo "$sustained_effort > 0.7" | bc) -eq 1 ]; then
        exec_score=$((exec_score + 30))
    elif [ $(echo "$sustained_effort > 0.5" | bc) -eq 1 ]; then
        exec_score=$((exec_score + 20))
    elif [ $(echo "$sustained_effort > 0.3" | bc) -eq 1 ]; then
        exec_score=$((exec_score + 10))
    fi

    echo $exec_score
}
```

## State Transition Logic

### Focus State Transitions
```bash
# State persistence and transition rules
update_focus_state() {
    local current_state="$1"
    local new_metrics="$2"
    local historical_data="$3"

    case "$current_state" in
        "hyperfocus")
            # Can only exit hyperfocus through break or crash
            if check_session_break "$new_metrics"; then
                echo "focused"
            elif check_productivity_crash "$new_metrics" "$historical_data"; then
                echo "unfocused"
            else
                echo "hyperfocus"
            fi
            ;;
        "deep_focus")
            if check_hyperfocus_criteria "$new_metrics"; then
                echo "hyperfocus"
            elif check_fragmentation "$new_metrics"; then
                echo "scattered"
            else
                echo "deep_focus"
            fi
            ;;
        "scattered")
            if check_focus_recovery "$new_metrics" "$historical_data"; then
                echo "focused"
            else
                echo "scattered"
            fi
            ;;
        *)
            determine_initial_state "$new_metrics"
            ;;
    esac
}
```

## Cognitive Load Indicators

### API Usage Patterns
- **High Frequency, Short Queries**: Cognitive overload, seeking immediate help
- **Low Frequency, Detailed Queries**: Thoughtful problem-solving approach
- **Repeated Similar Queries**: Possible working memory challenges

### Productivity Variance
- **Consistent Output**: Stable cognitive state
- **Spiky Productivity**: Possible energy cycling or hyperfocus episodes
- **Declining Productivity**: Fatigue or attention depletion

### Time-Based Patterns
- **Morning Peak Performance**: Typical ADHD pattern
- **Post-Lunch Dip**: Common energy pattern
- **Evening Hyperfocus**: Risk period for burnout