# AI Development — Basic Concepts (Interview Notes)

Notes on the most common building blocks of AI-assisted development (Cursor, Claude Code, Copilot-style setups). For interview prep and daily practice.

---

## The big picture

Modern AI coding setups stack several layers:

```
You (developer)
    ↓
Interface (Cursor, Claude Code, etc.)
    ↓
Plugin / skill pack (optional install bundle)
    ↓
Model (Claude, GPT, etc.) — chosen per session, not usually per skill
    ↓
Instructions layer — rules, skills, hooks, agents
    ↓
Tools — read files, terminal, search, MCP integrations
    ↓
Your codebase + context
```

**Key idea:** The model is general. The **instruction layers** turn it into a repeatable engineering workflow. Skills first; add rules, hooks, and orchestration only when you have a clear, recurring reason.

---

## 1. Skills

### What they are

A **skill** is a markdown file (usually `SKILL.md`) that tells the agent **how to run a specific workflow** — step by step, with gates and verification.

Think of it as: *“When this kind of work starts, follow this process.”*

Example workflows: interview the user before coding, write a spec, break work into tasks, run TDD, review a PR.

### Structure (typical)

```yaml
---
name: interview-me
description: What it does. Use when [trigger conditions].
disable-model-invocation: true   # optional — user must invoke explicitly
---
```

The **frontmatter** (between `---`) is metadata the tool reads to discover the skill.  
The **body** is the algorithm the agent follows when the skill runs.

### How they're used

- **User-invoked:** You say "interview me" or `/interview-me`. The agent reads the skill and follows it. (`disable-model-invocation: true` prevents the agent from auto-starting it.)
- **Model-invoked:** The agent picks the skill when your task matches the `description` (e.g. "starting a feature, no spec yet" → spec skill).

### Where they live

- **Project:** `.cursor/skills/<name>/SKILL.md` — applies in that repo
- **User/global:** `~/.cursor/skills/` — applies everywhere
- **This fork:** `skills/` (foundation) + `yeison/` (personal docs)

### Why they matter

- **Explicit process** — not vague "be a good engineer"
- **Repeatable** — same workflow every time
- **Composable** — Phase 1 skill → Phase 2 skill → implement
- **Understandable** — you can read exactly what the AI will do

### Interview one-liner

> "Skills are reusable workflow definitions for the agent — structured instructions for phases like requirements, planning, implementation, and review, instead of improvising every chat."

---

## 2. Rules

### What they are

**Rules** are short, always-on (or scoped) instructions injected into **every** relevant conversation. They shape *default behavior*, not a full multi-step workflow.

Think of it as: *"Always behave like this."*

### Examples

- "Surface assumptions before non-trivial work."
- "Never commit secrets."
- "Use conventional commits."

### Where they live (Cursor)

- **Project rules:** `.cursor/rules/*.mdc`
- **User rules:** Cursor Settings → Rules
- **Legacy (avoid):** single `.cursorrules` file

### Rules vs skills

| | **Rules** | **Skills** |
|--|-----------|------------|
| **Size** | Short | Long (full process) |
| **When** | Always / file-scoped | When task matches or you invoke |
| **Purpose** | Default policies | Complete workflows |
| **Example** | "Don't skip tests" | "How to run TDD red-green-refactor" |

**Mistake to avoid:** Pasting entire skill bodies into rules. Duplicates content, wastes context window, hard to maintain.

### When to add rules

When the same **one-line policy** must apply every time and a skill would be overkill — or when people keep violating something (e.g. security baseline).

### Interview one-liner

> "Rules are persistent guardrails; skills are on-demand playbooks. Rules set defaults, skills run structured workflows."

---

## 3. Hooks

### What they are

**Hooks** are scripts or triggers that run at **fixed lifecycle moments** — before/after a prompt, before commit, on session start, etc. They **enforce or automate** something outside the chat.

Think of it as: *"When event X happens, run Y automatically."*

### Examples

- Session start: load project context or checklist
- Pre-commit: block if tests fail
- After agent edit: run linter
- Before deploy: verify env vars exist

### Hooks vs skills vs rules

| | **Rules** | **Skills** | **Hooks** |
|--|-----------|------------|-----------|
| **Mechanism** | Text in context | Text workflow | Code/script on events |
| **Who runs it** | Model reads & tries to follow | Model follows when active | Tool runs automatically |
| **Best for** | Policies | Processes | Enforcement, automation |

Hooks are **stronger enforcement** than rules (the model can ignore rules; hooks can block actions).

### When to add hooks

When you **repeatedly** forget a gate (commit without tests, skip formatting) and reminding via rules isn't enough. Add hooks only when justified — they add complexity.

### Interview one-liner

> "Hooks automate or enforce steps at lifecycle events — like pre-commit checks — whereas rules and skills only instruct the model in conversation."

---

## 4. Agents / subagents

### What they are

An **agent** is the AI running in a session with tools (read files, terminal, search). A **subagent** (or background agent) is a **separate** agent instance spawned for a subtask — often with a **fresh context window**.

Think of it as: *"Delegate this subjob to another worker."*

### Examples

- Main agent plans; subagent researches docs in background
- Subagent reviews a diff with "fresh eyes" (no bias from implementation chat)
- Parallel explorers for different parts of a codebase

### Why fresh context matters

Long chats accumulate noise. The model treats assumptions as facts. A subagent with only the artifact to review can catch mistakes the main session missed.

### Agents vs skills

- **Skill** = instructions for *what process to follow*
- **Agent/subagent** = *who* runs the work (which context, which tools, sometimes which model)

A skill can say: "spawn a background agent to research." That's orchestration using agents.

### Interview one-liner

> "Subagents are separate agent runs — often with clean context — for delegated work like research or adversarial review, without polluting the main implementation thread."

---

## 5. Commands (slash commands)

Some systems expose **slash commands** like `/spec`, `/plan`, `/build`. These are **shortcuts** that activate the right skill(s) for a lifecycle stage.

Commands are **UX sugar** on top of skills — not a different concept. Under the hood: read skill → follow process.

---

## 6. Plugins

### What they are

A **plugin** is a **packaged bundle** that an AI coding tool installs in one step. It typically ships:

- **Skills** (`skills/` directory)
- **Commands** (slash commands like `/spec`, `/plan` — optional)
- **Manifest** (`plugin.json` — name, version, paths to skills/commands)
- Sometimes **hooks**, **agents**, or **rules** depending on the platform

Think of it as: *an app package for your AI toolchain*, not a single instruction file.

In this foundation repository, the root `plugin.json` declares where skills and commands live so Claude Code, Copilot CLI, and similar tools can install the whole pack at once.

### Plugin vs skill

| | **Skill** | **Plugin** |
|--|-----------|------------|
| **Unit** | One workflow | Many skills + wiring |
| **Install** | Copy one folder or pick one skill | Install entire pack |
| **Updates** | Manual per skill | Pull/update whole plugin (or fork sync) |
| **Example** | `interview-me/SKILL.md` | `agent-skills` plugin with 25+ skills |

You **use skills** day to day. You **install a plugin** to get a curated set of skills (and commands) into your tool.

### Plugin vs copying skills manually

| Approach | Pros | Cons |
|----------|------|------|
| **Plugin / marketplace install** | One command, versioned, updates from publisher | Less visible; may install more than you need |
| **Copy / rsync into `.cursor/skills/`** | You own files; pick exactly what you need | You manage updates yourself |
| **Fork (your approach)** | Sync upstream + custom `yeison/` layer | You manage merge/sync |

### Plugin vs MCP

Easy to confuse — different layers:

| | **Plugin** | **MCP** |
|--|------------|---------|
| **Purpose** | Ship **workflows and instructions** (skills) to the agent | Connect **external tools and data** (Jira, APIs, monitors) |
| **Contains** | SKILL.md files, commands, manifest | Tools, resources, servers |
| **Analogy** | Playbook library | USB ports for integrations |

A plugin teaches the agent **how to work**. MCP gives the agent **what to call** outside the repo.

### Where plugins appear

- **Claude Code:** `/plugin install` from marketplace (e.g. `agent-skills@addy-agent-skills`)
- **Copilot CLI:** `copilot plugin install`
- **Generic:** `npx skills add <repo>` — copies skills into agent-specific folders
- **Cursor:** often project `.cursor/skills/` (copy/rsync) or Cursor plugin/marketplace where supported

Same **skills** inside; different **installers** per product.

### Fork + plugin mental model

Your personal fork is the **source of truth** you control:

- **`skills/`** — foundation (sync from upstream)
- **`yeison/`** — your philosophy, workflow, notes
- **Plugin manifest** — still valid if you install from your fork for personal use

You're not building a new plugin from scratch yet — you're **extending the foundation** with a custom layer while staying syncable.

### When to care about plugins in interviews

- **Distribution:** how teams roll out the same skills to everyone
- **Versioning:** plugin version vs skill content drift
- **Governance:** who maintains the plugin, update cadence, fork vs upstream
- **Not** low-level plugin authoring unless the role is platform/tooling

### Interview one-liner

> "A plugin is an installable package that bundles skills, commands, and manifest for an AI coding tool — it's how you distribute workflows at team scale, whereas a skill is a single workflow definition inside that package."

---

## 7. Context and context window

### Context

Everything the model "sees" in one request: system instructions, rules, skills, open files, chat history, tool outputs.

### Context window

The **maximum size** of that input (tokens). When you fill it, older content drops off or gets summarized — the model **forgets** earlier decisions.

### Context engineering

Deliberately choosing **what** to load: relevant files only, spec first, not the whole repo. See `skills/context-engineering/SKILL.md` in this repository.

### Practical habits

- Don't paste huge files unnecessarily
- Save intent/spec to disk (`docs/intent/`) and re-load when starting a new chat
- One feature slice per session when possible
- Quality drops as context fills; start fresh for new implementation steps

### Interview one-liner

> "Context is everything in the prompt the model can use; the window is the limit. Good AI-assisted dev is largely about loading the right context at the right time and avoiding bloated sessions."

---

## 8. Tools and MCP

### Tools

Built-in capabilities the agent can call: read/write files, run terminal, grep, web fetch.

### MCP (Model Context Protocol)

A standard way to connect **external** tools and data (Jira, Figma, Datadog, custom APIs) to the agent. Each integration is an MCP **server** exposing **tools** and **resources**.

Think of it as: *external integrations for the agent* — not the same as a **plugin** (which bundles skills/commands for install).

Skills tell the agent **when and how** to use tools; MCP extends **what** tools exist.

---

## 9. Orchestration

**Orchestration** is coordinating multiple steps, skills, or agents in a pipeline — often automatically.

Example: "After spec approved → generate tasks → implement task 1 → test → commit → next task."

**Risk:** Hidden routing conflicts with **developer-controlled** practice. Prefer **you** invoking the next phase until repetition justifies automation.

Some flows (e.g. `/build auto` in this repo) chain steps with human approval at the plan — still gated.

### Interview one-liner

> "Orchestration chains skills or agents across phases; it's powerful but should stay explicit and gated so the developer doesn't lose control."

---

## 10. How the pieces fit the workflow

| Phase | Primary mechanism | Basics involved |
|-------|-------------------|-----------------|
| 1 — Intent | Skill (`interview-me`) | Skill, user-invoked |
| 2 — Planning | Skills (spec, planning) | Skill, human gate |
| 3 — Implement | Skills (incremental, TDD) | Skill, context engineering |
| 4 — Validate | You + review skills | Human gate, not automation |
| 5–7 — Commits / history | Git skill + discipline | Optional hooks later |
| 8 — Ship | Ship/review skills | Skills |

**Install layer:** plugin (or fork) delivers the skill pack. **Daily work:** invoke skills per phase.

**Today:** skills + your judgment.  
**Later (maybe):** thin rules for always-on policies; hooks if you skip gates; orchestration only if manual phase handoffs become painful.

See [`../ai-development-workflow.md`](../ai-development-workflow.md) for the full phase map.

---

## 11. Model selection (separate from skills)

**Skills should not hardcode "use Opus" or "use Sonnet."** Models change; skills describe **process**.

**You** choose model per session or task:

- Hard planning, architecture, ambiguous requirements → stronger / reasoning model
- Routine implementation, renames, following a clear spec → faster / cheaper model

Optional personal note in your workflow doc — not inside every skill file.

Specifying Sonnet/Opus per task is a **developer/session decision** — valid for cost and capability, not part of the skill definition.

---

## 12. Common interview questions (short answers)

**"What's the difference between a prompt and a skill?"**  
A prompt is one-off instruction. A skill is a saved, structured, reusable workflow with triggers, steps, and verification.

**"What's the difference between a skill and a plugin?"**  
A skill is one workflow file. A plugin is an installable package that bundles many skills (and often commands) for a specific AI tool.

**"How do you stop the AI from making things up?"**  
Confirmed intent/spec first, assumptions surfaced, tests and review, human gates, fresh-context review for high-stakes decisions — not blind trust.

**"When wouldn't you use AI?"**  
Trivial obvious changes, security-critical code without review, when requirements are unknown and you skip discovery, or when you can't verify output.

**"What are AI coding agents' main limitations?"**  
Context limits, hallucinations, overconfidence, tendency to over-engineer, silent wrong assumptions, no true understanding of your production environment unless you provide it.

**"How do skills, rules, and hooks work together?"**  
Rules set always-on policy; skills run phase workflows when needed; hooks enforce or automate at tool lifecycle events. Start with skills; add the others when recurring pain appears.

---

## 13. My examples (fill in)

Use this section for your own practice notes.

### Example 1: Phase 1 in practice

- Project:
- Skill used:
- Output:
- What I learned:

### Example 2: Skills vs rules in my setup

- 

### Example 3: When I would add a hook

- 

### Example 4: Plugin vs fork vs copy

- 

---

## What to learn next

- RAG (when relevant to doc/code search tools)
- Prompt injection / security in agent setups
- Evaluating AI-generated code in code review
- Spec-driven development (Phase 2)
- How Cursor vs Claude Code wires skills, rules, and plugins

