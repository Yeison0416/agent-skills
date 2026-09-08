# Yeison fork of agent-skills

Personal fork of [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) for AI-driven development practice.

## Remotes

| Remote | URL |
|--------|-----|
| `origin` | `https://github.com/Yeison0416/agent-skills.git` (this fork — push here) |
| `upstream` | `https://github.com/addyosmani/agent-skills.git` (pull updates here) |

## Sync from upstream

```bash
git fetch upstream
git merge upstream/main
git push origin main
```

If you edited upstream-owned files under `skills/`, resolve merge conflicts carefully. Prefer keeping customizations in `yeison/` when possible.

## What belongs where

| Path | Owner | Notes |
|------|-------|-------|
| `skills/`, `references/`, `docs/` (Addy) | Upstream | Sync from `upstream`; edit only when necessary |
| `yeison/` | Yeison | Workflow, philosophy, phase mapping, personal notes |
| `YEISON-FORK.md` | Yeison | This file |

## Custom layer

- **`yeison/ai-development-philosophy.md`** — how I think about AI-assisted development
- **`yeison/ai-development-workflow.md`** — my workflow phases and skill mapping
- **`yeison/notes/`** — personal learning and interview notes (see [`yeison/notes/README.md`](yeison/notes/README.md))
