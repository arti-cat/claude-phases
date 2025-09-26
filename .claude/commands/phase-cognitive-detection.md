---
allowed-tools: [Read, Write, MultiEdit, Bash(bc:*)]
argument-hint: Implement core cognitive state detection algorithms using session behavioral data
description: Execute Phase 3 - Cognitive Detection Engine for ADHD Cognitive Statusline
model: claude-3-5-sonnet-20241022
---

# Cognitive Detection Engine Phase

Implement the core cognitive state detection algorithms using session behavioral data to accurately assess ADHD-specific mental states.

## Objectives

1. **Focus State Detection**
   - Implement session duration pattern analysis
   - Create consistency metrics for sustained attention
   - Design focus vs. scattered attention algorithms
   - Build momentum detection for "getting into flow"

2. **Energy Level Assessment**
   - Calculate productivity velocity from file changes
   - Implement energy trend analysis over time windows
   - Design high/low energy state detection
   - Create energy crash warning systems

3. **Context Switching Detection**
   - Track directory and project change frequency
   - Implement attention fragmentation scoring
   - Design healthy vs. problematic switching detection
   - Create switching pattern analysis

4. **Hyperfocus Warning System**
   - Detect extended sessions without breaks
   - Implement progressive warning escalation
   - Design break recommendation logic
   - Create session health monitoring

## Technical Requirements

- **Mathematical analysis algorithms** with proper calculations
- **Pattern recognition logic** for behavioral trends
- **Threshold-based state detection** with configurable parameters
- **Time-series analysis** for behavioral patterns
- **bc calculator** for floating-point arithmetic in bash

## Algorithm Specifications

### Focus Detection
```
Focus Score = (session_duration * consistency_factor) / context_switches
States: Deep Focus (>0.8), Normal Focus (0.4-0.8), Scattered (<0.4)
```

### Energy Assessment
```
Energy Level = (changes_per_minute * quality_factor) over time_window
Trend Analysis = current_energy / average_energy_last_hour
```

### Context Switching
```
Switch Rate = directory_changes / session_duration
Fragmentation Score = switch_rate * recency_weight
```

## Expected Deliverables

- Complete cognitive detection module functions
- Threshold-based state classification algorithms
- Time-window analysis for pattern recognition
- State transition logic with hysteresis
- Testing framework for algorithm validation

Focus on accuracy, performance, and ADHD-specific behavioral patterns.