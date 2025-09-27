# Claude Code Statusline Data Categories

## 1. Session Identity & Context
**Use Cases**: Session tracking, context management, debugging
- `session_id` - Unique session identifier
- `transcript_path` - Conversation history location
- `hook_event_name` - Event type (always "Status")

**ADHD Applications**:
- Session continuity tracking
- Context switching detection
- Work session boundaries

---

## 2. Workspace & Navigation
**Use Cases**: Project awareness, directory tracking, context switching analysis
- `cwd` - Current working directory
- `workspace.current_dir` - Current workspace directory
- `workspace.project_dir` - Original project root

**ADHD Applications**:
- Context switching frequency analysis
- Project focus measurement
- Directory jumping patterns
- Workspace organization insights

---

## 3. Model & System Information
**Use Cases**: Model awareness, system diagnostics, compatibility
- `model.id` - Technical model identifier
- `model.display_name` - Human-readable model name
- `version` - Claude Code version
- `output_style.name` - Current theme/style

**ADHD Applications**:
- Model performance correlation with focus
- Version tracking for consistency
- Visual style preferences for attention

---

## 4. Performance & Cost Metrics
**Use Cases**: Usage tracking, performance analysis, budget management
- `cost.total_cost_usd` - Financial cost tracking
- `cost.total_duration_ms` - Time spent in session
- `cost.total_api_duration_ms` - API response time

**ADHD Applications**:
- Session duration patterns (hyperfocus detection)
- Cost-per-focus-period analysis
- API response time as cognitive load indicator
- Break timing recommendations

---

## 5. Productivity & Code Metrics
**Use Cases**: Code productivity, work velocity, output measurement
- `cost.total_lines_added` - Code production rate
- `cost.total_lines_removed` - Code refinement activity

**ADHD Applications**:
- Productivity velocity patterns
- Code quality vs. speed correlation
- Energy level indicators through output
- Hyperfocus vs. normal productivity states

---

## Data Relationships for Cognitive Analysis

### Focus State Indicators
- **Duration** + **Lines Added/Removed** = Productivity velocity
- **API Duration** + **Total Duration** = Cognitive load ratio
- **Current Dir** changes = Context switching frequency

### Energy Level Assessment
- **Lines Added per Minute** = Energy/motivation indicator
- **Cost per Line** = Efficiency metric
- **API Response patterns** = Attention sustainability

### Context Switching Analysis
- **Directory changes per session** = Attention fragmentation
- **Session duration vs. directory stability** = Focus sustainability
- **Project vs. current directory drift** = Task scope expansion

### Hyperfocus Detection
- **Extended session duration** (>2 hours)
- **High lines added** with **low directory changes**
- **Consistent API timing** patterns
- **Low cost-per-line** efficiency

---

## Extended Categories (Community Tools)

### Git Integration
- Branch information
- Repository status
- Commit patterns

### Time & Schedule
- Real-time clock
- Session timestamps
- Break reminders

### Environmental Context
- Weather conditions
- System resource usage
- External API data

### Budget & Usage
- Daily/weekly limits
- Usage forecasting
- Cost alerts