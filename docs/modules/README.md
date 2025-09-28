# ADHD Cognitive Statusline - Production Modules Overview

This directory contains 4 production-ready modules that work together to provide real-time ADHD cognitive state assessment in Claude Code's statusline.

## 📁 Module Files

| Module | Size | Purpose | Key Features |
|--------|------|---------|--------------|
| [config-manager.sh](config-manager-documentation.md) | 9.8k | Profile management & configuration | ADHD-specific profiles, JSON validation, threshold management |
| [context-switching-analyzer.sh](context-switching-analyzer-documentation.md) | 5.9k | Attention fragmentation detection | Directory/branch tracking, fragmentation scoring, focus indicators |
| [energy-assessment.sh](energy-assessment-documentation.md) | 8.6k | Circadian-aware productivity analysis | Mathematical energy modeling, circadian rhythms, fatigue detection |
| [behavioral-analyzer.sh](behavioral-analyzer-documentation.md) | 8.0k | ADHD behavioral pattern recognition | Tool velocity, task switching, error pattern analysis |

## 🔄 Module Integration Flow

```
┌─────────────────┐    ┌──────────────────────┐    ┌─────────────────────┐
│ Config Manager  │───▶│ Context Switching    │───▶│ Energy Assessment   │
│                 │    │ Analyzer             │    │                     │
│ • Load profile  │    │ • Track switching    │    │ • Calculate energy  │
│ • Get thresholds│    │ • Score fragmentation│    │ • Apply penalties   │
│ • Visual prefs  │    │ • Focus indicators   │    │ • Circadian adjust  │
└─────────────────┘    └──────────────────────┘    └─────────────────────┘
         │                       │                           │
         │                       ▼                           │
         │              ┌─────────────────────┐              │
         └─────────────▶│ Behavioral Analyzer │◀─────────────┘
                        │                     │
                        │ • Tool velocity     │
                        │ • Error patterns    │
                        │ • Task switching    │
                        │ • Fatigue detection │
                        └─────────────────────┘
                                   │
                                   ▼
                        ┌─────────────────────┐
                        │ Main Statusline     │
                        │                     │
                        │ • Combine metrics   │
                        │ • Generate display  │
                        │ • Apply profile     │
                        │ • Show indicators   │
                        └─────────────────────┘
```

## 🚀 Quick Start Integration

### 1. Basic Statusline Integration
```bash
#!/bin/bash
# Minimal statusline using all modules

# Get current profile and session data
profile=$(~/.claude/modules/config-manager.sh current)
session_id="current-session"

# Get context fragmentation
context_metrics=$(~/.claude/modules/context-switching-analyzer.sh "$session_id" metrics)
fragmentation_score=$(echo "$context_metrics" | jq -r '.fragmentation_score')

# Calculate energy (example values)
lines_added=150
duration_min=90
api_ratio=12

energy_assessment=$(~/.claude/modules/energy-assessment.sh "$lines_added" "$duration_min" "$api_ratio" "$fragmentation_score" assessment)
energy_category=$(echo "$energy_assessment" | jq -r '.energy_score' | awk '{if($1>=2.5) print "high"; else if($1>=1.2) print "medium"; else print "low"}')

# Get behavioral pattern
behavioral_assessment=$(~/.claude/modules/behavioral-analyzer.sh assessment "$session_id" 3600)
pattern=$(echo "$behavioral_assessment" | jq -r '.tool_velocity.pattern')

# Generate display
context_indicator=$(~/.claude/modules/context-switching-analyzer.sh "$session_id" indicator)
energy_indicator=$(~/.claude/modules/energy-assessment.sh "$lines_added" "$duration_min" "$api_ratio" "$fragmentation_score" indicator)

echo "ADHD: $energy_indicator $context_indicator [$pattern] ($profile)"
```

### 2. Profile-Aware Integration
```bash
#!/bin/bash
# Advanced integration with profile-specific thresholds

# Load profile configuration
profile=$(~/.claude/modules/config-manager.sh current)
energy_thresholds=$(~/.claude/modules/config-manager.sh energy "$profile")
context_thresholds=$(~/.claude/modules/config-manager.sh context "$profile")
visual_prefs=$(~/.claude/modules/config-manager.sh visual "$profile")

# Extract profile-specific thresholds
high_energy_threshold=$(echo "$energy_thresholds" | jq -r '.high')
scattered_threshold=$(echo "$context_thresholds" | jq -r '.scattered_threshold')
use_colors=$(echo "$visual_prefs" | jq -r '.use_colors')

# Get current metrics
energy_score=$(get_current_energy_score)  # Your implementation
fragmentation_score=$(get_current_fragmentation_score)  # Your implementation

# Apply profile-specific logic
if (( $(echo "$fragmentation_score > $scattered_threshold" | bc -l) )); then
    if [[ "$use_colors" == "true" ]]; then
        echo -e "\033[93m⚠️ High fragmentation for $profile profile\033[0m"
    else
        echo "⚠️ High fragmentation for $profile profile"
    fi
fi
```

## 🧠 ADHD-Specific Features Across Modules

### Hyperfocus Detection & Prevention
- **Config Manager**: Profile-specific hyperfocus thresholds (75-180 minutes)
- **Energy Assessment**: Extended session fatigue detection
- **Behavioral Analyzer**: Zero context switches = potential hyperfocus
- **Integration**: Progressive warnings with break recommendations

### Attention Fragmentation Assessment
- **Context Switching Analyzer**: 0-100 fragmentation scoring
- **Config Manager**: Profile-specific tolerance thresholds
- **Energy Assessment**: Context switching penalties (up to 30% energy reduction)
- **Behavioral Analyzer**: Task switching frequency analysis

### Circadian Rhythm Integration
- **Energy Assessment**: Mathematical circadian modeling
- **Config Manager**: Time-sensitive threshold adjustments
- **Integration**: Energy expectations adapt to natural ADHD patterns

### Cognitive Fatigue Detection
- **Energy Assessment**: Duration-based fatigue factors
- **Behavioral Analyzer**: Error pattern recognition
- **Context Switching**: High fragmentation as fatigue indicator
- **Integration**: Multi-dimensional fatigue assessment

## 📊 Data Flow Examples

### Complete Assessment Pipeline
```bash
# 1. Load profile configuration
profile=$(~/.claude/modules/config-manager.sh current)

# 2. Get context metrics
context_data=$(~/.claude/modules/context-switching-analyzer.sh current metrics)
fragmentation_score=$(echo "$context_data" | jq -r '.fragmentation_score')

# 3. Calculate energy with context penalty
energy_data=$(~/.claude/modules/energy-assessment.sh 150 90 12 "$fragmentation_score" assessment)
energy_score=$(echo "$energy_data" | jq -r '.energy_score')

# 4. Get behavioral patterns
behavioral_data=$(~/.claude/modules/behavioral-analyzer.sh assessment current 3600)
velocity_pattern=$(echo "$behavioral_data" | jq -r '.tool_velocity.pattern')

# 5. Generate integrated assessment
echo "{
    \"profile\": \"$profile\",
    \"fragmentation_score\": $fragmentation_score,
    \"energy_score\": $energy_score,
    \"behavioral_pattern\": \"$velocity_pattern\",
    \"timestamp\": $(date +%s)
}"
```

### Real-time Status Generation
```bash
# Get visual indicators from each module
context_indicator=$(~/.claude/modules/context-switching-analyzer.sh current indicator)
energy_indicator=$(~/.claude/modules/energy-assessment.sh 150 90 12 35 indicator)

# Get profile for context
profile=$(~/.claude/modules/config-manager.sh current)

# Generate statusline
echo "ADHD: $energy_indicator $context_indicator [$profile]"
# Output: ADHD: ⚡ medium 🎯 [inattentive]
```

## 🛠️ Development Patterns

### Error Handling Strategy
All modules implement graceful degradation:
```bash
# Each module provides fallback values
config_data=$(load_config "$profile" 2>/dev/null || echo '{"fallback": true}')
context_score=$(get_fragmentation_score 2>/dev/null || echo "0")
energy_score=$(calculate_energy 2>/dev/null || echo "1.0")
```

### Performance Optimization
- **Sub-300ms execution**: All modules optimized for statusline responsiveness
- **Efficient log processing**: AWK-based parsing for minimal memory usage
- **Cached calculations**: Avoid redundant calculations within time windows

### Modularity Design
- **Independent operation**: Each module works standalone
- **Optional integration**: Enhanced features when multiple modules available
- **Graceful fallbacks**: Missing modules don't break core functionality

## 📝 Documentation Links

- [Config Manager Documentation](config-manager-documentation.md) - Profile management and configuration
- [Context Switching Analyzer Documentation](context-switching-analyzer-documentation.md) - Attention fragmentation detection
- [Energy Assessment Documentation](energy-assessment-documentation.md) - Productivity and circadian analysis
- [Behavioral Analyzer Documentation](behavioral-analyzer-documentation.md) - Pattern recognition and fatigue detection

## 🎯 Module Selection Guide

### For Basic ADHD Support
**Minimum**: Config Manager + Context Switching Analyzer
- Profile-based thresholds
- Basic attention fragmentation detection
- Visual focus indicators

### For Comprehensive Assessment
**Recommended**: All 4 modules
- Complete cognitive state assessment
- Circadian-aware energy modeling
- Behavioral pattern recognition
- Multi-dimensional fatigue detection

### For Specific Use Cases
- **Hyperfocus Prevention**: Energy Assessment + Behavioral Analyzer
- **Attention Training**: Context Switching Analyzer + Config Manager
- **Productivity Optimization**: Energy Assessment + Config Manager
- **Fatigue Management**: Behavioral Analyzer + Energy Assessment

## 🔧 Customization

Each module supports extensive customization through:
- **JSON profiles**: ADHD presentation-specific configurations
- **Threshold adjustment**: Personal cognitive patterns
- **Visual preferences**: Distraction-sensitive display options
- **Time window configuration**: Attention span-appropriate analysis periods