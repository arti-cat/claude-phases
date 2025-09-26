# ADHD Behavioral Patterns in Developer Environments

## Core ADHD Characteristics in Coding Context

### 1. Attention Regulation Challenges
**Manifestations in Claude Code Sessions:**
- **Hyperfocus Episodes**: 3-6+ hour coding sessions with minimal breaks
- **Attention Fragmentation**: Rapid switching between files, projects, or concepts
- **Difficulty Initiating**: Long startup times, high API usage for initial direction
- **Interruption Sensitivity**: Context switches causing significant cognitive load

**Detection Patterns:**
```bash
# Hyperfocus Pattern
duration_ms > 10800000  # > 3 hours
productivity_rate > 3   # sustained output
api_ratio < 0.4        # minimal help-seeking (deep flow)

# Fragmentation Pattern
session_count > 6       # multiple short sessions
avg_session_duration < 1800000  # < 30 minutes
context_switches > 10   # frequent directory/project changes
```

### 2. Executive Function Variations
**Working Memory Challenges:**
- **High API Dependency**: Frequent queries for information retrieval
- **Repetitive Queries**: Similar questions due to working memory load
- **Context Loss**: Returning to previous work after interruption

**Decision Fatigue:**
- **Analysis Paralysis**: Extended sessions with low productivity
- **Over-Engineering**: High lines_removed/lines_added ratio
- **Tool Switching**: Frequent different approaches to same problem

### 3. Energy Cycling Patterns
**Circadian Rhythm Disruption:**
- **Evening Hyperfocus**: Peak performance 6PM-2AM
- **Morning Sluggishness**: Low productivity before 10AM
- **Post-Meal Crashes**: Reduced performance after meals

**Dopamine-Driven Patterns:**
- **Novelty Seeking**: New project starts, high initial productivity
- **Maintenance Avoidance**: Declining productivity on established projects
- **Completion Difficulty**: Projects stall at 80-90% completion

## ADHD Subtypes and Coding Behaviors

### 1. Inattentive Presentation
**Characteristics:**
- Difficulty sustaining attention on routine tasks
- Easily distracted by internal thoughts or external stimuli
- Often loses focus during lengthy meetings or explanations

**Coding Manifestations:**
- **High API Usage**: Frequent requests for clarification and direction
- **Context Switching**: Moving between tasks without completion
- **Detail Oversight**: Missing edge cases or documentation requirements

**Detection Algorithm:**
```bash
detect_inattentive_pattern() {
    local api_ratio=$(echo "$api_duration / $total_duration" | bc -l)
    local completion_rate=$(echo "$completed_tasks / $started_tasks" | bc -l)
    local context_switches=$1

    if [ $(echo "$api_ratio > 0.6" | bc) -eq 1 ] &&
       [ $(echo "$completion_rate < 0.7" | bc) -eq 1 ] &&
       [ $context_switches -gt 8 ]; then
        echo "inattentive_pattern_detected"
    fi
}
```

### 2. Hyperactive-Impulsive Presentation
**Characteristics:**
- Difficulty sitting still or remaining in one place
- Acts without thinking, impatient with delays
- Interrupts others, difficulty waiting turn

**Coding Manifestations:**
- **Rapid Implementation**: Quick coding bursts without planning
- **Frequent Commits**: Many small commits rather than planned changes
- **Tool Experimentation**: Trying new approaches without evaluation

**Detection Algorithm:**
```bash
detect_hyperactive_pattern() {
    local commit_frequency=$1
    local refactor_ratio=$(echo "$lines_removed / $lines_added" | bc -l)
    local session_intensity=$(echo "$lines_added / ($duration_ms / 60000)" | bc -l)

    if [ $commit_frequency -gt 15 ] &&  # >15 commits per session
       [ $(echo "$refactor_ratio > 0.5" | bc) -eq 1 ] &&
       [ $(echo "$session_intensity > 8" | bc) -eq 1 ]; then
        echo "hyperactive_pattern_detected"
    fi
}
```

### 3. Combined Presentation
**Characteristics:**
- Both inattentive and hyperactive-impulsive symptoms
- Variable presentation depending on context and stress

**Coding Manifestations:**
- **Inconsistent Patterns**: Alternating between hyperfocus and distraction
- **Project Hopping**: Starting many projects, finishing few
- **Documentation Gaps**: Forgetting to document during hyperfocus

## Cognitive Load and Performance Indicators

### 1. Working Memory Overload Signs
```bash
detect_cognitive_overload() {
    local repeated_queries=$1
    local api_frequency=$2
    local productivity_decline=$3

    # Signs of working memory strain:
    # - Asking similar questions repeatedly
    # - High frequency of short API calls
    # - Declining productivity despite effort

    local overload_score=0

    if [ $repeated_queries -gt 5 ]; then
        overload_score=$((overload_score + 30))
    fi

    if [ $(echo "$api_frequency > 12" | bc) -eq 1 ]; then  # >12 API calls per hour
        overload_score=$((overload_score + 25))
    fi

    if [ $(echo "$productivity_decline > 0.3" | bc) -eq 1 ]; then  # 30% decline
        overload_score=$((overload_score + 45))
    fi

    echo $overload_score
}
```

### 2. Hyperfocus Risk Assessment
```bash
assess_hyperfocus_risk() {
    local current_duration_ms=$1
    local productivity_rate=$2
    local time_of_day=$3
    local previous_session_data="$4"

    local risk_score=0
    local duration_hours=$(echo "$current_duration_ms / 3600000" | bc -l)

    # Duration risk (exponential increase)
    if [ $(echo "$duration_hours > 4" | bc) -eq 1 ]; then
        risk_score=$((risk_score + 80))
    elif [ $(echo "$duration_hours > 2" | bc) -eq 1 ]; then
        risk_score=$((risk_score + 40))
    elif [ $(echo "$duration_hours > 1" | bc) -eq 1 ]; then
        risk_score=$((risk_score + 15))
    fi

    # High productivity during long sessions (flow state risk)
    if [ $(echo "$productivity_rate > 5" | bc) -eq 1 ] && [ $(echo "$duration_hours > 1.5" | bc) -eq 1 ]; then
        risk_score=$((risk_score + 30))
    fi

    # Time of day risk (evening hyperfocus common)
    if [ $time_of_day -gt 18 ] || [ $time_of_day -lt 3 ]; then  # 6PM-3AM
        risk_score=$((risk_score + 20))
    fi

    # Historical pattern risk
    local recent_hyperfocus=$(echo "$previous_session_data" | grep -c "hyperfocus")
    if [ $recent_hyperfocus -gt 2 ]; then  # Recent hyperfocus episodes
        risk_score=$((risk_score + 25))
    fi

    echo $risk_score
}
```

## Intervention Strategies and Alerts

### 1. Break Reminders
```bash
generate_break_reminder() {
    local duration_ms=$1
    local hyperfocus_risk=$2
    local productivity_rate=$3

    local duration_hours=$(echo "$duration_ms / 3600000" | bc -l)

    if [ $hyperfocus_risk -gt 60 ]; then
        echo "🚨 HYPERFOCUS ALERT: You've been coding for ${duration_hours} hours. Time for a break! Your brain needs rest to maintain peak performance."
    elif [ $(echo "$duration_hours > 1.5" | bc) -eq 1 ]; then
        echo "⏰ Break Suggestion: ${duration_hours} hours of focused work! Consider a 10-15 minute break to recharge."
    elif [ $(echo "$productivity_rate < 1" | bc) -eq 1 ] && [ $(echo "$duration_hours > 0.5" | bc) -eq 1 ]; then
        echo "🔄 Energy Check: Productivity seems low. Maybe time for a quick break or switch of pace?"
    fi
}
```

### 2. Focus Enhancement Suggestions
```bash
suggest_focus_enhancement() {
    local fragmentation_score=$1
    local context_switches=$2
    local api_ratio=$3

    if [ $fragmentation_score -gt 60 ]; then
        echo "🎯 Focus Tip: High distraction detected. Try the Pomodoro technique: 25 min focused work, 5 min break."
    elif [ $context_switches -gt 8 ]; then
        echo "📁 Context Tip: Lots of switching detected. Consider batching similar tasks together."
    elif [ $(echo "$api_ratio > 0.7" | bc) -eq 1 ]; then
        echo "🧠 Clarity Tip: High help-seeking pattern. Take 5 minutes to plan your approach before coding."
    fi
}
```

### 3. Energy Management
```bash
provide_energy_guidance() {
    local energy_level="$1"
    local time_of_day=$2
    local session_count=$3

    case "$energy_level" in
        "crash")
            echo "🔋 Energy Alert: Low energy detected. Consider a longer break, some movement, or switching to lighter tasks."
            ;;
        "low")
            if [ $time_of_day -lt 12 ]; then
                echo "🌅 Morning Energy: Energy ramping up. Light tasks or planning might be good to start."
            else
                echo "⚡ Energy Dip: Try a brief walk, hydration, or switching to review tasks."
            fi
            ;;
        "high")
            if [ $session_count -gt 4 ]; then
                echo "🚀 High Energy: Great productivity! Remember to pace yourself for sustained performance."
            fi
            ;;
    esac
}
```

## Personalization and Adaptation

### 1. User Profile Learning
```bash
# Build user-specific thresholds over time
update_user_profile() {
    local user_id="$1"
    local session_data="$2"
    local profile_file="$HOME/.claude/adhd_profile_${user_id}.json"

    # Track personal patterns:
    # - Peak performance hours
    # - Average session durations
    # - Productivity patterns
    # - Break effectiveness
    # - Context switch tolerance

    if [ ! -f "$profile_file" ]; then
        cat > "$profile_file" << EOF
{
    "peak_hours": [],
    "avg_productive_session": 0,
    "hyperfocus_threshold": 7200000,
    "break_effectiveness": {},
    "context_switch_tolerance": 5,
    "energy_patterns": {},
    "learning_start_date": "$(date -I)"
}
EOF
    fi

    # Update patterns based on session outcome
    local hour=$(date +%H)
    local productivity=$(echo "$session_data" | jq -r '.productivity_rate')

    # Add to profile data for pattern learning
    update_peak_hours "$profile_file" "$hour" "$productivity"
    update_session_patterns "$profile_file" "$session_data"
}
```

### 2. Adaptive Thresholds
```bash
calculate_adaptive_thresholds() {
    local user_profile="$1"
    local recent_performance="$2"

    # Adjust thresholds based on:
    # - Recent performance trends
    # - Seasonal patterns
    # - Stress levels (inferred from productivity variance)
    # - Sleep patterns (inferred from session timing)

    local base_hyperfocus_threshold=$(cat "$user_profile" | jq -r '.hyperfocus_threshold')
    local recent_stress_level=$(calculate_stress_indicators "$recent_performance")

    # Reduce thresholds during high stress periods
    if [ $(echo "$recent_stress_level > 0.7" | bc) -eq 1 ]; then
        local adjusted_threshold=$(echo "$base_hyperfocus_threshold * 0.8" | bc)
        echo $adjusted_threshold
    else
        echo $base_hyperfocus_threshold
    fi
}
```