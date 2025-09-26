# ADHD Cognitive Detection Algorithm Specifications

## Overview

This document provides complete specifications for all cognitive detection algorithms, including mathematical formulations, threshold values, and validation criteria.

## 1. Focus State Detection Specification

### Algorithm: FocusStateDetector v1.0

**Input Parameters:**
- `duration_ms`: Session duration in milliseconds
- `api_duration_ms`: Total API interaction time
- `lines_added`: Total lines of code added
- `lines_removed`: Total lines of code removed
- `context_switches`: Number of directory/project changes

**Output:** Focus state classification with confidence score

### Mathematical Model

```
Focus Score = (D × 0.30) + (C × 0.25) + (E × 0.25) + (S × 0.20)

Where:
D = Duration Score (0-100)
C = Consistency Score (0-100)
E = Engagement Score (0-100)
S = Stability Score (0-100)
```

### Threshold Definitions

#### Duration Score (D)
```bash
if duration_minutes >= 120:     D = 100  # Extended session
elif duration_minutes >= 60:    D = 85   # Long session
elif duration_minutes >= 30:    D = 70   # Medium session
elif duration_minutes >= 15:    D = 50   # Short session
else:                          D = 20   # Very short session
```

#### Consistency Score (C)
```bash
api_ratio = api_duration_ms / duration_ms
productivity_rate = (lines_added + lines_removed) / duration_minutes

# API Consistency Component (0-100)
if api_ratio <= 0.1:          api_consistency = 100
elif api_ratio <= 0.3:        api_consistency = 85
elif api_ratio <= 0.5:        api_consistency = 60
else:                         api_consistency = 30

# Productivity Consistency Component (0-100)
if productivity_rate >= 5:     prod_consistency = 90
elif productivity_rate >= 2:   prod_consistency = 75
elif productivity_rate >= 0.5: prod_consistency = 60
else:                         prod_consistency = 50

C = (api_consistency + prod_consistency) / 2
```

#### Engagement Score (E)
```bash
net_productivity = (lines_added - lines_removed) / duration_minutes
total_output = (lines_added + lines_removed) / duration_minutes

# Net Productivity Component (0-60)
if net_productivity >= 3:      net_score = 60
elif net_productivity >= 1:    net_score = 45
elif net_productivity >= 0:    net_score = 30
else:                         net_score = 10

# Total Output Component (0-40)
if total_output >= 5:          output_score = 40
elif total_output >= 2:        output_score = 30
elif total_output >= 1:        output_score = 20
else:                         output_score = 10

E = net_score + output_score
```

#### Stability Score (S)
```bash
switch_rate = context_switches / duration_minutes

if switch_rate <= 0.05:        S = 100  # Very stable
elif switch_rate <= 0.1:       S = 80   # Stable
elif switch_rate <= 0.2:       S = 60   # Moderate
elif switch_rate <= 0.4:       S = 40   # Unstable
else:                          S = 20   # Very unstable
```

### State Classification Thresholds

```bash
# Primary classification based on Focus Score
if focus_score >= 85:          state = "deep_focus"
elif focus_score >= 70:        state = "focused"
elif focus_score >= 50:        state = "partially_focused"
else:                         state = "unfocused"

# Override conditions
if duration_minutes > 90 AND focus_score > 75:
    state = "hyperfocus"

if context_switches > 8 OR api_ratio > 0.6:
    state = "scattered"
```

### Confidence Calculation
```bash
confidence = min(100, (sample_size / 10) * base_confidence)

base_confidence = 60 + (focus_score * 0.4)
sample_size = duration_minutes / 15  # 15-minute intervals
```

## 2. Energy Level Assessment Specification

### Algorithm: EnergyAssessment v1.0

**Input Parameters:**
- Session metrics (duration, lines added/removed, API time)
- Temporal context (hour, day of week)
- Historical performance data

### Mathematical Model

```
Energy Score = (P × 0.40) + (E × 0.30) + (S × 0.20) + (Q × 0.10)

Adjusted Score = Energy Score × Circadian Modifier × Historical Modifier

Where:
P = Productivity Rate Score (0-100)
E = Efficiency Ratio Score (0-100)
S = Sustained Effort Score (0-100)
Q = Output Quality Score (0-100)
```

### Productivity Rate Score (P)

```bash
total_output = lines_added + lines_removed
rate = total_output / duration_minutes

# Normalize to 0-100 scale (10+ lines/minute = 100)
P = min(100, (rate / 10) * 100)
```

### Efficiency Ratio Score (E)

```bash
net_output = lines_added - lines_removed
api_minutes = api_duration_ms / 60000

if api_minutes > 0:
    efficiency = net_output / api_minutes
    E = min(100, (efficiency / 5) * 100)  # 5+ lines per API minute = 100
else:
    E = 100  # No API usage indicates high efficiency
```

### Sustained Effort Score (S)

```bash
thinking_time = duration_ms - api_duration_ms
effort_ratio = thinking_time / duration_ms

if effort_ratio >= 0.8:       S = 100  # High sustained effort
elif effort_ratio >= 0.6:     S = 80
elif effort_ratio >= 0.4:     S = 60
elif effort_ratio >= 0.2:     S = 40
else:                         S = 20
```

### Circadian Modifier

```bash
hour = current_hour()

if hour in [9, 10, 11]:       modifier = 1.2   # Morning peak
elif hour in [14, 15, 16]:    modifier = 0.8   # Post-lunch dip
elif hour in [19, 20, 21, 22, 23]: modifier = 1.1   # Evening peak
elif hour in [0, 1, 2]:       modifier = 1.0   # Late night (neutral)
else:                        modifier = 1.0   # Default
```

### Energy Level Classification

```bash
# Check for crash state first
if P < 20 AND S > 60:
    level = "crash"
elif adjusted_score >= 80:
    level = "high"
elif adjusted_score >= 60:
    level = "medium_high"
elif adjusted_score >= 40:
    level = "medium"
elif adjusted_score >= 20:
    level = "low"
else:
    level = "very_low"
```

## 3. Context Switching Analysis Specification

### Algorithm: ContextSwitchAnalyzer v1.0

**Input Parameters:**
- Directory change log
- Session duration
- Project boundary information

### Fragmentation Score Calculation

```
Fragmentation Score = Frequency Penalty + Volume Penalty + Stability Penalty

Where each penalty ranges from 0-40 points
```

#### Frequency Penalty
```bash
switch_frequency = directory_changes / duration_minutes

if switch_frequency > 0.5:     penalty = 40  # >0.5 switches/minute
elif switch_frequency > 0.2:   penalty = 20  # >0.2 switches/minute
else:                         penalty = 0
```

#### Volume Penalty
```bash
if directory_changes > 10:     penalty = 30  # Many switches
elif directory_changes > 5:    penalty = 15  # Moderate switches
else:                         penalty = 0
```

#### Stability Penalty
```bash
# Context stability = time in primary directory / total time
if context_stability < 30:     penalty = 30  # Very unstable
elif context_stability < 60:   penalty = 15  # Moderately unstable
else:                         penalty = 0
```

### Pattern Classification

```bash
total_fragmentation = frequency_penalty + volume_penalty + stability_penalty

if total_fragmentation > 70:
    pattern = "chaotic_switching"
elif total_fragmentation > 40:
    pattern = "high_switching"
elif directory_changes <= 3 AND switch_frequency < 0.1:
    pattern = "mono_focus"
else:
    pattern = "controlled_switching"
```

## 4. Hyperfocus Risk Assessment Specification

### Algorithm: HyperfocusRiskAssessment v1.0

**Risk Calculation Model:**

```
Total Risk = (DR × 0.30) + (FS × 0.25) + (TR × 0.20) + (HR × 0.15) + (BR × 0.10)

Where:
DR = Duration Risk (0-100)
FS = Flow State Risk (0-100)
TR = Temporal Risk (0-100)
HR = Historical Risk (0-100)
BR = Burnout Risk (0-100)
```

### Duration Risk (DR)

```bash
duration_hours = duration_ms / 3600000

if duration_hours > 4:         DR = 95  # Critical
elif duration_hours > 3:       DR = 80  # High
elif duration_hours > 2:       DR = 60  # Elevated
elif duration_hours > 1.5:     DR = 40  # Moderate
elif duration_hours > 1:       DR = 20  # Low
else:                          DR = 5   # Minimal
```

### Flow State Risk (FS)

```bash
# High productivity + low API usage = flow state risk
productivity_risk = 0
if productivity_rate > 80:      productivity_risk = 30
elif productivity_rate > 60:   productivity_risk = 20

api_risk = 0
if api_ratio < 0.2:            api_risk = 25  # Very low API usage
elif api_ratio < 0.4:          api_risk = 15

FS = productivity_risk + api_risk
```

### Temporal Risk (TR)

```bash
hour = current_hour()
day_of_week = current_day_of_week()

# Hour-based risk
if hour in [18, 19, 20, 21, 22, 23]:  hour_risk = 25  # Evening peak
elif hour in [0, 1, 2, 3]:            hour_risk = 30  # Late night high risk
elif hour in [10, 11, 12, 13, 14]:    hour_risk = 15  # Morning peak
else:                                 hour_risk = 5

# Weekend risk (more flexible schedule)
weekend_risk = 10 if day_of_week in [6, 7] else 0

TR = hour_risk + weekend_risk
```

### Warning Level Classification

```bash
if total_risk > 80:
    warning = "CRITICAL_HYPERFOCUS"
    message = "Take a break now to prevent burnout!"
elif total_risk > 60:
    warning = "HIGH_HYPERFOCUS"
    message = "Strong hyperfocus detected. Consider a break soon."
elif total_risk > 40:
    warning = "MODERATE_HYPERFOCUS"
    message = "Extended focus session. Break recommended within 30 minutes."
elif total_risk > 20:
    warning = "MILD_HYPERFOCUS"
    message = "Good focus! Remember to take breaks regularly."
else:
    warning = "NORMAL_FOCUS"
    message = "Healthy work session."
```

## 5. Composite Assessment Specification

### Integration Algorithm

```bash
assess_cognitive_state() {
    # Run all algorithms in parallel
    focus_result = run_focus_detection(session_data)
    energy_result = run_energy_assessment(session_data)
    context_result = run_context_analysis(session_data)
    hyperfocus_result = run_hyperfocus_assessment(session_data)

    # Calculate composite confidence
    composite_confidence = (
        focus_result.confidence * 0.3 +
        energy_result.confidence * 0.3 +
        context_result.confidence * 0.2 +
        hyperfocus_result.confidence * 0.2
    )

    # Generate priority recommendations
    recommendations = prioritize_recommendations(
        focus_result, energy_result, context_result, hyperfocus_result
    )

    return {
        "cognitive_state": {
            "focus": focus_result.state,
            "energy": energy_result.level,
            "context_switching": context_result.pattern,
            "hyperfocus_warning": hyperfocus_result.warning
        },
        "confidence": composite_confidence,
        "recommendations": recommendations,
        "alert_level": calculate_alert_level(hyperfocus_result.risk)
    }
}
```

### Alert Level Calculation

```bash
if hyperfocus_risk > 80:       alert_level = "CRITICAL"
elif hyperfocus_risk > 60:     alert_level = "HIGH"
elif hyperfocus_risk > 40:     alert_level = "MEDIUM"
elif hyperfocus_risk > 20:     alert_level = "LOW"
else:                         alert_level = "NORMAL"
```

## 6. Validation and Calibration

### Algorithm Validation Criteria

**Focus Detection Accuracy:**
- Target: 85%+ accuracy in identifying hyperfocus episodes
- Validation: Compare against user-reported focus states
- Recalibration: Weekly threshold adjustment based on user feedback

**Energy Assessment Precision:**
- Target: 80%+ correlation with user-reported energy levels
- Validation: Daily energy level surveys
- Recalibration: Circadian modifier adjustment based on performance patterns

**Context Switch Detection:**
- Target: 90%+ accuracy in identifying attention fragmentation
- Validation: Compare against screen recording analysis
- Recalibration: Threshold adjustment based on user productivity correlation

### Performance Thresholds

```bash
# Minimum data requirements for reliable assessment
MIN_SESSION_DURATION = 300000  # 5 minutes
MIN_PRODUCTIVITY_SAMPLE = 5    # 5 lines of code
MIN_API_INTERACTIONS = 1       # At least one interaction

# Confidence penalties for insufficient data
if duration < MIN_SESSION_DURATION:
    confidence_penalty = 30

if productivity_sample < MIN_PRODUCTIVITY_SAMPLE:
    confidence_penalty += 20

if api_interactions < MIN_API_INTERACTIONS:
    confidence_penalty += 15
```

This specification provides the mathematical foundation and precise thresholds needed to implement the ADHD cognitive detection system with scientific rigor and measurable outcomes.