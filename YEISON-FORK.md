# Yeison fork of agent-skills

Personal fork of [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) for AI-driven development practice.

## Remotes

| Remote | URL |
|--------|-----|
| `origin` | `git@github.com:Yeison0416/agent-skills.git` (this fork — push here) |
| `upstream` | `https://github.com/addyosmani/agent-skills.git` (pull updates here) |

## Sync from upstream

```bash
git fetch upstream
git merge upstream/main
git push origin main
```

If you edited upstream-owned files under `skills/`, resolve merge conflicts carefully. Prefer keeping customizations in `yeison/` when possible.

## Install skills into a harness

```bash
yeison/install.sh --target claude      # ~/.claude/skills
yeison/install.sh --target cursor      # ~/.cursor/skills
yeison/install.sh --target claude --dry-run
```

It symlinks only the skills listed in `yeison/skills-core.txt`, never overwrites a real folder or a foreign link, and is safe to rerun (`--prune` removes our links that left the manifest). Add a skill to a single project by pointing `--target` at that project's skills folder with its own `--manifest`. The reasoning and token budget are in [`yeison/ai-config-plan.md`](yeison/ai-config-plan.md).

## What belongs where

| Path | Owner | Notes |
|------|-------|-------|
| `skills/`, `references/`, `docs/` (Addy) | Upstream | Sync from `upstream`; edit only when necessary |
| `yeison/` | Yeison | Workflow, philosophy, phase mapping, personal notes |
| `yeison/install.sh`, `yeison/skills-core.txt` | Yeison | Symlink installer and its manifest |
| `yeison/private/` | Yeison | Local status and work-specific notes. Ignored through `.git/info/exclude`; never committed (this fork is public) |
| `YEISON-FORK.md` | Yeison | This file |

## Custom layer

- **`yeison/ai-development-philosophy.md`** — how I think about AI-assisted development
- **`yeison/ai-development-workflow.md`** — my workflow phases and skill mapping
- **`yeison/ai-config-plan.md`** — reusable plan for a development-focused, token-efficient harness configuration
- **`yeison/notes/`** — personal learning and interview notes (see [`yeison/notes/README.md`](yeison/notes/README.md))
