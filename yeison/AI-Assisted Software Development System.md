# AI-Assisted Software Development System

## 1. Objective

Design and progressively build a personal AI-assisted software-development system that reflects my engineering philosophy, experience, and preferred development workflow.

The goal is **not** to build the largest, most sophisticated, or most automated AI configuration possible.

The goal is to build the **smallest AI development system that provides a strong, disciplined, repeatable, and effective software-development workflow while remaining completely understandable and controllable by the developer**.

I should be able to understand:

- What capabilities the system has.
- Why each capability exists.
- How the capabilities interact.
- What workflow the AI follows.
- Why the AI makes important decisions.
- How the system can be modified or extended.
- How to eventually create and maintain my own skills.

The system should become progressively more powerful over time, but complexity should only be introduced when there is a clear engineering reason to do so.

---

## 2. Core Design Principle

The system should be **developer-controlled AI development**, not autonomous development.

The developer remains responsible for engineering decisions.

The AI acts as a powerful development partner that can:

- Analyze.
- Challenge assumptions.
- Research.
- Design.
- Plan.
- Implement.
- Validate.
- Review.
- Suggest improvements.
- Execute well-defined development tasks.

However, the AI should not silently make important engineering decisions without giving the developer an opportunity to understand, evaluate, and agree with them.

The system should therefore optimize for:

**Understanding → Collaboration → Agreement → Implementation → Validation → Progress**

rather than:

**Prompt → Autonomous implementation → Finished code**

---

## 3. Preferred Architecture

Skills should be the initial foundation of the system.

Start with the simplest possible architecture:

**Skills first.**

If additional mechanisms are genuinely necessary, such as:

- Explicit rules.
- Hooks.
- Agents.
- Routing.
- Automation.
- Orchestration.
- Other configuration mechanisms.

then introduce them only when there is a clear problem that skills alone cannot solve effectively.

Do not introduce additional mechanisms simply because they are available.

Every additional mechanism should have a clear purpose and should remain understandable to the developer.

---

## 4. Design Philosophy

The resulting system should be:

- Simple.
- Explicit.
- Composable.
- Understandable.
- Developer-controlled.
- Progressive.
- Easy to modify.
- Easy to explain.
- Easy to debug.
- Based on strong software-engineering principles.

Avoid unnecessary abstraction, automation, orchestration, or configuration complexity.

Prefer a small number of well-defined capabilities over a large collection of loosely understood capabilities.

---

## 5. Reference Material

Use existing AI-development systems as **source material and inspiration**, not as configurations to copy wholesale.

The primary references are:

### Smee

https://github.disney.com/SANCY061/smee-rules-finder

### Matt Pocock

https://github.com/mattpocock/skills

### Addy Osmani

https://github.com/addyosmani/agent-skills

### Eric Elliott

https://github.com/paralleldrive/aidd/

Analyze these repositories to identify valuable:

- Skills.
- Agents.
- Rules.
- Workflows.
- Development practices.
- Review practices.
- Planning approaches.
- Architectural practices.
- AI-development patterns.

For every candidate capability, determine:

1. What problem does it solve?
2. Why is it valuable?
3. Does it align with my engineering philosophy?
4. Does it fit into the workflow we are designing?
5. Is it necessary?
6. Can it be simplified?
7. Should we adopt it, modify it, or reject it?

Do not assume that a capability is valuable simply because it exists in a respected repository.

---

## 6. Matt Pocock's Skills as Initial Skeleton

Use Matt Pocock's `skills` repository as an initial architectural reference because its approach appears aligned with the desired characteristics:

- Simple.
- Focused.
- Composable.
- Relatively easy to understand.
- Skill-oriented.

However, treat it only as a **starting skeleton**, not as the final architecture.

Do not install or adopt the entire collection without evaluation.

Instead:

1. Identify the workflow we want.
2. Map Matt's existing skills to that workflow.
3. Identify which skills are relevant.
4. Review each relevant skill carefully.
5. Modify the skill where necessary.
6. Keep only the capabilities that align with the system.
7. Create our own versions when appropriate.
8. Give every adopted or modified capability an explicit role in our system.

The resulting system should belong to our engineering philosophy, even when its ideas originated from another developer.

---

## 7. Skill Ownership and Learning

One of the goals of this project is not only to build the system but also to learn how to design AI skills effectively.

Therefore, every skill should follow a consistent structure and naming convention.

Prefer skills that are:

- Small.
- Single-purpose.
- Composable.
- Explicit.
- Easy to read.
- Easy to modify.
- Easy to invoke or understand within the workflow.

When an external skill is adopted, understand it before using it.

When an external skill does not exactly match the desired behavior, modify it rather than blindly adopting it.

When appropriate, create a new skill ourselves based on the underlying idea.

The long-term objective is for me to become capable of designing, evaluating, and maintaining my own AI-development skills.

---

# 8. Proposed Development Workflow

The following workflow represents my current engineering intuition. It is **not yet considered final or authoritative**.

Evaluate it critically and determine whether it is complete, redundant, incorrectly ordered, or missing important stages.

The current proposal is:

### Phase 1 — Prerequisites and Context Validation

Before implementation begins:

- Understand the request.
- Validate assumptions.
- Identify constraints.
- Inspect the relevant codebase.
- Identify dependencies and prerequisites.
- Identify ambiguities or missing information.

Do not begin implementation when important prerequisites are unknown.

---

### Phase 2 — Problem Understanding and Planning

Create a structured breakdown of the work.

The plan should identify:

- The problem.
- Relevant domain concepts.
- Important architectural considerations.
- Implementation boundaries.
- Dependencies.
- Individual implementation steps.
- Validation strategy.

The plan should become the baseline for implementation.

---

### Phase 3 — Step-by-Step Implementation

Implement the plan incrementally.

Each implementation step should be small enough to understand and validate independently.

The AI may generate the initial implementation based on the agreed plan.

The implementation should remain traceable to the corresponding plan step.

---

### Phase 4 — Developer Judgment and Validation

After each implementation step, stop and evaluate the result.

This stage is intentionally collaborative.

The developer and AI should evaluate:

- What was implemented.
- Whether it satisfies the intended behavior.
- Whether the implementation is technically sound.
- Whether assumptions were correct.
- Whether the design should change.
- Whether the implementation can be improved.
- Whether the code follows the project's standards.
- Whether additional tests are required.

The developer may:

- Approve the implementation.
- Request changes.
- Challenge the approach.
- Suggest an alternative.
- Ask for an explanation.
- Request additional validation.
- Reject the implementation.

Do not automatically continue to the next implementation step until the current step has been sufficiently validated and agreed upon.

---

### Phase 5 — Incremental Progress

Once a step is approved:

1. Record the progress appropriately.
2. Create a commit that represents the completed implementation step whenever appropriate.
3. Decide whether the completed step should also be submitted for peer review.
4. Move to the next implementation step.
5. Repeat the implementation and developer-judgment cycle.

Continue this process until the complete implementation is finished.

The workflow should therefore be iterative:

**Plan → Implement → Validate → Discuss → Agree → Commit → [Optional Peer Review] → Next Step**

The exact review and integration strategy is a **developer decision** and may depend on the size, complexity, risk, and duration of the implementation.

---

### Phase 6 — Peer Review Strategy

A completed implementation step does not necessarily need to remain only as a commit until the entire implementation is finished.

For larger or longer-running implementations, the developer may choose to create a Pull Request after completing a plan step, or after a small group of related steps, so that peer review can happen incrementally.

This can help keep reviews:

- Small.
- Focused.
- Composable.
- Easier to understand.
- Easier to validate.
- Less likely to become large, difficult-to-review changes.

For example:

**Plan**  
→ Step 1  
→ Validate  
→ Commit  
→ PR  
→ Peer Review  
→ Step 2  
→ Validate  
→ Commit  
→ PR  
→ Peer Review  
→ ...

Alternatively, for smaller implementations, several approved steps may remain as commits within a single Pull Request.

The important principle is:

> **Commits represent development progress; Pull Requests represent a review boundary.**

These are not required to have a one-to-one relationship.

The developer should choose the appropriate review granularity based on the implementation's size, complexity, risk, and expected collaboration model.

Do not force a Pull Request after every step when doing so would create unnecessary overhead.

---

### Phase 7 — Commit-Based Development History

Each meaningful implementation step should be represented by a commit whenever practical.

The commit history should communicate the development progression clearly.

Ideally, someone reviewing the history should be able to understand:

- What was planned.
- What was implemented.
- In what order it was implemented.
- How the solution evolved.
- Where developer judgment changed the implementation.

The Git history should therefore become a meaningful representation of the AI-assisted/spec-driven development process rather than a collection of large, opaque commits.

This requirement is important.

---

### Phase 8 — Final Validation and Pull Request

After implementation is complete:

- Run the appropriate tests.
- Validate the local build.
- Perform the necessary final checks.
- Review the complete change.
- Confirm that the implementation satisfies the original requirements.

Then:

1. Create the Pull Request if one does not already exist.
2. Provide an appropriate summary.
3. Request review.

---

# 9. Workflow Evaluation Requirement

Do not assume that the workflow above is correct simply because it reflects my current intuition.

Evaluate it against established AI-assisted development practices.

In particular, compare it with useful patterns found in:

- Smee.
- Matt Pocock.
- Addy Osmani.
- Eric Elliott.

Determine:

- What should be added.
- What should be removed.
- What should be combined.
- What should be reordered.
- What should remain optional.
- What should become an explicit skill.
- What should remain a developer decision rather than an AI capability.

The objective is to discover the workflow that best represents my engineering philosophy, not to force existing frameworks into my process.

---

# 10. Build My Workflow Step by Step Using Existing Capabilities as References

Build the proposed workflow starting from **my own workflow**, rather than starting from an existing skill collection.

Work through the workflow step by step.

For each step:

1. Clearly define what I want the step to accomplish.
2. Identify the capabilities required to execute it effectively.
3. Check Matt Pocock's skills for capabilities that could help implement that step.
4. Evaluate whether each relevant skill fits my intended behavior.
5. Adopt, modify, combine, or reject the skill as appropriate.
6. Identify any capabilities my workflow requires that Matt's skills do not provide.
7. Identify any valuable capabilities in Matt's skills that my workflow does not currently cover or make explicit.
8. Consider ideas from Smee, Addy Osmani, and Eric Elliott when they may help address either type of gap.
9. Move to the next workflow step only after the current step is sufficiently understood.

Do not try to fit my workflow into Matt's existing structure.

Instead, use his skills as **building material and reference implementations** while constructing my own workflow.

For example, if my first workflow step requires understanding the problem and challenging assumptions, investigate whether Matt's `grill-with-docs` provides useful capabilities for that step.

If the next step requires domain understanding, investigate whether `domain-modeling` fits.

If another step requires architectural understanding, investigate `codebase-design`.

Continue this process throughout the workflow.

The evaluation should work in **both directions**:

### My workflow → Matt's capabilities

- What does my workflow require?
- Which Matt skills can help?
- Which skills should be adopted, modified, combined, or rejected?
- What capabilities are missing from Matt's system that we may need to create?

### Matt's capabilities → My workflow

- What valuable capabilities does Matt provide?
- Does my workflow already cover them?
- If not, is this a genuine gap in my workflow?
- Should the capability become part of an existing step?
- Should it become a new workflow step?
- Should it remain optional?
- Or is it unnecessary for my engineering philosophy?

Do not assume that every capability missing from my workflow represents a problem. Some capabilities may simply be unnecessary for the system we are building.

Likewise, do not assume that every capability missing from Matt's skills needs to be created. First determine whether the capability is genuinely required.

Potential gaps may therefore result in:

- Modifying an existing skill.
- Combining multiple skills.
- Creating a new skill.
- Adding or modifying a workflow step.
- Making a capability optional.
- Rejecting the capability as unnecessary.

Do not assume the workflow is final while building it. Improve it when the evaluation demonstrates that a change would better align with my engineering philosophy.

The final workflow should emerge progressively from this process:

**My Engineering Philosophy**  
→ **My Proposed Workflow**  
→ **Workflow Step**  
→ **Required Capabilities**  
→ **Evaluate Existing Capabilities**  
→ **Identify Gaps in Both Directions**  
→ **Adopt / Modify / Combine / Create / Reject**  
→ **Refine Workflow if Necessary**  
→ **Next Workflow Step**

---

# 11. Progressive Complexity

The system should evolve incrementally.

Start with the smallest useful set of skills.

Then evaluate the system through real development work.

Only introduce additional capabilities when one of the following is true:

- A recurring problem has been identified.
- A workflow step requires specialized behavior.
- A capability cannot be expressed clearly through an existing skill.
- Repetition justifies automation.
- A rule prevents recurring mistakes.
- A hook provides meaningful validation.
- Routing solves a real complexity problem.

Every addition should have a clear justification.

Avoid building infrastructure for hypothetical future problems.

---

# 12. Developer Transparency

At every stage, prioritize transparency.

The developer should be able to answer:

> "What is the AI doing right now, why is it doing it, and what artifact or decision will result from it?"

Avoid systems where complex routing or hidden instructions make the behavior difficult to understand.

If orchestration becomes necessary, make it explicit.

If automation becomes necessary, document it.

If a skill invokes another skill, make that relationship understandable.

The developer should never need to trust an opaque system simply because it appears to work.

---

# 13. Engineering Quality

The AI system should reinforce strong software-engineering practices rather than replace them.

The system should promote:

- Clear requirements.
- Explicit specifications.
- Sound architecture.
- Appropriate abstraction.
- Maintainable code.
- Testing.
- Validation.
- Code review.
- Incremental development.
- Meaningful Git history.
- Continuous architectural awareness.
- Developer judgment.

AI should increase development speed without reducing engineering quality.

---

# 14. Long-Term Objective

The broader objective is to master AI-driven software development.

The target capability is not merely:

> "Know how to use Cursor, Claude Code, or Copilot."

The target capability is:

> **Understand how to design and operate an AI-assisted software-development system that combines strong software-engineering principles with AI capabilities to produce high-quality software more effectively.**

The system should help me develop the ability to:

- Design AI development workflows.
- Create effective AI skills.
- Evaluate AI-generated work.
- Control AI agents effectively.
- Use AI without surrendering engineering judgment.
- Understand the tradeoffs of AI-assisted development.
- Continuously improve the development process.

The final system should therefore be considered a **living engineering system**, not a static collection of configuration files.

---

# 15. First Task

Do **not** immediately create or install all skills.

First, analyze the proposed workflow and the referenced repositories.

Then begin building the workflow **step by step**, following the process described in Section 10.

For the initial work:

1. Start with the first workflow step.
2. Define what that step should accomplish.
3. Identify the capabilities required.
4. Review the relevant existing skills and practices.
5. Determine what should be adopted, modified, combined, created, or rejected.
6. Document the reasoning and proposed result.
7. Only then proceed to the next workflow step.

At the end of the process, produce:

1. A unified AI-development workflow aligned with my engineering philosophy.
2. The mapping between workflow steps and the capabilities used to execute them.
3. The minimum initial set of skills required.
4. The skills that were adopted, modified, combined, or rejected, including the reasoning.
5. Any new skills that should be created.
6. Any rules, hooks, agents, or orchestration mechanisms that are genuinely necessary beyond skills.
7. The proposed structure and conventions for our own skills.
8. Any important gaps discovered during the process.

Do not optimize for the number of skills.

Optimize for **clarity, composability, engineering quality, developer control, and progressive improvement**.

The final architecture should emerge from this process rather than being predetermined.