# ADHD Cognitive Statusline Enhancement Implementation Plan

## Analysis of Current State

Based on the comprehensive documentation and lessons learned, we have:

### ✅ **Current Assets Ready for Enhancement**
- **Working basic statusline**: Real ADHD cognitive assessment operational
- **Complete research foundation**: 50+ pages of cognitive algorithms and patterns documented
- **Comprehensive documentation**: Full data structure mapping and customization guides
- **Lessons learned**: Clear understanding of what failed and why in previous attempts

### 🎯 **Implementation Strategy: Incremental Enhancement**

**Key Lesson**: Start simple, add complexity gradually with validation at each step (avoiding the 1400+ line overengineering that failed previously)

## Implementation Plan

### **Phase 1: Enhanced Visual Display (2-4 hours)**

#### **Goal**: Implement color-coded cognitive states and improved visual feedback
#### **Approach**: Extend existing working statusline with ANSI colors and emoji enhancements

**Tasks**:
1. **Add ANSI color support** to existing statusline script
   - Focus states: 🎯 deep (green), ✨ focused (blue), 💫 scattered (yellow), 💭 unfocused (red)
   - Energy levels: 🔋 high (bright green), ⚡ medium (cyan), 🔸 low (orange), 😴 fatigue (red)
   - Warning states: ◯ check-in (white), ⚠️ break-soon (yellow), 🚨 BREAK NOW (red blink)

2. **Enhance emoji indicators** with documented cognitive state mapping
   - Use research-validated thresholds from `cognitive-data-mapping.md`
   - Implement progressive warning system (check-in → break-soon → BREAK NOW!)

3. **Add ASCII progress indicators** for session duration
   - Simple progress bars using documented patterns
   - Visual time progression without overwhelming information density

**Environment**: Pure bash + jq (no additional dependencies, respects statusline constraints)

### **Phase 2: Context Switching Detection (4-6 hours)**

#### **Goal**: Integrate directory change analysis for attention fragmentation detection
#### **Approach**: Use hook system integration documented in `/logs/hook-logs-debugging.md`

**Tasks**:
1. **Set up bash command logging hook**
   - Configure PreToolUse hook to capture directory changes
   - Use documented hook configuration patterns

2. **Implement context switching analysis**
   - Count `cd` commands per session using documented algorithms
   - Add attention fragmentation scoring (>8 switches/hour = scattered)

3. **Integrate with statusline display**
   - Add context switching indicator to existing statusline
   - Use cached data approach for performance (<300ms constraint)

**Environment**: Hook logs + filesystem monitoring (no additional packages)

### **Phase 3: Advanced Energy Assessment (6-8 hours)**

#### **Goal**: Implement circadian-aware productivity analysis with mathematical formulas
#### **Approach**: Use documented energy assessment algorithms from research

**Tasks**:
1. **Implement circadian modifiers**
   - Morning peak (9-11am): 1.2x modifier
   - Post-lunch dip (2-4pm): 0.8x modifier
   - Evening decline: progressive reduction

2. **Add productivity velocity calculations**
   - Lines added per minute with time-based adjustments
   - API efficiency ratios for cognitive load assessment

3. **Integrate with existing cognitive state detection**
   - Combine duration + productivity + circadian factors
   - Maintain backward compatibility with current working version

**Environment**: Pure bash with `bc` for floating-point math (already documented)

### **Phase 4: Configuration System (1-2 days)**

#### **Goal**: Build JSON-based user preference management for personalized ADHD thresholds
#### **Approach**: Use documented configuration patterns and avoid previous complexity issues

**Tasks**:
1. **Create simple JSON configuration structure**
   - User-specific thresholds for hyperfocus warnings
   - Customizable visual themes and emoji preferences
   - Profile selection (6 ADHD types from research)

2. **Implement configuration loading with fallbacks**
   - Graceful degradation if config missing (lesson from previous failures)
   - Validate JSON syntax before use
   - Clear error messages for configuration issues

3. **Add configuration validation tools**
   - Simple checker script for JSON syntax
   - Configuration hierarchy documentation (global vs project-local)

**Environment**: JSON config files + jq parsing (leveraging existing uv project structure)

### **Phase 5: Hook System Integration (1-2 days)**

#### **Goal**: Complete behavioral data collection using documented hook patterns
#### **Approach**: Implement comprehensive hook logging for advanced analysis

**Tasks**:
1. **Set up comprehensive hook collection**
   - PreToolUse, PostToolUse, SessionStart/End hooks
   - Tool usage pattern analysis
   - Session boundary detection

2. **Build behavioral pattern recognition**
   - Tool velocity analysis for energy detection
   - Error pattern recognition for fatigue indicators
   - Task switching patterns for focus assessment

3. **Integrate with persistent state management**
   - Session-to-session memory using documented patterns
   - Historical trend recognition (simple averages initially)

**Environment**: Hook system + state files (no external databases, filesystem-based)

## **Environment & Dependencies Strategy**

### **Statusline Environment Context**
- **Execution Environment**: Claude Code statusline runs in project context, not isolated environment
- **Dependencies**: Statusline inherits project environment but should minimize dependencies
- **Performance**: Must complete in <300ms, no heavy Python imports

### **Package Management Strategy**
1. **Core Statusline**: Pure bash + jq (no Python dependencies for performance)
2. **Configuration Tools**: Use uv for any Python utilities (configuration validation, setup scripts)
3. **Development Scripts**: Use `uv run` for development and testing utilities

**Commands**:
```bash
# Configuration validation utility
uv add click pydantic  # For config validation scripts
uv run validate-adhd-config.py

# Development testing
uv run test-statusline.py

# Core statusline remains pure bash for performance
```

## **Key Principles from Lessons Learned**

1. **Start Simple**: Begin with working statusline, add features incrementally
2. **Validate Early**: Test each enhancement against real Claude Code environment
3. **Performance First**: Respect 300ms constraint, cache expensive operations
4. **Graceful Degradation**: Every feature must work even if data missing
5. **Configuration Debugging**: Always provide clear error messages for config issues

## **Success Criteria**

### **Phase 1**: Color-coded statusline with enhanced visual feedback
### **Phase 2**: Context switching detection showing attention patterns
### **Phase 3**: Circadian-aware energy assessment with productivity correlation
### **Phase 4**: User-configurable thresholds and personalized ADHD profiles
### **Phase 5**: Complete behavioral pattern recognition with historical awareness

## **Risk Mitigation**

- **Configuration Hierarchy Issues**: Document and test settings precedence early
- **Performance Degradation**: Profile each enhancement, cache expensive operations
- **Data Structure Changes**: Build robust field validation with informative fallbacks
- **Over-Engineering**: Keep each phase focused, avoid feature creep

This plan builds incrementally on the existing working foundation while avoiding the complexity pitfalls that caused previous implementation issues.