---
description: Check current implementation status against PLAN.md milestones and success criteria
argument-hint: [phase]
allowed-tools: Read, Bash, Glob, Grep, Bash
---

# Validate Implementation Against PLAN.md

Check current progress against PLAN.md milestones and provide status report.

## Current Context
- Working from: `{$PROJECT_ROOT}` (root)
- Commands will: `cd document-evidence-analyzer && [work]`
- Use uv for management e.g., uv add, uv pip install, uv run, uv sync
- Check for and activate the existing .venv: `source .venv/bin/activate`

## Your Tasks

1. **Phase Status Check**
   - Check which PLAN.md components are implemented
   - Verify against success criteria section
   - Identify gaps and next steps

2. **File Structure Validation**
   - Verify required files exist (example):
     - `src/file_from_plan.py` (Pydantic models)
     - `schemas/example.v1.json` (schema file)
     - `src/project_1/validation.py` (validation module)
     - `scripts/validate_analyses.sh` (CI script)

3. **Dependency Check**
   - Verify pyproject.toml
   - Check if API keys are configured

4. **Functionality Test** (examples)
   - Test basic CLI commands work (if applicable)
   - Check if AI analysis integration is functional (if applicable)
   - Verify schema validation works

5. **Performance Baseline**
   - Check if processing performance is maintained
   - Verify rate limiting is implemented for API calls

Target phase: $ARGUMENTS (defaults to all phases)

**Example Report Format:**
```
## PLAN.md Implementation Status

### Phase 1: Enhanced Document Analysis
- [ ] Week 1-2: OpenAI Responses API Integration
  - [ ] Pydantic models (DocumentEntity, DocumentAnalysis)
  - [ ] OpenAI client with temperature=0
  - [ ] Entity extraction system
  - [ ] Document classification
  - [ ] Risk flag detection
- [ ] Week 3-4: Schema & Validation
  - [ ] document.v1.json schema
  - [ ] Schema validation module
  - [ ] CI/CD validation scripts

### Success Metrics Status
- Document Analysis Quality: [NEEDS_TESTING/PARTIAL/COMPLETE]
- Processing Speed: [MAINTAINED/DEGRADED/IMPROVED]
- Schema Compliance: [NEEDS_VALIDATION/PARTIAL/100%]
- API Reliability: [NOT_IMPLEMENTED/BASIC/ROBUST]

### Next Steps
1. [Priority 1 action]
2. [Priority 2 action]
```

Be thorough and specific about what's working vs what needs attention.