# ADHD Cognitive Detection Algorithms

## Algorithm Architecture Overview

The cognitive detection system uses a multi-layered approach:
1. **Real-time State Assessment**: Immediate analysis of current session
2. **Historical Pattern Recognition**: Learning from past behavior
3. **Adaptive Thresholds**: Personalized detection parameters
4. **Context-Aware Scoring**: Environment and time-based adjustments

## 1. Focus State Detection Algorithm

### Core Algorithm
```bash
detect_focus_state() {
    local session_data="$1"
    local historical_data="$2"
    local user_profile="$3"

    # Extract metrics
    local duration_ms=$(echo "$session_data" | jq -r '.cost.total_duration_ms')
    local api_duration_ms=$(echo "$session_data" | jq -r '.cost.total_api_duration_ms')
    local lines_added=$(echo "$session_data" | jq -r '.cost.total_lines_added')
    local lines_removed=$(echo "$session_data" | jq -r '.cost.total_lines_removed')

    # Calculate derived metrics
    local duration_minutes=$(echo "scale=2; $duration_ms / 60000" | bc -l)
    local api_ratio=$(echo "scale=3; $api_duration_ms / $duration_ms" | bc -l)
    local productivity_rate=$(echo "scale=2; ($lines_added + $lines_removed) / $duration_minutes" | bc -l)
    local net_productivity=$(echo "scale=2; ($lines_added - $lines_removed) / $duration_minutes" | bc -l)

    # Get context switches from directory tracking
    local context_switches=$(get_context_switches "$session_data" "$historical_data")

    # Focus scoring components
    local duration_score=$(calculate_duration_score "$duration_minutes")
    local consistency_score=$(calculate_consistency_score "$api_ratio" "$productivity_rate")
    local engagement_score=$(calculate_engagement_score "$lines_added" "$lines_removed" "$duration_minutes")
    local context_score=$(calculate_context_stability_score "$context_switches" "$duration_minutes")

    # Weighted focus score (0-100)
    local focus_score=$(echo "scale=1; ($duration_score * 0.3) + ($consistency_score * 0.25) + ($engagement_score * 0.25) + ($context_score * 0.2)" | bc -l)

    # Determine focus state based on score and patterns
    determine_focus_state "$focus_score" "$duration_minutes" "$api_ratio" "$context_switches"
}

calculate_duration_score() {
    local duration_minutes=$1

    if [ $(echo "$duration_minutes >= 120" | bc) -eq 1 ]; then
        echo 100  # Extended session
    elif [ $(echo "$duration_minutes >= 60" | bc) -eq 1 ]; then
        echo 85   # Long session
    elif [ $(echo "$duration_minutes >= 30" | bc) -eq 1 ]; then
        echo 70   # Medium session
    elif [ $(echo "$duration_minutes >= 15" | bc) -eq 1 ]; then
        echo 50   # Short session
    else
        echo 20   # Very short session
    fi
}

calculate_consistency_score() {
    local api_ratio=$1
    local productivity_rate=$2

    # Low API ratio + steady productivity = high consistency
    local api_consistency=100
    if [ $(echo "$api_ratio > 0.5" | bc) -eq 1 ]; then
        api_consistency=30
    elif [ $(echo "$api_ratio > 0.3" | bc) -eq 1 ]; then
        api_consistency=60
    elif [ $(echo "$api_ratio > 0.1" | bc) -eq 1 ]; then
        api_consistency=85
    fi

    # Steady productivity indicates consistent focus
    local productivity_consistency=50
    if [ $(echo "$productivity_rate > 5" | bc) -eq 1 ]; then
        productivity_consistency=90
    elif [ $(echo "$productivity_rate > 2" | bc) -eq 1 ]; then
        productivity_consistency=75
    elif [ $(echo "$productivity_rate > 0.5" | bc) -eq 1 ]; then
        productivity_consistency=60
    fi

    echo $(echo "scale=1; ($api_consistency + $productivity_consistency) / 2" | bc -l)
}

determine_focus_state() {
    local focus_score=$1
    local duration_minutes=$2
    local api_ratio=$3
    local context_switches=$4

    # Hyperfocus detection (special case)
    if [ $(echo "$duration_minutes > 90" | bc) -eq 1 ] && [ $(echo "$focus_score > 75" | bc) -eq 1 ]; then
        echo "hyperfocus"
        return
    fi

    # Scattered focus detection
    if [ $context_switches -gt 8 ] || [ $(echo "$api_ratio > 0.6" | bc) -eq 1 ]; then
        echo "scattered"
        return
    fi

    # Primary focus state determination
    if [ $(echo "$focus_score > 80" | bc) -eq 1 ]; then
        echo "deep_focus"
    elif [ $(echo "$focus_score > 60" | bc) -eq 1 ]; then
        echo "focused"
    elif [ $(echo "$focus_score > 40" | bc) -eq 1 ]; then
        echo "partially_focused"
    else
        echo "unfocused"
    fi
}
```

## 2. Energy Level Assessment Algorithm

### Core Algorithm
```bash
assess_energy_level() {
    local session_data="$1"
    local historical_data="$2"
    local time_context="$3"

    # Extract metrics
    local duration_ms=$(echo "$session_data" | jq -r '.cost.total_duration_ms')
    local lines_added=$(echo "$session_data" | jq -r '.cost.total_lines_added')
    local lines_removed=$(echo "$session_data" | jq -r '.cost.total_lines_removed')
    local api_duration_ms=$(echo "$session_data" | jq -r '.cost.total_api_duration_ms')

    # Calculate energy indicators
    local productivity_rate=$(calculate_productivity_rate "$lines_added" "$lines_removed" "$duration_ms")
    local efficiency_ratio=$(calculate_efficiency_ratio "$lines_added" "$lines_removed" "$api_duration_ms")
    local sustained_effort=$(calculate_sustained_effort "$duration_ms" "$api_duration_ms")
    local output_quality=$(calculate_output_quality "$lines_added" "$lines_removed")

    # Time-based adjustments
    local circadian_modifier=$(get_circadian_modifier "$time_context")
    local historical_comparison=$(compare_to_historical_performance "$productivity_rate" "$historical_data")

    # Energy score calculation (0-100)
    local base_energy=$(echo "scale=1; ($productivity_rate * 0.4) + ($efficiency_ratio * 0.3) + ($sustained_effort * 0.2) + ($output_quality * 0.1)" | bc -l)
    local adjusted_energy=$(echo "scale=1; $base_energy * $circadian_modifier * $historical_comparison" | bc -l)

    determine_energy_level "$adjusted_energy" "$productivity_rate" "$sustained_effort"
}

calculate_productivity_rate() {
    local lines_added=$1
    local lines_removed=$2
    local duration_ms=$3

    local total_output=$((lines_added + lines_removed))
    local duration_minutes=$(echo "scale=2; $duration_ms / 60000" | bc -l)
    local rate=$(echo "scale=2; $total_output / $duration_minutes" | bc -l)

    # Normalize to 0-100 scale (10+ lines/minute = 100)
    local normalized_rate=$(echo "scale=1; ($rate / 10) * 100" | bc -l)
    if [ $(echo "$normalized_rate > 100" | bc) -eq 1 ]; then
        echo 100
    else
        echo $normalized_rate
    fi
}

calculate_efficiency_ratio() {
    local lines_added=$1
    local lines_removed=$2
    local api_duration_ms=$3

    local net_output=$((lines_added - lines_removed))
    local api_minutes=$(echo "scale=2; $api_duration_ms / 60000" | bc -l)

    if [ $(echo "$api_minutes > 0" | bc) -eq 1 ]; then
        local efficiency=$(echo "scale=2; $net_output / $api_minutes" | bc -l)
        # Normalize (5+ lines per API minute = 100)
        local normalized=$(echo "scale=1; ($efficiency / 5) * 100" | bc -l)
        if [ $(echo "$normalized > 100" | bc) -eq 1 ]; then
            echo 100
        else
            echo $normalized
        fi
    else
        echo 100  # No API usage indicates high efficiency
    fi
}

get_circadian_modifier() {
    local time_context="$1"
    local hour=$(echo "$time_context" | jq -r '.hour')
    local is_weekday=$(echo "$time_context" | jq -r '.is_weekday')

    # ADHD-typical circadian patterns
    if [ $hour -ge 9 ] && [ $hour -le 11 ]; then
        echo 1.2  # Morning peak
    elif [ $hour -ge 14 ] && [ $hour -le 16 ]; then
        echo 0.8  # Post-lunch dip
    elif [ $hour -ge 19 ] && [ $hour -le 23 ]; then
        echo 1.1  # Evening peak
    elif [ $hour -ge 0 ] && [ $hour -le 2 ]; then
        echo 1.0  # Late night (neutral, person-dependent)
    else
        echo 1.0  # Default
    fi
}

determine_energy_level() {
    local energy_score=$1
    local productivity_rate=$2
    local sustained_effort=$3

    # Check for crash state (low productivity despite effort)
    if [ $(echo "$productivity_rate < 20" | bc) -eq 1 ] && [ $(echo "$sustained_effort > 60" | bc) -eq 1 ]; then
        echo "crash"
        return
    fi

    # Primary energy level determination
    if [ $(echo "$energy_score > 80" | bc) -eq 1 ]; then
        echo "high"
    elif [ $(echo "$energy_score > 60" | bc) -eq 1 ]; then
        echo "medium_high"
    elif [ $(echo "$energy_score > 40" | bc) -eq 1 ]; then
        echo "medium"
    elif [ $(echo "$energy_score > 20" | bc) -eq 1 ]; then
        echo "low"
    else
        echo "very_low"
    fi
}
```

## 3. Context Switching Detection Algorithm

### Core Algorithm
```bash
analyze_context_switching() {
    local session_data="$1"
    local historical_data="$2"
    local directory_log="$3"

    # Extract context indicators
    local current_dir=$(echo "$session_data" | jq -r '.workspace.current_dir')
    local project_dir=$(echo "$session_data" | jq -r '.workspace.project_dir')
    local session_id=$(echo "$session_data" | jq -r '.session_id')

    # Calculate context metrics
    local directory_changes=$(count_directory_changes "$directory_log" "$session_id")
    local project_boundary_crosses=$(count_project_boundary_crosses "$current_dir" "$project_dir" "$directory_log")
    local switch_frequency=$(calculate_switch_frequency "$directory_changes" "$session_data")
    local context_stability=$(calculate_context_stability "$directory_changes" "$session_data")

    # Attention fragmentation scoring
    local fragmentation_score=$(calculate_fragmentation_score "$directory_changes" "$switch_frequency" "$context_stability")

    # Determine context switching pattern
    determine_context_pattern "$fragmentation_score" "$directory_changes" "$switch_frequency"
}

count_directory_changes() {
    local directory_log="$1"
    local session_id="$2"

    # Count unique directory changes during session
    if [ -f "$directory_log" ]; then
        grep "$session_id" "$directory_log" | cut -d'|' -f3 | sort -u | wc -l
    else
        echo 1  # Default if no log exists
    fi
}

calculate_switch_frequency() {
    local directory_changes=$1
    local session_data="$2"

    local duration_minutes=$(echo "$session_data" | jq -r '.cost.total_duration_ms / 60000')

    if [ $(echo "$duration_minutes > 0" | bc) -eq 1 ]; then
        echo "scale=2; $directory_changes / $duration_minutes" | bc -l
    else
        echo 0
    fi
}

calculate_fragmentation_score() {
    local directory_changes=$1
    local switch_frequency=$2
    local context_stability=$3

    # High frequency switching indicates attention fragmentation
    local frequency_penalty=0
    if [ $(echo "$switch_frequency > 0.5" | bc) -eq 1 ]; then  # >0.5 switches per minute
        frequency_penalty=40
    elif [ $(echo "$switch_frequency > 0.2" | bc) -eq 1 ]; then
        frequency_penalty=20
    fi

    # Many total switches indicate scattered attention
    local volume_penalty=0
    if [ $directory_changes -gt 10 ]; then
        volume_penalty=30
    elif [ $directory_changes -gt 5 ]; then
        volume_penalty=15
    fi

    # Low stability compounds the fragmentation
    local stability_penalty=0
    if [ $(echo "$context_stability < 30" | bc) -eq 1 ]; then
        stability_penalty=30
    elif [ $(echo "$context_stability < 60" | bc) -eq 1 ]; then
        stability_penalty=15
    fi

    echo $(($frequency_penalty + $volume_penalty + $stability_penalty))
}

determine_context_pattern() {
    local fragmentation_score=$1
    local directory_changes=$2
    local switch_frequency=$3

    if [ $(echo "$fragmentation_score > 70" | bc) -eq 1 ]; then
        echo "chaotic_switching"
    elif [ $(echo "$fragmentation_score > 40" | bc) -eq 1 ]; then
        echo "high_switching"
    elif [ $directory_changes -le 3 ] && [ $(echo "$switch_frequency < 0.1" | bc) -eq 1 ]; then
        echo "mono_focus"
    else
        echo "controlled_switching"
    fi
}
```

## 4. Hyperfocus Warning Algorithm

### Core Algorithm
```bash
assess_hyperfocus_risk() {
    local session_data="$1"
    local historical_data="$2"
    local user_profile="$3"
    local current_time="$4"

    # Extract session metrics
    local duration_ms=$(echo "$session_data" | jq -r '.cost.total_duration_ms')
    local productivity_rate=$(calculate_productivity_rate_from_session "$session_data")
    local api_ratio=$(echo "$session_data" | jq -r '.cost.total_api_duration_ms / .cost.total_duration_ms')

    # Calculate risk factors
    local duration_risk=$(calculate_duration_risk "$duration_ms")
    local flow_state_risk=$(calculate_flow_state_risk "$productivity_rate" "$api_ratio")
    local temporal_risk=$(calculate_temporal_risk "$current_time")
    local historical_risk=$(calculate_historical_risk "$historical_data" "$user_profile")
    local burnout_risk=$(calculate_burnout_risk "$historical_data" "$duration_ms")

    # Composite risk score (0-100)
    local total_risk=$(echo "scale=1; ($duration_risk * 0.3) + ($flow_state_risk * 0.25) + ($temporal_risk * 0.2) + ($historical_risk * 0.15) + ($burnout_risk * 0.1)" | bc -l)

    # Generate appropriate warning
    generate_hyperfocus_warning "$total_risk" "$duration_ms" "$productivity_rate"
}

calculate_duration_risk() {
    local duration_ms=$1
    local duration_hours=$(echo "scale=2; $duration_ms / 3600000" | bc -l)

    # Exponential risk increase with duration
    if [ $(echo "$duration_hours > 4" | bc) -eq 1 ]; then
        echo 95
    elif [ $(echo "$duration_hours > 3" | bc) -eq 1 ]; then
        echo 80
    elif [ $(echo "$duration_hours > 2" | bc) -eq 1 ]; then
        echo 60
    elif [ $(echo "$duration_hours > 1.5" | bc) -eq 1 ]; then
        echo 40
    elif [ $(echo "$duration_hours > 1" | bc) -eq 1 ]; then
        echo 20
    else
        echo 5
    fi
}

calculate_flow_state_risk() {
    local productivity_rate=$1
    local api_ratio=$2

    # High productivity + low API usage = flow state risk
    local productivity_risk=0
    if [ $(echo "$productivity_rate > 80" | bc) -eq 1 ]; then
        productivity_risk=30
    elif [ $(echo "$productivity_rate > 60" | bc) -eq 1 ]; then
        productivity_risk=20
    fi

    local api_risk=0
    if [ $(echo "$api_ratio < 0.2" | bc) -eq 1 ]; then
        api_risk=25  # Very low API usage indicates deep flow
    elif [ $(echo "$api_ratio < 0.4" | bc) -eq 1 ]; then
        api_risk=15
    fi

    echo $(($productivity_risk + $api_risk))
}

calculate_temporal_risk() {
    local current_time="$1"
    local hour=$(date -d "$current_time" +%H)
    local day_of_week=$(date -d "$current_time" +%u)

    # Higher risk during typical ADHD hyperfocus periods
    local hour_risk=0
    if [ $hour -ge 18 ] && [ $hour -le 23 ]; then
        hour_risk=25  # Evening hyperfocus peak
    elif [ $hour -ge 0 ] && [ $hour -le 3 ]; then
        hour_risk=30  # Late night high risk
    elif [ $hour -ge 10 ] && [ $hour -le 14 ]; then
        hour_risk=15  # Morning peak
    fi

    # Weekend risk (more flexible schedule)
    local weekend_risk=0
    if [ $day_of_week -eq 6 ] || [ $day_of_week -eq 7 ]; then
        weekend_risk=10
    fi

    echo $(($hour_risk + $weekend_risk))
}

generate_hyperfocus_warning() {
    local risk_score=$1
    local duration_ms=$2
    local productivity_rate=$3

    local duration_hours=$(echo "scale=1; $duration_ms / 3600000" | bc -l)

    if [ $(echo "$risk_score > 80" | bc) -eq 1 ]; then
        echo "CRITICAL_HYPERFOCUS:${duration_hours}h:You've been in hyperfocus for ${duration_hours} hours! Take a break now to prevent burnout."
    elif [ $(echo "$risk_score > 60" | bc) -eq 1 ]; then
        echo "HIGH_HYPERFOCUS:${duration_hours}h:Strong hyperfocus detected (${duration_hours}h). Consider a break soon."
    elif [ $(echo "$risk_score > 40" | bc) -eq 1 ]; then
        echo "MODERATE_HYPERFOCUS:${duration_hours}h:Extended focus session. Break recommended within 30 minutes."
    elif [ $(echo "$risk_score > 20" | bc) -eq 1 ]; then
        echo "MILD_HYPERFOCUS:${duration_hours}h:Good focus! Remember to take breaks regularly."
    else
        echo "NORMAL_FOCUS:${duration_hours}h:Healthy work session."
    fi
}
```

## 5. Composite Cognitive Assessment

### Main Assessment Function
```bash
assess_cognitive_state() {
    local session_data="$1"
    local historical_data="$2"
    local user_profile="$3"
    local context_data="$4"

    # Run all detection algorithms
    local focus_state=$(detect_focus_state "$session_data" "$historical_data" "$user_profile")
    local energy_level=$(assess_energy_level "$session_data" "$historical_data" "$context_data")
    local context_pattern=$(analyze_context_switching "$session_data" "$historical_data" "$context_data")
    local hyperfocus_warning=$(assess_hyperfocus_risk "$session_data" "$historical_data" "$user_profile" "$(date)")

    # Generate composite assessment
    cat << EOF
{
    "timestamp": "$(date -Iseconds)",
    "session_id": "$(echo "$session_data" | jq -r '.session_id')",
    "cognitive_state": {
        "focus": "$focus_state",
        "energy": "$energy_level",
        "context_switching": "$context_pattern",
        "hyperfocus_warning": "$hyperfocus_warning"
    },
    "recommendations": $(generate_recommendations "$focus_state" "$energy_level" "$context_pattern" "$hyperfocus_warning"),
    "confidence_score": $(calculate_confidence_score "$session_data" "$historical_data")
}
EOF
}

generate_recommendations() {
    local focus_state="$1"
    local energy_level="$2"
    local context_pattern="$3"
    local hyperfocus_warning="$4"

    local recommendations=()

    # Focus-based recommendations
    case "$focus_state" in
        "scattered"|"unfocused")
            recommendations+=("\"Try the Pomodoro technique for better focus\"")
            recommendations+=("\"Consider reducing distractions in your environment\"")
            ;;
        "hyperfocus")
            recommendations+=("\"Take a break - you've been hyperfocused for too long\"")
            ;;
    esac

    # Energy-based recommendations
    case "$energy_level" in
        "low"|"very_low"|"crash")
            recommendations+=("\"Consider taking a break or doing lighter tasks\"")
            recommendations+=("\"Check if you need hydration, food, or movement\"")
            ;;
        "high")
            recommendations+=("\"Great energy! Tackle challenging tasks now\"")
            ;;
    esac

    # Context switching recommendations
    case "$context_pattern" in
        "chaotic_switching"|"high_switching")
            recommendations+=("\"High context switching detected - try batching similar tasks\"")
            ;;
    esac

    # Format as JSON array
    IFS=','
    echo "[${recommendations[*]}]"
}
```

This comprehensive algorithm suite provides the foundation for real-time ADHD cognitive state assessment, enabling the statusline to offer meaningful, personalized feedback to developers.