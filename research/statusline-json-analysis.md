# Claude Code Statusline JSON Structure Analysis

## Available Data Fields

Based on the Context7 documentation, Claude Code provides the following JSON structure via stdin to statusline scripts:

```json
{
  "hook_event_name": "Status",
  "session_id": "abc123...",
  "transcript_path": "/path/to/transcript.json",
  "cwd": "/current/working/directory",
  "model": {
    "id": "claude-opus-4-1",
    "display_name": "Opus"
  },
  "workspace": {
    "current_dir": "/current/working/directory",
    "project_dir": "/original/project/directory"
  },
  "version": "1.0.80",
  "output_style": {
    "name": "default"
  },
  "cost": {
    "total_cost_usd": 0.01234,
    "total_duration_ms": 45000,
    "total_api_duration_ms": 2300,
    "total_lines_added": 156,
    "total_lines_removed": 23
  }
}
```

## Cognitive State Mapping Potential

### 1. Focus State Detection
**Primary Indicators:**
- `cost.total_duration_ms`: Session duration - key indicator of sustained attention
- `cost.total_api_duration_ms`: Active API time vs. total session time
- `workspace.current_dir` vs `workspace.project_dir`: Context switching detection

**Focus Metrics:**
- **Sustained Focus**: Long sessions (>30min) with consistent API activity
- **Fragmented Attention**: Short bursts with high API/total time ratio
- **Deep Work**: Extended duration with lower API frequency (thinking time)

### 2. Energy Level Assessment
**Primary Indicators:**
- `cost.total_lines_added`: Productivity velocity (output rate)
- `cost.total_lines_removed`: Refactoring/debugging activity
- Net productivity: `lines_added - lines_removed`
- Productivity rate: `net_lines / (duration_ms / 1000 / 60)` (lines per minute)

**Energy Thresholds:**
- **High Energy**: >5 lines/minute net productivity
- **Medium Energy**: 1-5 lines/minute
- **Low Energy**: <1 line/minute or negative net productivity

### 3. Context Switching Analysis
**Primary Indicators:**
- `cwd` changes between statusline calls
- `workspace.current_dir` vs `workspace.project_dir` divergence
- Session fragmentation patterns

**Context Switch Detection:**
- Directory change frequency
- Project boundary crossings
- Multi-project session patterns

### 4. Hyperfocus Warning System
**Primary Indicators:**
- `cost.total_duration_ms` exceeding healthy thresholds
- Extended sessions without breaks
- High productivity during extended periods

**Hyperfocus Thresholds:**
- **Caution**: 90+ minutes continuous session
- **Warning**: 120+ minutes continuous session
- **Alert**: 180+ minutes continuous session

## Data Quality and Limitations

### Available Data Strengths:
1. **Real-time session metrics**: Duration, cost, productivity
2. **Workspace context**: Directory tracking for context switching
3. **Productivity indicators**: Lines added/removed as output metrics
4. **Session continuity**: Session ID for tracking conversation threads

### Limitations:
1. **No direct user input patterns**: No keystroke timing or pause detection
2. **Limited temporal granularity**: Only cumulative session data
3. **No break detection**: Cannot detect user-initiated pauses
4. **No task type differentiation**: Cannot distinguish coding vs. debugging vs. research

## Behavioral Pattern Recognition Opportunities

### 1. ADHD-Specific Patterns
- **Hyperfocus Episodes**: Extended sessions with high productivity
- **Attention Fragmentation**: Frequent context switches
- **Energy Cycles**: Productivity pattern variations throughout day
- **Task Parallelism**: Multiple project engagement patterns

### 2. Cognitive Load Indicators
- **High API/Duration Ratio**: Intensive assistance seeking (cognitive overload)
- **Low Productivity Despite Time**: Possible executive dysfunction
- **Context Switch Clustering**: Attention regulation challenges

## Implementation Strategy

### Data Collection Requirements:
1. **Persistent storage**: Track metrics across sessions
2. **Historical analysis**: Pattern recognition over time
3. **Threshold calibration**: User-specific baseline establishment
4. **Real-time processing**: Immediate cognitive state assessment

### Algorithm Components Needed:
1. **Session state tracker**: Current focus/energy assessment
2. **Pattern analyzer**: Historical behavior analysis
3. **Threshold engine**: Personalized alert system
4. **Trend detector**: Energy and focus pattern recognition