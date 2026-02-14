# QuickNotes Workshop — Session Guidelines & Templates

This document is a reference for the GitHub Copilot Workshop Assistant. It contains session-specific guidelines, demo script structure, and the response format template.

---

## Response Format Template

When preparing session content, structure responses as:

```markdown
# Session [#]: [Topic Name]

## 🎯 Objective
[What attendees will learn]

## ⏱️ Time Breakdown
- Introduction: X min
- Demo: X min
- Practice: X min
- Q&A Buffer: 10-15 min

## 📋 Prerequisites
[What should be ready before this session]

## 🎬 Demo Script

### Step 1: [Action]
**Do:** [What to do]
**Say:** [Talking points]
**Show:** [What appears on screen]

### Step 2: [Action]
...

## 💻 Code Examples
[Complete code with explanations]

## 💡 Key Takeaways
[3-5 bullet points]

## 🌐 Cross-Platform Guidance
[Guidance per platform — see cross-platform.md in QA repo]

## ❓ Anticipated Q&A
[Common questions with answers]

## 📁 Files Created/Modified
[List of files touched in this session]
```

---

## Capabilities Checklist

When preparing a session, always provide:

1. **Session Overview** — Objective, prerequisites, outcome
2. **Feature Explanation** — 2-3 min talking points, benefits, limitations
3. **Step-by-Step Demo Script** — Exact actions, expected Copilot behavior, talking points
4. **Code Examples** — Complete, working, with before/after comparisons
5. **Practical Tips** — Best practices, common mistakes, team adoption tips
6. **Q&A Preparation** — Anticipated questions, troubleshooting
7. **Cross-Platform Guidance** — Per platform/stream (fetch from QA repo)

---

## Session-Specific Guidelines

### Session 1: Instruction Files ✅

- Focus on `.github/copilot-instructions.md` (repo-level) and `.github/instructions/` (scoped instructions)
- Show how instructions affect code generation quality
- Demo: Generate entity WITH and WITHOUT instructions to show difference
- Created: `copilot-instructions.md`, `code-generation.instructions.md`, `entities.instructions.md`, `repositories.instructions.md`, `usecases.instructions.md`, `viewmodels.instructions.md`
- Cross-platform: Show example instruction snippets for each platform

### Session 2: Prompt Files 🔄

- Create `.prompt.md` files for reusable prompts
- Organize in `.github/prompts/` directory
- Demo: `applyTypography.prompt.md` — migrates system fonts to AppTypography design tokens across views
- Android companion: `applyChangesFromIOS.prompt.md` — translates iOS diffs to Android equivalents
- New files: `AppTypography.swift`/`AppTypography.kt`, `AppColors.swift`/`AppColors.kt`
- Cross-platform: Suggest prompt templates each team could create (migration prompts, code generation prompts, etc.)

### Session 3: Plan Agent 📋

- Use Plan mode in VS Code
- Show todo list creation and tracking
- Demo: Plan a new feature or refactoring across the existing codebase
- Cross-platform: Show planning approach for different types of tasks

### Session 4: Agent Mode & Edit Mode 📋

- Explain differences (Agent: autonomous, Edit: controlled)
- Show when to use each
- Demo: Multi-file implementation or refactoring using Agent mode
- Cross-platform: Discuss multi-file scenarios for each platform

### Session 5: Custom Agents 📋

- Show built-in agents first (@workspace, @terminal, @vscode)
- Create custom agent for project-specific patterns
- Demo: Agent that follows project architecture patterns
- Cross-platform: Ideas for custom agents per platform

### Session 6: MCP (Model Context Protocol) 📋

- Explain MCP concept and benefits
- Show server configuration in VS Code
- Demo: Connect to external service or tool
- Cross-platform: Discuss useful MCP integrations per platform

### Session 7: Custom Skills 📋

- Explain skills vs agents
- Show skill creation and usage
- Demo: Skill for generating unit tests following project patterns
- Cross-platform: Test generation patterns for each platform

### Session 8: Copilot Code Review 📋

- Show PR review on GitHub
- Show local review in VS Code
- Demo: Custom review instructions for Clean Architecture compliance
- Cross-platform: Review focus areas per platform

### Session 9: Copilot Coding Agent 📋

- Create well-scoped GitHub Issue
- Assign Copilot to the issue
- Demo: Watch autonomous PR creation
- Cross-platform: Good issue types per platform

### Session 10: SpecKit & Advanced Patterns 📋

- Explain specification-driven development
- Create spec for new feature
- Demo: Generate complete feature across all layers from spec
- Cross-platform: Spec formats that work for each platform

---

## Quick Tips Guidelines

### Quick Tip A: Tools Configuration

- VS Code settings for tool control
- Auto-approval patterns
- Tool sets creation
- Cross-platform: Relevant for all, IDE-specific notes for Android Studio/Xcode

### Quick Tip B: Next Edit Suggestions

- Enable/configure in VS Code
- Show predictions during refactoring
- Tab to accept, arrow keys to navigate
- Cross-platform: Available in all supported IDEs

### Quick Tip C: Model Selection

- How to switch models in chat
- Compare outputs for same prompt
- When to use which model
- Cross-platform: Model choice may vary by task type (code gen vs test gen vs docs)

### Quick Tip D: Slash Commands

- `/fix` — Fix issues in selected code
- `/explain` — Explain code
- `/tests` — Generate tests
- `/doc` — Generate documentation
- Cross-platform: Works for all languages, show examples

### Quick Tip E: Inline Chat

- Cmd+I to trigger
- Quick edits without full chat
- Best for small, focused changes
- Cross-platform: Universal feature, works everywhere
