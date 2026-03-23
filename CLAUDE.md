# Remesh Project — Claude Code Rules

## Git & GitHub Workflow

- **Never commit directly to main.** Always work on a feature branch.
- **Never push directly to main.** Always open a PR to merge into main.
- **Always open a clean worktree** (`isolation: "worktree"` or `git worktree`) when beginning new work.
- **Always open a PR** to the main branch for review before merging.
- **Always ask the user before pushing** to the remote. Do not push without explicit confirmation.
- **Use the GitHub noreply email for all commits:**
  - Author and committer email: `23040094+timomitchel@users.noreply.github.com`
  - Set both `GIT_AUTHOR_EMAIL` and `GIT_COMMITTER_EMAIL` when committing.

## Pre-Commit Checks

Before every commit, **always** run:

1. `bundle exec rspec` — full test suite must pass
2. `bundle exec rubocop` — no offenses allowed

Do not commit if either fails. Fix issues first.

**Before committing, always present a summary to the user for review.** List the files changed and a brief description of each change. Wait for the user to approve before running `git commit`.

## Code Review

- **Run the code-reviewer superpowers agent** when opening a new PR. Review your own work before requesting human review.

## UI Verification

- **Use Claude in Chrome** (`mcp__claude-in-chrome__*` tools) to verify any UI changes visually before considering the work complete.

## Testing & Coverage

- **Always add specs** for new features — model, request, service, and system specs as appropriate.
- **Keep SimpleCov coverage above 98%.** Run `COVERAGE=true bundle exec rspec` to verify before opening a PR.

## Communication

- **Always ask clarifying questions** when unsure about design decisions. Do not guess or assume — confirm with the user first.
