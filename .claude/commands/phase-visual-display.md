---
allowed-tools: [Read, Write, MultiEdit]
argument-hint: Create visual output system with color-coded indicators and actionable messaging
description: Execute Phase 4 - Visual Display System for ADHD Cognitive Statusline
model: claude-3-5-sonnet-20241022
---

# Visual Display System Phase

Create the visual output system with color-coded indicators, emoji-based state visualization, and actionable messaging for ADHD cognitive states.

## Objectives

1. **Color-Coded State Indicators**
   - Design ANSI color system for cognitive states
   - Implement focus state color mapping (🟢🟡🔴)
   - Create energy level visual indicators
   - Build context switching warning colors

2. **Contextual Messaging System**
   - Design actionable messages ("Take break", "Good flow", "Hyperfocus warning")
   - Implement progressive message escalation
   - Create encouragement and guidance messaging
   - Build ADHD-sensitive communication patterns

3. **Emoji-Based State Visualization**
   - Create cognitive state emoji mapping
   - Implement energy level emoji indicators
   - Design focus state visual representations
   - Build warning and alert emoji systems

4. **Theme System Architecture**
   - Create multiple visual themes (colorful, minimal, text-only)
   - Implement accessibility considerations for distraction-sensitive users
   - Design high-contrast and low-distraction themes
   - Build theme switching and configuration

## Design Requirements

- **ANSI color codes** for terminal compatibility
- **Unicode emoji support** with fallback options
- **Accessible design** for various visual preferences
- **Distraction-aware themes** for ADHD users who find colors/emojis overwhelming

## Visual Specifications

### Color Mapping
```
Focus States:
- Deep Focus: Green (🟢)
- Normal Focus: Yellow (🟡)
- Scattered: Red (🔴)
- Starting Up: Blue (🔵)

Energy Levels:
- High: Bright colors, ⚡ emoji
- Medium: Standard colors, ⚖️ emoji
- Low: Dimmed colors, 🔋 emoji
- Crash: Red warning, ⚠️ emoji
```

### Message Categories
- **Encouragement**: "Great focus!" "Good momentum!"
- **Guidance**: "Consider a break" "Time to switch tasks"
- **Warnings**: "Hyperfocus detected" "Energy crash incoming"
- **Information**: Current state and duration

## Expected Deliverables

- Complete ANSI color system implementation
- Contextual messaging engine with templates
- Emoji-based state visualization system
- Multi-theme architecture with accessibility options
- Visual customization and configuration system

Focus on clear, helpful visual feedback that supports ADHD cognitive awareness without being overwhelming or distracting.