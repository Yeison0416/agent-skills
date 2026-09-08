# Senior Software Engineer — AI Interview Q&A

Possible questions and answer frameworks for senior-level interviews where AI-assisted development, agent tooling, or engineering judgment around AI comes up.

---

## 1. Fundamentals and terminology

### Q: What's the difference between AI-assisted development and autonomous AI development?

**Answer:**  
AI-assisted development keeps the **engineer responsible for decisions** — architecture, requirements, approval gates, and merge. The AI accelerates analysis, implementation, and review. Autonomous development optimizes for "prompt in, code out" with minimal human checkpoints.

Senior engineers prefer assisted models because **switching costs after wrong assumptions are locked in** are high. The workflow should optimize for understanding, agreement, and validation — not maximum automation.

---

### Q: What's the difference between a prompt, a rule, and a skill?

**Answer:**

| | Prompt | Rule | Skill |
|--|--------|------|-------|
| **Scope** | One conversation | Persistent policy | Reusable workflow |
| **Length** | Ad hoc | Short | Structured, multi-step |
| **Use** | Quick tasks | Always-on defaults | Phase work (spec, TDD, review) |

A **prompt** is ephemeral. A **rule** shapes default behavior ("surface assumptions before non-trivial work"). A **skill** is a full playbook ("run this interview process until explicit confirmation, then produce an intent artifact").

Senior practice: **skills for processes, rules for policies**, prompts for one-offs — not 500-line prompts or skills pasted into rules.

---

### Q: What's the difference between a skill, a plugin, and MCP?

**Answer:**

| | Skill | Plugin | MCP |
|--|-------|--------|-----|
| **What** | One workflow (`SKILL.md`) | Installable pack (many skills + manifest + optional commands) | Protocol for external tool integrations |
| **Layer** | Instructions | Distribution/packaging | External data and actions |
| **Example** | `interview-me` | `agent-skills` plugin | Jira, Datadog, Figma servers |

**Skill** = how to do one kind of work.  
**Plugin** = how the team **installs and versions** a collection of skills in Claude Code, Copilot CLI, etc.  
**MCP** = how the agent **calls outside systems** — orthogonal to skills.

Senior point: don't conflate "we installed the plugin" with "we have a secure, verified workflow" — still need gates, review, and discipline.

---

### Q: What are hooks in an AI coding setup, and when would you use them?

**Answer:**  
Hooks are **lifecycle scripts** — run on events like session start, pre-commit, or after file save. They **enforce or automate** outside the chat. Rules tell the model what to do; hooks **guarantee** an action runs.

Use hooks when a gate is repeatedly skipped (tests before commit, lint after edit). Don't add them upfront — they increase complexity. Prefer skills + discipline first; hooks when pain is proven.

---

### Q: What is a subagent, and why would you use one?

**Answer:**  
A **subagent** is a separate agent run — often with a **fresh context window** — delegated to a subtask. Use cases: background research, parallel codebase exploration, adversarial review of a diff without implementation-session bias.

The main session accumulates assumptions; fresh context helps **challenge** them. Tradeoff: coordination overhead and cost. Use for high-stakes or complex work, not every keystroke.

---

## 2. Context and the context window

### Q: What is context engineering, and why does it matter for senior engineers?

**Answer:**  
Context engineering is **deliberately choosing what the model sees**: relevant files, spec, intent doc, ADRs — not the whole repo or entire chat history.

It matters because:

1. **Context windows are finite** — old decisions fall off or get summarized.
2. **Quality degrades** as context fills ("smart zone" shrinks).
3. **Wrong context** leads to wrong patterns copied from irrelevant files.

Senior habits: persist intent/spec to disk, start fresh sessions per implementation slice, load only what's needed for the current task.

---

### Q: How do you prevent an long AI session from going off the rails?

**Answer:**

- **Phase gates** — confirmed intent and spec before implementation.
- **Smaller scopes** — one vertical slice per session when possible.
- **Written artifacts** — `docs/intent/`, spec, task list as source of truth between chats.
- **Explicit stop conditions** — e.g. "don't proceed without explicit yes."
- **Fresh session** for implementation after planning, if the planning thread is large.
- **Human validation** after each meaningful step — not auto-continue.

---

### Q: What happens when the context window is exceeded?

**Answer:**  
Older messages are truncated or summarized. The model **loses** fine-grained earlier decisions, may contradict prior agreement, or reintroduce rejected approaches. Tool outputs and large file reads consume window quickly.

Mitigation: externalize state (specs, tickets, intent docs), reduce noise, restart sessions with a concise handoff summary + links to artifacts.

---

## 3. Quality, verification, and hallucinations

### Q: How do you verify AI-generated code before merging?

**Answer:**  
Treat AI output like **a junior's PR that types fast** — never merge on trust.

1. **Requirements traceability** — does it match spec/intent?
2. **Tests** — unit/integration; TDD where appropriate.
3. **Read the diff** — logic, edge cases, error handling, security.
4. **Run the app** — runtime behavior, not just green tests.
5. **Standards** — naming, architecture, project conventions.
6. **Code review** — human or structured review skill; fresh eyes for critical paths.

Verification is **evidence**, not "looks right."

---

### Q: How do you handle AI hallucinations in code?

**Answer:**  
Hallucinations include invented APIs, wrong library methods, plausible-but-false configs, and confident incorrect architecture.

**Prevention:** spec first, source-driven checks against official docs, constrain to patterns already in the codebase.

**Detection:** tests, compile/lint, runtime, code review, typing.

**Culture:** assume the model can be wrong on any fact not verified. "The model said so" is not an argument in review.

---

### Q: Should you use TDD with AI-generated code?

**Answer:**  
**Yes, when behavior matters.** TDD gives a **verifiable contract** the model must satisfy and catches hallucinated "it works" implementations. The test is the source of truth, not the model's explanation.

For trivial or mechanical changes, full TDD may be overhead. Senior judgment: TDD at **seams** and for **non-trivial behavior** — aligned with testing the interface, not every line.

---

### Q: What's your approach when the AI confidently implements the wrong thing?

**Answer:**

1. **Stop** — don't stack fixes on a wrong foundation.
2. **Identify the gap** — wrong requirements, wrong context, or wrong approach.
3. **Go back a phase** — re-clarify intent or spec, don't patch forward blindly.
4. **Reduce scope** — smaller step, clearer acceptance criteria.
5. **Reject and redirect** — explicit "this doesn't meet X because Y."

Developer-controlled workflow means **rejection is normal**, not failure.

---

## 4. Workflow and engineering process

### Q: How would you integrate AI into a team's software development lifecycle?

**Answer:**  
Integrate at **phase boundaries**, not as a black box:

| Phase | AI role | Human gate |
|-------|---------|------------|
| Discovery / intent | Interview, clarify, challenge assumptions | Confirm requirements |
| Planning | Spec, task breakdown, risk identification | Approve spec/plan |
| Implementation | Generate slices, tests, refactors | Validate each step |
| Review | Review assistance, simplification suggestions | Approve merge |
| Ship | Checklists, automation drafts | Own production decision |

Standardize **artifacts** (intent docs, specs, tasks) and **skills** for repeatable quality. Don't mandate AI for trivial work. Measure: defect rate, review time, not "lines generated."

---

### Q: Why write a spec before letting AI implement?

**Answer:**  
Without a spec, the model fills gaps with **plausible defaults** you didn't choose. A spec is the shared contract: scope, acceptance criteria, out-of-scope, assumptions.

Benefits:

- Reviewable before code exists (cheap to change).
- Traceability in review ("does diff match spec?").
- Smaller, focused implementation prompts.
- Reduces rework from misunderstood intent.

Senior principle: **spec before code** for anything non-trivial or multi-file.

---

### Q: When would you *not* use AI for a development task?

**Answer:**

- Trivial, unambiguous changes (typo, rename with clear scope).
- When requirements are unknown and you skip discovery — AI will guess.
- High-risk security/crypto/auth logic **without** rigorous review and tests.
- When you can't verify output (no tests, no runtime check, unfamiliar domain).
- When speed pressure would skip gates you'd normally require of a human PR.
- Sensitive data in prompts (secrets, PII) without proper controls.

"No AI" is a valid senior decision.

---

### Q: How do you avoid AI encouraging over-engineering?

**Answer:**

- **Spec with explicit out-of-scope** — what we're NOT building.
- **Incremental implementation** — smallest vertical slice first.
- **Review for simplification** — dedicated pass: "can this be half the code?"
- **Rules/skills that enforce scope discipline** — touch only what's required.
- **Push back in chat** — "what's the boring solution?"

AI defaults to "helpful completeness." Seniors optimize for **maintainability and minimal diff**.

---

## 5. Security and compliance

### Q: What security risks should seniors consider with AI coding tools?

**Answer:**

1. **Secrets in prompts** — keys, tokens, credentials in chat or context.
2. **Prompt injection** — untrusted content (issues, docs, dependencies) manipulating the agent.
3. **Unreviewed dependencies** — model suggests packages you don't vet.
4. **Insecure patterns** — SQL injection, XSS, auth bypass in generated code.
5. **Data leakage** — corporate code sent to external models against policy.
6. **Supply chain** — unverified scripts, hooks, or MCP servers.

Mitigations: env/secrets management, review, dependency audit, enterprise tool policies, never trust generated security code without expert review.

---

### Q: Can you paste proprietary code into ChatGPT or Cursor?

**Answer:**  
Depends on **employer policy and tool configuration** (enterprise vs consumer, data retention, training opt-out). Senior answer: **know your org's rules**, use approved tools, redact secrets and PII, prefer enterprise/zero-retention options for proprietary code.

When in doubt, don't paste — describe patterns or use local/on-prem tooling.

---

## 6. Architecture and system design

### Q: How does AI change how you approach system design?

**Answer:**  
AI doesn't change **fundamentals** — boundaries, interfaces, testability, failure modes still matter. It changes **velocity** and **exploration**:

- Faster prototyping of alternatives (throwaway spikes).
- More important to **document decisions** (ADRs) because implementation is faster than reasoning.
- **Deeper modules with clear seams** — AI navigates code better when interfaces are small and explicit.
- **Stronger need for tests and contracts** — implementation outruns human reading speed.

Design for **human and AI maintainability**: clear structure, consistent patterns, good naming.

---

### Q: Would you let AI choose your architecture?

**Answer:**  
AI can **propose** options with tradeoffs. The senior engineer **chooses** based on team skill, operational constraints, scale, and product timeline.

Use AI for: alternatives analysis, boilerplate, exploring patterns in the codebase.  
Don't outsource: boundary decisions, data ownership, consistency models, security architecture without deep review.

---

### Q: What is MCP, and why might a team adopt it?

**Answer:**  
**Model Context Protocol** standardizes how agents connect to external tools and data (Jira, monitoring, internal APIs). Teams adopt it to give agents ** governed, reusable integrations** instead of ad-hoc scripts per project.

Senior considerations: auth, rate limits, audit logging, least privilege, and not exposing destructive operations without gates.

---

## 7. Models, cost, and tooling

### Q: How do you choose which model to use for a task?

**Answer:**  
At **session or task level**, not baked into every skill:

| Task type | Typical choice |
|-----------|----------------|
| Ambiguous requirements, architecture, complex debugging | Stronger reasoning model |
| Routine implementation from clear spec | Faster/cheaper model |
| Large codebase exploration | Model with large context + good tool use |

Factors: accuracy needed, cost, latency, tool availability, org policy. Re-evaluate as models change — don't hardcode model names in team skills.

---

### Q: Cursor vs Claude Code vs Copilot — how do you compare them?

**Answer (framework, not fanboy):**  
Compare on:

- **Context** — rules, skills, repo awareness, MCP.
- **Agent capabilities** — terminal, multi-file edits, subagents.
- **Workflow fit** — spec-driven, review, CI integration.
- **Distribution** — plugins, marketplaces, team-standard skill packs.
- **Enterprise** — SSO, data handling, compliance.
- **Team standardization** — can everyone reproduce the same workflow?

Senior answer: pick what fits **team workflow and policy**, not hype. Skills and process matter more than vendor for quality outcomes.

---

### Q: How would you roll out AI skills to a team — copy files or use a plugin?

**Answer:**  
Depends on tool and governance:

- **Plugin/marketplace install** — best for consistent version, one-step onboarding (Claude Code, Copilot CLI). Tradeoff: team must trust the package source and update cadence.
- **Copy/rsync to `.cursor/skills/`** — best when you cherry-pick skills or maintain a **fork** with custom `yeison/`-style layer. Tradeoff: you own sync and merge.
- **Hybrid** — plugin for baseline; fork for org-specific rules/skills in a separate repo.

Senior concerns: versioning, who approves updates, diff review on skill changes, and not loading all 25 skills into every session (context bloat).

---

## 8. Team leadership and behavioral

### Q: How would you mentor a mid-level developer using AI tools?

**Answer:**

- Teach **process** (intent → spec → slice → verify), not prompt tricks.
- Require **artifacts** — they must explain what was asked, what was built, how it was verified.
- Review **their judgment**, not just code — when did they push back on the AI?
- Warn against **autopilot** — merging without reading diff.
- Pair on **first use** of skills for spec and review.
- Set norm: **AI speed must not reduce review quality.**

---

### Q: Tell me about a time AI led you toward a wrong solution. What did you do?

**Answer (STAR framework — fill with your story):**

- **Situation:** e.g. building a feature from an underspecified ask.
- **Task:** deliver X with quality bar Y.
- **Action:** AI proposed Z; tests/spec review showed mismatch; stopped, ran intent clarification, reduced scope, re-implemented with explicit acceptance criteria.
- **Result:** avoided shipping wrong feature; added gate (interview/spec) for similar work.

If you haven't shipped yet: use **TodoMVC intent session** — "dashboard" ask became personal experiment tracker after interview questions.

---

### Q: How do you measure whether AI is improving your team's productivity?

**Answer:**  
Avoid vanity metrics (lines generated, PRs opened).

Better signals:

- **Cycle time** for well-scoped stories (with quality held constant).
- **Defect escape rate** / production incidents.
- **Review rounds** per PR (should not increase).
- **Rework rate** — stories reopened after "done."
- **Developer sentiment** — less toil, not less thinking.

If speed up but incidents/review burden up, AI is **negative** ROI.

---

## 9. Advanced / judgment questions

### Q: Should skills specify which AI model to use?

**Answer:**  
**Generally no.** Skills describe **process**; models change names, tiers, and pricing frequently. Model choice is a **developer or session decision** based on task difficulty and cost.

Optional team **guidelines** ("planning: prefer reasoning model") in workflow docs — not hardcoded in 25 skill files.

---

### Q: When would you introduce orchestration or automation in an AI workflow?

**Answer:**  
When **manual handoffs** between phases cause repeated failure — e.g. skipping spec, skipping tests — and skills + discipline aren't enough.

Introduce **with explicit gates** (human approves plan before auto-implement chain). Avoid opaque routing. Prefer `/build auto`-style flows with verification over fully autonomous pipelines for production code.

Start with skills only; add orchestration from **evidence**, not anticipation.

---

### Q: How do RAG and AI coding agents relate?

**Answer:**  
**RAG (Retrieval-Augmented Generation)** retrieves relevant documents into the prompt before generation. Coding agents use similar ideas: codebase search, semantic index, `@file` references, MCP resources.

Senior point: retrieval quality determines output quality — garbage context → garbage code. Curate what's retrieved; don't assume "the agent found the right docs."

---

### Q: What's the biggest mistake teams make adopting AI coding tools?

**Answer:**  
Treating AI as **replacement for engineering judgment** instead of **acceleration under the same quality bar**.

Symptoms: skipping requirements, giant unreviewed PRs, no tests, "the AI wrote it" in review, no standards for when AI is used.

Fix: **same gates as human-written code** — spec, test, review, incremental delivery — with skills/process that encode them.

---
