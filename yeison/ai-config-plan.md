# AI configuration plan (agent-skills as the foundation)

A reusable plan for a development-focused, token-efficient AI harness configuration. Written for Claude Code and Cursor; the skills, references and practices stay portable and only thin adapters are harness-specific. Machine-specific status and work-specific details are kept out of this public fork (see `yeison/private/`, git-ignored).

## Core principle: development-focused, token-efficient configuration

The goal is an AI harness configuration dedicated exclusively to software development, with reasonable control over token consumption and implementation costs.

Prefer the simplest configuration that reliably achieves the result. If a solution does the same task in 200 tokens instead of 1,000, prefer the 200-token one, provided correctness, maintainability, security and code quality are not compromised.

- Minimize redundant instructions.
- Avoid loading irrelevant context.
- Reuse existing skills instead of duplicating guidance.
- Load detailed references only when needed.

**Every configuration element must justify its existence** with measurable value to the development workflow. Anything that cannot is removed, not kept "just in case". When a phase below conflicts with this principle, the principle wins.

## Principles

1. **Upstream is never edited in place.** Customizations live under `yeison/` or in new, distinctly named skills; syncing is `fetch upstream` plus merge. Any unavoidable edit to an upstream file is listed in `YEISON-FORK.md`.
2. **Work-specific content stays out of this fork.** A fork of a public repository is public. Employer conventions, internal hostnames and team workflows live in folder-scoped instruction files outside the fork.
3. **One canonical copy of each skill.** Harnesses receive symlinks, not copies.
4. **Secrets never go in files, chat or git.** Rotate anything that is exposed; keep credentials in the OS keychain.
5. **Reversible steps, one at a time, verified after each.** Back up before changing anything.
6. **Token budget per element.** Always-loaded items (instruction files, skill descriptions) carry a measured token cost and a one-line reason to exist. Detail lives in on-demand references.
7. **Development only.** Non-development tooling (design, office, chat, analytics, issue trackers unless highly required) is not installed.

## Phases

| Phase | What | Done when |
|---|---|---|
| 1. Safety | Dated backup of the harness config folders and shell dotfiles; rotate any exposed credential | Backup restores; old credentials return 401 |
| 2. Remove unused tooling | Retire the previous framework and any managed tool bundles, plus non-development plugins and connectors | Skill and rule counts drop; Git and the harness still work in a clean login shell |
| 3. Git and GitHub | Folder-based identities (`includeIf`), `user.useConfigOnly`, one `gh` login per host | The right email in each folder; a scratch folder refuses to commit |
| 4. Fork sync and installer | Merge upstream; symlink installer driven by a manifest | A second sync stays conflict-free; installer is idempotent |
| 5. Instruction triage | Move each always-on instruction to a skill, an on-demand reference, a harness file, or a folder-scoped instruction file | Global instruction file is a few lines |
| 6. Harness adapters | Claude Code (`settings.json`, hooks, subagents), Cursor (`.mdc` rules, `~/.cursor/skills`) | Both list the same skill set |
| 7. Replace vendored copies | Remove per-project copies of the skills once the user-level install works | One source of truth |
| 8. Verify | Re-measure context; justification audit; run a real task in each harness | Before/after numbers recorded |

## Install approach

Upstream ships a plugin, but the plugin loads every skill and slash command (about 3.2k tokens of listings per turn), has no way to select a subset, and its marketplace entry points at the upstream repository, not the fork. The session-start hook is deliberately not wired: hosts that route skills from their descriptions (Claude Code, Codex) would run a second router on top.

Instead, `yeison/install.sh` symlinks the skills named in a manifest (`yeison/skills-core.txt`) into `~/.claude/skills` and `~/.cursor/skills`. Only the listed skills load; upstream updates arrive after a fetch and merge; the script only touches links it created and never overwrites a real folder.

### Core skills at user level (description cost from `/context`)

| Skill | ~Tokens |
|---|---|
| `using-agent-skills` | 90 |
| `spec-driven-development` | 150 |
| `planning-and-task-breakdown` | 90 |
| `incremental-implementation` | 120 |
| `test-driven-development` | 100 |
| `debugging-and-error-recovery` | 120 |
| `code-review-and-quality` | 90 |
| `git-workflow-and-versioning` | 150 |
| `security-and-hardening` | 200 |
| `context-engineering` | 70 |
| `interview-me` | 170 |
| **Total** | **~1.4k** |

The other 14 skills stay available per project (for example `frontend-ui-engineering` for a frontend repo), costing about 1.6k tokens only where they are useful. Add one only when the project can use it: `browser-testing-with-devtools` needs a Chrome DevTools MCP server, and `ci-cd-and-automation` needs a pipeline to work on. The nine slash commands are not installed; plain requests trigger the skills. `constraint-driven-development` is the most expensive description (~300 tokens).

## Instruction triage rules

| Content | Home |
|---|---|
| Rules for every project | Global instruction file, a few lines |
| Rules for one employer or group of repos | Instruction file in the parent folder of those repos (loaded only there, outside any public repo); long references beside it, read on demand |
| Rules for one repo | That repo's instruction file |
| Generic practices (TDD, review, git workflow) | The corresponding upstream skill; do not duplicate in instruction files |
| Long procedures and templates | On-demand reference files, not always-loaded text |

Claude Code concatenates every instruction file it finds from the working directory up to the filesystem root (closest last); it does not pick one. `claudeMdExcludes` in a settings file skips specific files when needed.

## Measured result

After removing the previous framework, managed bundles and a design plugin, the fixed overhead of a fresh session was about 18k tokens (system prompt 2.4k, tools 5.1k, memory files 2.7k, skills 7.3k, agents 0.3k). Of the skills, about 2.9k are built-in and 1.8k come from account-level document skills; the rest are the development skills above. Re-measure after each phase.

## Open questions

1. Plugin install versus symlinks for future harnesses (symlinks chosen for Claude Code and Cursor).
2. Whether to keep account-level connectors and document skills that are not development tools.
