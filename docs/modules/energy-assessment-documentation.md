# Energy Assessment Module Documentation

**File**: `/home/bch/.claude/modules/energy-assessment.sh`
**Size**: 8.6k (244 lines)
**Purpose**: Circadian-aware productivity analysis with mathematical energy modeling for ADHD cognitive states

## 🎯 Core Function

Calculates real-time energy levels using productivity velocity, circadian rhythms, API usage patterns, and context switching penalties to provide ADHD-specific cognitive state assessment.

## 🚀 CLI Commands

### Energy Assessment
```bash
# Full energy analysis (lines, duration, api_ratio, context_score)
~/.claude/modules/energy-assessment.sh 150 90 12 35

# Get specific components
~/.claude/modules/energy-assessment.sh 150 90 12 35 assessment    # Full JSON
~/.claude/modules/energy-assessment.sh 150 90 12 35 category     # high/medium/low
~/.claude/modules/energy-assessment.sh 150 90 12 35 indicator    # Visual display
~/.claude/modules/energy-assessment.sh 150 90 12 35 circadian   # Current modifier
```

### Direct Function Calls
```bash
# As sourced module
source ~/.claude/modules/energy-assessment.sh

# Calculate circadian modifier for current time
modifier=$(get_circadian_modifier)

# Calculate productivity velocity
velocity=$(calculate_productivity_velocity 150 90)

# Full assessment
assessment=$(assess_energy_level 2.1 12 35 90)
```

## 📊 Data Formats

### Input Parameters
```bash
lines_added=150        # Code lines added in session
duration_min=90        # Session duration in minutes
api_ratio=12          # Percentage of API/help-seeking calls
context_score=35      # Context switching fragmentation score (0-100)
```

### Output: Energy Assessment JSON
```json
{
    "energy_score": 1.85,
    "circadian_modifier": 1.2,
    "productivity_velocity": 1.54,
    "api_penalty": 0.8,
    "context_penalty": 0.85,
    "fatigue_factor": 0.9,
    "threshold_high": 3.0,
    "threshold_medium": 1.44,
    "threshold_low": 0.6,
    "timestamp": 1699123456
}
```

### Output: Energy Categories
- **"high"**: Above circadian-adjusted high threshold
- **"medium"**: Between medium and high thresholds
- **"low"**: Below medium threshold

### Output: Visual Indicators
```bash
🔋 peak   # High energy during circadian peak (bright green)
🔋 high   # High energy normal times (green)
⚡ medium # Medium energy (cyan)
⚡ tired  # Medium energy during circadian low (yellow)
🔸 low    # Low energy (orange)
😴 night  # Low energy during night mode (gray)
```

## 🔧 Key Functions

### `get_circadian_modifier()`
- **Purpose**: Calculate time-of-day energy adjustment using ADHD-specific patterns
- **Algorithm**: Sinusoidal functions combining 24-hour and 90-minute cycles
- **ADHD Features**:
  - Morning peak (9-11AM): 1.3x modifier - dopamine naturally higher
  - Post-lunch dip (1-3PM): 0.6x modifier - more pronounced in ADHD
  - Evening hyperfocus (8-11PM): 1.2x modifier - common ADHD pattern
  - Night mode (11PM-6AM): 0.4x modifier - should be low
- **Mathematical Model**:
  ```bash
  primary_cycle = 1 + 0.3 * sin((2π * (hour - 6)) / 24)
  ultradian_cycle = 1 + 0.15 * sin((2π * hour) / 1.5)
  total_modifier = primary_cycle * ultradian_cycle * adhd_factor
  ```

### `calculate_productivity_velocity(lines_added, duration_min)`
- **Purpose**: Calculate sustained productivity rate with temporal smoothing
- **Algorithm**:
  ```bash
  base_rate = lines_added / duration_min
  smoothed_rate = base_rate * ln(duration_min + 1) / ln(61)  # Prevents burst bias
  adjusted_rate = smoothed_rate / circadian_modifier         # Normalize for time
  ```
- **ADHD Features**:
  - Logarithmic smoothing prevents hyperfocus bursts from skewing averages
  - Circadian normalization accounts for natural energy fluctuations
  - Sustained work rewarded over sporadic bursts

### `assess_energy_level(velocity, api_ratio, context_score, duration)`
- **Purpose**: Comprehensive energy calculation with multiple penalty factors
- **Base Energy**: `productivity_velocity × circadian_modifier`
- **Penalty Factors**:
  - **API Penalty**: 0.6x if >30% help-seeking, 0.8x if >15% (cognitive fatigue)
  - **Context Penalty**: 0.7x if >60 switching, 0.85x if >30 (cognitive overhead)
  - **Fatigue Factor**: 0.6x after 3hrs, 0.8x after 2hrs, 0.9x after 1.5hrs
- **Final Score**: `base_energy × api_penalty × context_penalty × fatigue_factor`

### `get_energy_category(energy_assessment)`
- **Purpose**: Categorize energy level against circadian-adjusted thresholds
- **Dynamic Thresholds**:
  - High: `2.5 × circadian_modifier`
  - Medium: `1.2 × circadian_modifier`
  - Low: `0.5 × circadian_modifier`
- **ADHD Feature**: Thresholds adapt to natural energy fluctuations

## 🧠 ADHD-Specific Features

### Circadian Pattern Recognition
- **Morning Peak Detection**: Identifies natural ADHD dopamine highs
- **Post-Lunch Dip Compensation**: Accounts for pronounced afternoon energy drops
- **Evening Hyperfocus Risk**: Detects and adjusts for common ADHD late-night productivity spikes
- **Ultradian Rhythms**: 90-minute attention cycles overlay daily patterns

### Cognitive Load Modeling
- **API Ratio Analysis**: High help-seeking indicates cognitive fatigue or overwhelm
- **Context Switching Penalties**: Quantifies attention regulation costs
- **Duration Fatigue**: Models mental exhaustion accumulation over time
- **Burst vs. Sustained Work**: Rewards consistent productivity over sporadic bursts

### Adaptive Thresholds
- **Time-Sensitive**: Energy expectations adjust based on circadian state
- **Profile Integration**: Works with config-manager.sh for personalized thresholds
- **Dynamic Scaling**: What constitutes "high energy" varies by time of day

## 🔌 Integration Points

### With Config Manager
```bash
# Get profile-specific energy thresholds
profile=$(~/.claude/modules/config-manager.sh current)
thresholds=$(~/.claude/modules/config-manager.sh energy "$profile")
high_threshold=$(echo "$thresholds" | jq -r '.high')

# Compare against assessment
assessment=$(assess_energy_level 2.1 12 35 90)
energy_score=$(echo "$assessment" | jq -r '.energy_score')
```

### With Context Switching Analyzer
```bash
# Get context fragmentation score
context_metrics=$(~/.claude/modules/context-switching-analyzer.sh current metrics)
context_score=$(echo "$context_metrics" | jq -r '.fragmentation_score')

# Use in energy assessment
assessment=$(assess_energy_level 2.1 12 "$context_score" 90)
```

### With Main Statusline
```bash
# Complete energy assessment workflow
lines_added=150
duration_min=90
api_ratio=12

# Get context score
context_score=$(~/.claude/modules/context-switching-analyzer.sh current metrics | jq -r '.fragmentation_score')

# Calculate energy
assessment=$(~/.claude/modules/energy-assessment.sh "$lines_added" "$duration_min" "$api_ratio" "$context_score" assessment)

# Extract for display
category=$(echo "$assessment" | jq -r '.energy_score' | xargs -I {} ~/.claude/modules/energy-assessment.sh 0 1 0 0 category)
indicator=$(~/.claude/modules/energy-assessment.sh "$lines_added" "$duration_min" "$api_ratio" "$context_score" indicator)
```

## 💡 Usage Examples

### Basic Energy Assessment
```bash
# Assess current productivity: 150 lines in 90 minutes, 12% API calls, 35 context score
~/.claude/modules/energy-assessment.sh 150 90 12 35

# Output:
{
    "energy_score": 1.85,
    "circadian_modifier": 1.2,
    "productivity_velocity": 1.54,
    "api_penalty": 0.8,
    "context_penalty": 0.85,
    "fatigue_factor": 0.9,
    "threshold_high": 3.0,
    "threshold_medium": 1.44,
    "threshold_low": 0.6,
    "timestamp": 1699123456
}
Category: medium
⚡ medium
```

### Circadian Analysis
```bash
# Check current circadian state
modifier=$(~/.claude/modules/energy-assessment.sh 0 1 0 0 circadian)
echo "Current circadian modifier: $modifier"

# Morning peak example (10 AM)
# Output: 1.3

# Post-lunch dip example (2 PM)
# Output: 0.6

# Evening hyperfocus risk (9 PM)
# Output: 1.2
```

### Real-time Integration
```bash
#!/bin/bash
# Statusline integration example

# Get session data
lines_added=$(count_lines_added)
duration_min=$(get_session_duration_minutes)
api_ratio=$(calculate_api_ratio)

# Get context fragmentation
context_data=$(~/.claude/modules/context-switching-analyzer.sh current metrics)
context_score=$(echo "$context_data" | jq -r '.fragmentation_score')

# Calculate energy
energy_assessment=$(~/.claude/modules/energy-assessment.sh "$lines_added" "$duration_min" "$api_ratio" "$context_score" assessment)

# Get display elements
category=$(echo "$energy_assessment" | jq -r '.energy_score' | awk '{if($1>=3.0) print "high"; else if($1>=1.44) print "medium"; else print "low"}')
circadian=$(echo "$energy_assessment" | jq -r '.circadian_modifier')

# Generate indicator
indicator=$(~/.claude/modules/energy-assessment.sh "$lines_added" "$duration_min" "$api_ratio" "$context_score" indicator)

echo "Energy: $indicator ($category, circadian: $circadian)"
```

## 📈 Algorithm Details

### Productivity Velocity Calculation
```bash
# Raw rate
base_rate = lines_added / duration_minutes

# Temporal smoothing (prevents burst bias)
smoothed_rate = base_rate * ln(duration + 1) / ln(61)

# Circadian normalization
final_velocity = smoothed_rate / circadian_modifier
```

### Energy Score Calculation
```bash
# Base energy (circadian-adjusted productivity)
base_energy = productivity_velocity * circadian_modifier

# Apply penalties
final_energy = base_energy * api_penalty * context_penalty * fatigue_factor

# Where penalties are:
api_penalty    = 0.6 if api_ratio > 30%, 0.8 if > 15%, else 1.0
context_penalty = 0.7 if context > 60, 0.85 if > 30, else 1.0
fatigue_factor = 0.6 if duration > 180min, 0.8 if > 120min, 0.9 if > 90min, else 1.0
```

### Circadian Modeling
```bash
# Primary 24-hour cycle
primary = 1 + 0.3 * sin((2π * (hour - 6)) / 24)

# Secondary 90-minute ultradian cycle
ultradian = 1 + 0.15 * sin((2π * hour) / 1.5)

# ADHD-specific time-based modifiers
if (9 <= hour <= 11):   adhd_factor = 1.3  # Morning peak
elif (13 <= hour <= 15): adhd_factor = 0.6  # Post-lunch dip
elif (20 <= hour <= 23): adhd_factor = 1.2  # Evening hyperfocus
# ... etc

# Combined modifier
total_modifier = primary * ultradian * adhd_factor
```

## ⚠️ Error Conditions

### Invalid Input
- **Negative Values**: Duration ≤ 0 returns velocity of 0
- **Missing bc Command**: Fallbacks to basic arithmetic where possible
- **Extreme Values**: Modifiers clamped to reasonable bounds (0.3-2.0)

### Mathematical Dependencies
- **bc Requirement**: Uses `bc -l` for floating-point calculations
- **Fallback Behavior**: Returns "0" or defaults if bc unavailable
- **Precision**: Calculations to 3-4 decimal places for accuracy

## 🎨 Visual Output

### Energy Indicators with ANSI Colors
```bash
🔋 peak    # \033[1;92m (bright green) - high energy during circadian peak
🔋 high    # \033[92m (green) - high energy normal times
⚡ medium  # \033[96m (cyan) - medium energy
⚡ tired   # \033[93m (yellow) - medium energy during circadian low
🔸 low     # \033[38;5;208m (orange) - low energy
😴 night   # \033[90m (gray) - low energy during night mode
```

### Example Statusline Output
```bash
Energy: 🔋 high (2.1, circadian: 1.3)
Energy: ⚡ tired (1.2, circadian: 0.6)
Energy: 🔸 low (0.8, circadian: 0.9)
```

## 🔄 Return Codes

- **0**: Success - valid energy assessment returned
- **Non-zero**: Mathematical calculation errors (rare with fallbacks)
- **Graceful Degradation**: Always returns usable values, even with errors