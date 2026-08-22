# Research Protocol

**Version:** 0.1  
**Status:** Experimental  
**Purpose:** Define how research projects are created, reviewed, decomposed, executed, tracked, and linked to the knowledge system.

---

## 1. Purpose

The research system represents **work being done to improve understanding**.

It is separate from the canonical knowledge base.

```text
research/
    = what the system is trying to learn and how it is doing the work

knowledge/
    = what the system currently maintains as knowledge
```

Research artifacts may contain hypotheses, incomplete work, failed avenues, open questions, and plans.

They are not automatically canonical knowledge.

---

## 2. Directory Structure

```text
research/
├── RESEARCH_PROTOCOL.md
├── active/
└── archive/
```

Each research project has its own directory.

Example:

```text
research/
└── active/
    └── finland-malta-ecommerce/
        ├── RESEARCH_PLAN.md
        ├── WORK_PLAN.md
        └── work/
            ├── WP-01-scenario-definition.md
            ├── WP-02-vat-oss.md
            ├── WP-03-consumer-law.md
            └── ...
```

When a project is complete or abandoned, move the whole directory to:

```text
research/archive/
```

Do not delete completed research projects unless there is a specific reason to do so.

---

## 3. Research Project Identity

Every research project should have a stable ID.

Suggested format:

```text
R-0001
R-0002
R-0003
```

The project directory name should remain human-readable.

Example:

```text
R-0007
finland-malta-ecommerce
```

The stable ID belongs in `RESEARCH_PLAN.md`.

Example:

```yaml
---
id: R-0007
title: Selling physical goods from Finland to Malta
status: planning
created: 2026-08-22
updated: 2026-08-22
---
```

The project ID should not change if the title or scope is refined.

---

## 4. Research Lifecycle

Suggested project statuses:

```text
idea
planning
review
approved
active
blocked
completed
abandoned
```

Typical lifecycle:

```text
idea
  ↓
planning
  ↓
Professor review
  ↓
human approval
  ↓
active
  ↓
work packages executed
  ↓
knowledge produced
  ↓
completed
  ↓
archive
```

Not every project must follow every step, but important research should normally be reviewed before large amounts of work are executed.

---

## 5. Research Plan

`RESEARCH_PLAN.md` defines **what must be understood and why**.

It is a strategic artifact.

It should not contain detailed worker instructions.

A research plan should usually contain:

### Objective

What are we trying to understand?

### Motivation / Decision Supported

Why does this research matter?

What decision, action, or understanding will it support?

### Scope

What is included?

### Out of Scope

What is deliberately excluded?

### Initial Context

Relevant existing knowledge, assumptions, or background.

### Research Questions

The major questions that must be answered.

### Evidence Standard

What kinds of evidence are preferred?

Examples:

- primary sources;
- government or regulatory sources;
- scientific papers;
- official documentation;
- company filings;
- direct observations;
- independent measurements;
- community reports.

### Known Risks

Where could the research easily become misleading, incomplete, or overconfident?

### Known Unknowns

What is already known to be uncertain?

### Desired Outputs

What should exist when the project is complete?

Examples:

- canonical wiki nodes;
- comparison;
- launch checklist;
- decision memo;
- unresolved-question list;
- evidence map.

### Completion Criteria

What must be true before the research can reasonably be considered complete?

---

## 6. Creating the Research Plan

The human should normally create the first research plan through an exploratory conversation with the strongest suitable model available.

The purpose of this phase is to improve the **research question**, not to prematurely answer it.

The model should help identify:

- missing dimensions;
- hidden assumptions;
- dependencies;
- important subquestions;
- evidence requirements;
- potentially dangerous simplifications.

The resulting plan is saved as `RESEARCH_PLAN.md`.

---

## 7. Professor Review of the Research Plan

For substantial research, the Professor should review the plan before execution.

Professor should evaluate:

- Is the objective clear?
- Is important scope missing?
- Are any questions incorrectly framed?
- Are dependencies represented?
- Are evidence standards appropriate?
- Are there areas where primary evidence is required?
- Could the plan produce a superficially complete but unreliable result?
- Are important unknowns or contradictions already visible?
- Is the proposed scope unnecessarily large?

Professor should improve the research design, not perform the research itself during this stage unless specifically requested.

The human owner should approve major scope changes before large-scale execution begins.

---

## 8. Work Plan

`WORK_PLAN.md` defines **how the approved research plan will be executed**.

It is derived from `RESEARCH_PLAN.md`.

The Work Plan should break the project into bounded work packages.

Example:

```text
WP-01  Define the legal and commercial scenario
WP-02  EU VAT and OSS obligations
WP-03  Maltese consumer-protection requirements
WP-04  Product compliance
WP-05  Packaging and EPR obligations
WP-06  Shipping, delivery, and returns
WP-07  Payments and fraud
WP-08  Privacy and data processing
WP-09  Operational economics
WP-10  Cross-domain synthesis
```

The Work Plan should identify:

- work package ID;
- title;
- purpose;
- dependencies;
- priority;
- current status;
- expected outputs.

Suggested work-package statuses:

```text
pending
ready
active
blocked
review
completed
cancelled
```

---

## 9. Work Packages

Each significant work package should have its own Markdown file.

Example:

```text
work/WP-02-vat-oss.md
```

A work package should contain:

### Objective

What bounded question must this package answer?

### Why It Matters

What higher-level research question depends on this work?

### Inputs

Relevant:

- sources;
- existing wiki nodes;
- other work packages;
- assumptions.

### Questions to Answer

Specific questions this work package must investigate.

### Evidence Requirements

What evidence is acceptable?

### Constraints

What is outside the package's scope?

### Expected Outputs

What proposals, sources, questions, or summaries should result?

### Dependencies

What other work must happen before or after this package?

### Completion Criteria

How does Boss know this package is done?

### Status

Current execution state.

---

## 10. Boss Responsibilities

Boss is responsible for executing the approved Work Plan.

Boss should:

1. inspect the current Work Plan;
2. select a ready work package;
3. inspect relevant existing wiki knowledge;
4. identify evidence gaps;
5. decompose the package into bounded Worker tasks;
6. write precise Worker briefs;
7. evaluate Worker outputs;
8. retry, redirect, or create additional tasks when needed;
9. organize useful outputs into `knowledge/proposals/`;
10. update work-package status;
11. identify issues requiring Professor review;
12. stop when the package completion criteria are met.

Boss should not create work merely to keep agents busy.

Before spawning a task, Boss should be able to answer:

> What information could this task produce, and what decision or knowledge gap would that information affect?

---

## 11. Worker Tasks

Ephemeral Workers execute small, bounded tasks.

Workers should follow:

```text
knowledge/WORKER_PROTOCOL.md
```

Worker tasks should normally include:

```text
Task ID
Objective
Why the task matters
Exact inputs
Questions to answer
Evidence requirements
Constraints
Expected output path
Completion condition
What to do if blocked
```

Workers should not receive the entire Research Plan when a smaller self-contained brief is sufficient.

Boss is responsible for compiling the context required for each Worker.

---

## 12. Research Outputs and the Knowledge System

Research work may produce:

- new sources;
- proposals;
- candidate claims;
- new questions;
- suggested modifications to existing wiki nodes;
- contradictions;
- synthesis requests.

These enter the knowledge workflow:

```text
research
   ↓
sources + proposals
   ↓
review
   ↓
canonical wiki
```

Research artifacts themselves do not automatically become canonical knowledge.

---

## 13. Linking Research to Knowledge

Research projects and canonical knowledge should remain traceable to each other.

### Research → Knowledge

`RESEARCH_PLAN.md` or `WORK_PLAN.md` should contain a section such as:

```markdown
## Knowledge Produced

- [[C-000184]]
- [[CON-000031]]
- [[Q-000017]]
```

This section may be updated as canonical nodes are created or revised.

### Knowledge → Research

Important canonical nodes created or materially revised through a research project should record the originating project where practical.

Example frontmatter:

```yaml
derived_from_research:
  - R-0007
```

The purpose is not bureaucracy.

The purpose is to allow a human or agent to answer:

> Why does this node exist, and what investigation produced it?

---

## 14. Linking Research to Sources

Research projects should also remain traceable to the evidence they used.

A project or work package may record:

```markdown
## Sources Used

- [[S-000052]]
- [[S-000061]]
- [[S-000073]]
```

The canonical source record remains under `knowledge/sources/`.

Do not duplicate the source itself inside the research directory unless there is a specific operational reason.

---

## 15. Research Does Not Need to Succeed

A research project may end with:

- a supported conclusion;
- a disputed conclusion;
- insufficient evidence;
- a blocked question;
- a recommendation for future investigation;
- abandonment because the question was poorly framed or no longer useful.

These are valid outcomes.

Do not fabricate closure merely to mark a project complete.

---

## 16. Open Questions

Research may discover questions that are outside the current scope but worth preserving.

Important knowledge gaps should be proposed as canonical `question` nodes in the wiki.

Do not automatically expand the current project to investigate every newly discovered question.

Boss should ask:

> Is this necessary for the active research objective?

If not, preserve the question and continue with the current plan.

---

## 17. Scope Control

Agents must resist uncontrolled expansion.

When new areas are discovered, classify them as:

```text
required for current objective
useful but optional
future research
out of scope
```

Only the first category should automatically expand the current Work Plan.

Major scope changes should be visible to the human owner.

---

## 18. Professor During Execution

Professor should not be used for routine extraction or backlog processing.

Professor should be invoked for bounded, high-value tasks such as:

- reviewing an important contradiction;
- evaluating a consequential claim;
- synthesizing difficult cross-domain findings;
- identifying flaws in a research approach;
- reviewing a major proposed wiki change;
- determining what evidence could resolve an important dispute.

Professor should receive a prepared, bounded review packet rather than an uncontrolled research backlog.

---

## 19. Human Checkpoints

For version 0.1, the human should remain involved at important boundaries.

Recommended checkpoints:

1. approve the Research Plan;
2. inspect the Work Plan;
3. review major scope changes;
4. inspect consequential Professor conclusions;
5. approve important canonical knowledge changes when practical.

These checkpoints may be reduced later as the system becomes better understood.

---

## 20. Resumability

Research state must live in files, not only in chat context.

At any time, another capable agent should be able to inspect:

```text
RESEARCH_PLAN.md
WORK_PLAN.md
work/
```

and determine:

- the objective;
- completed work;
- active work;
- blocked work;
- remaining work;
- important outputs;
- unresolved questions.

A research project should therefore survive:

- agent restarts;
- model changes;
- Docker restarts;
- long pauses;
- migration to another orchestration system.

---

## 21. Archive

When a research project is finished or abandoned:

1. update its final status;
2. summarize the outcome in `RESEARCH_PLAN.md` or `WORK_PLAN.md`;
3. ensure important knowledge outputs are linked;
4. preserve unresolved questions where useful;
5. move the project directory from `research/active/` to `research/archive/`.

Archived projects remain part of the system's audit history.

---

## 22. Git

Research artifacts should be version-controlled.

Git history should allow inspection of:

- how the research question evolved;
- how scope changed;
- which work packages were added or removed;
- what was completed;
- where research failed;
- how research led to canonical knowledge.

Research history is useful evidence about the performance of the intelligence system itself.

---

## 23. Version 0.1 Principle

Keep research management lightweight.

The purpose of plans and work packages is to reduce ambiguity and preserve state, not to create bureaucracy.

Use the minimum structure required to make research:

- understandable;
- resumable;
- auditable;
- decomposable;
- connected to evidence;
- connected to canonical knowledge.

Add complexity only when real projects demonstrate a need.

---

## Guiding Principle

> **Research is a durable, inspectable process that turns questions into evidence-backed knowledge without requiring any single model or conversation to remember the whole investigation.**
