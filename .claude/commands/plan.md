---
allowed-tools: Read, Task
argument-hint: # Reads PLAN.md and triggers planner agent
description: Parse PLAN.md and generate phase-specific commands/agents
model: sonnet
---

# Plan Command

Reads the project's `PLAN.md` file and dynamically generates phase-specific commands and agents based on the plan structure.

## Usage

```
/plan
```

## Requirements

- A `PLAN.md` file must exist in the project root
- The PLAN.md should contain clearly defined phases/sections

## Process

1. Check for PLAN.md existence in project root
2. Delegate to planner agent to:
   - Parse PLAN.md structure
   - Generate phase-specific commands
   - Generate phase-specific agents
   - Configure appropriate tools for each phase

## Expected Output

After running `/plan`, the system will create:
- `.claude/commands/phase-{name}.md` files for each phase
- `.claude/agents/phase-{name}.md` files for each phase
- Summary of available phase commands for execution

## Error Handling

- If PLAN.md doesn't exist, prompt user to create one
- If PLAN.md is malformed, provide guidance on proper structure

Delegate to planner agent to dynamically generate all phase commands and agents from the plan.md content. The planner agent will check for plan.md existence and handle errors appropriately.