---
name: pr-reviewer
description: Automatically reviews PRs -> checks out the branch, analyzes commits and diffs, generates a structured report, and asks if it can comment on the PR.
keywords: ["pr", "review"]
---

## PR REVIEW SKILL

When user ask for a PR review you must follow the guidelines bellow. USER must provide:
- The **repository** (subproject within the workspace)
- The **branch name** of the PR
- The **PR number** (e.g., #35)

If the user does not explicitly provide the repository, branch name, and PR number, you MUST request them before performing any action.

### Mandatory process:

1. **Fetch and checkout**: `git fetch origin <branch>` and `git checkout <branch>` in the indicated repository
2. **Fetch PR commits**: Use `gh pr view <number> --json commits,title,body,headRefName,baseRefName` to get all commits
3. **Analyze each commit**: For every commit, run `git show <sha> --format="" --stat` and `git show <sha> --format=""` to view the full diff
4. **If there are .parquet or binary files**: Use Python to inspect schema/columns
5. **Generate the report** in the format below
6. **ASK the user** if the report is good or needs changes before commenting
7. **Only after confirmation**: Post as a comment on the PR via `gh pr comment <number> --body '<report>'`

### Report format:

```markdown
## 🔍 Code Review — PR #<number>: <title>

### Priority Scale

| Level | Meaning | Expected Action |
|-------|---------|----------------|
| **P1** | Blocker — bug, security issue, or breaking functionality | Must be fixed before merge |
| **P2** | Important — real issue but not critical | Strongly recommended to fix |
| **P3** | Improvement — design smell, technical debt, desirable refactor | Could be a follow-up |
| **P4** | Cosmetic — style, DRY, optional suggestions | Not blocking, up to the author |

---

### Commit Summary (<N> commits)

| # | SHA | Message | Impact |
|---|-----|---------|--------|
| 1 | `<sha7>` | <message> | <short description of impact> |
| ... | ... | ... | ... |

**Base:** `<base branch>` (PR #<base PR number, if any>)

---

### Files Changed

| File | Type | Change |
|------|------|--------|
| `<path>` | New/Modified/Removed/Renamed | <short description> |

---

### ✅ Positive Points

1. **<title>**: <explanation>
2. ...

---

### ⚠️ Points of Attention

#### P1 — <short title>
<detailed explanation of the issue, why it matters, and solution suggestion>

#### P2 — ...

---

### 📋 Verdict

<general summary in 2–3 lines>

- **P1 (priority)**: <summary>
- **P2 (priority)**: <summary>

**<Approvable/Approvable with notes/Requires changes>. <Main point>.**
```

### Review Criteria:

- **Security**: Hardcoded credentials, exposed secrets, eval with user input
- **Quality**: Duplicate code, inline vs top-level imports, private methods used externally
- **Performance**: Duplicate file reads, unnecessary loops, temporary objects not cleaned up
- **Maintainability**: Hardcoded logic that doesn't scale, tight coupling
- **Completeness**: Features created but not integrated, dead code
- **Documentation**: Outdated docs, missing docstrings for public APIs
- **Tests**: Adequate coverage, reusable fixtures, correct markers
- **CI/CD**: Robust workflows, error handling, concurrency

### Rules:

- Write the report in **English**, unless requested in Portuguese
- Be constructive — point out problems **AND** suggest solutions
- Prioritize issues: P1 (blocker), P2 (important), P3 (improvement), P4 (cosmetic)
- Don't block for style — focus on bugs, security, and architecture
- If the PR is large (>500 lines), organize by module/concern
- **ALWAYS ask the user before posting the comment**
