# Personal Intelligence System — System Specification

**Version:** 0.1  
**Status:** Normative architecture specification

This document defines what the personal intelligence system is intended to be.

It is the top-level architectural contract against which the rest of the repository should be interpreted and audited.

The purpose of this file is not to duplicate every operational rule. Detailed behavior belongs in the relevant agent and protocol files.

This file defines:

- the mission of the system;
- the major components;
- authority boundaries;
- information and research lifecycles;
- epistemic invariants;
- cost and model-use principles;
- human-control requirements;
- the canonical documents that implement the architecture;
- a procedure for auditing the repository for internal coherence.

A strong model should be able to read this file, inspect the repository, and determine whether the actual Markdown files and folder structure collectively implement the architecture described here.

---

# 1. Mission

The system exists to help the human owner understand the world and make better decisions without requiring blind trust in any AI model, platform, or information provider.

It should:

- collect and preserve evidence;
- preserve provenance;
- distinguish evidence from interpretation;
- track uncertainty and disagreement;
- use AI to organize, research, reason, and synthesize;
- maintain durable knowledge under the human owner's control;
- make important conclusions traceable back to their supporting sources;
- remain portable across model vendors and runtimes;
- remain inspectable and auditable by a human.

The models are replaceable.

The evidence and the durable knowledge structure are not.

---

# 2. Core Architectural Principle

The system is an **evidence system that produces and maintains knowledge**, not merely a collection of AI-generated summaries.

The intended chain is:

```text
Human question or objective
        ↓
Research process
        ↓
External evidence
        ↓
Agent proposals and interpretations
        ↓
Canonical knowledge
        ↓
Conclusions and synthesis
```

For important conclusions, the chain must remain inspectable in reverse:

```text
Conclusion
    ↓
Canonical claim or synthesis
    ↓
Supporting and contradicting evidence
    ↓
Source record
    ↓
Original source
```

Agent output must never become evidence for itself merely because it has been written into a file.

---

# 3. Repository Model

The expected top-level repository structure is approximately:

```text
personal-intelligence/
├── SYSTEM_SPEC.md
├── inbox/
├── outbox/
├── raw_data/
├── agents/
│   ├── boss/
│   ├── professor/
│   ├── worker/
│   └── intern/
├── research/
│   ├── RESEARCH_PROTOCOL.md
│   ├── active/
│   └── archive/
├── knowledge/
│   ├── README.md
│   ├── KNOWLEDGE_PROTOCOL.md
│   ├── WORKER_PROTOCOL.md
│   ├── sources/
│   ├── proposals/
│   └── wiki/
└── tooling/
```

The semantic responsibilities of the top-level directories are:

```text
agents/      = WHO performs work and how those actors behave
research/    = WHAT investigation is underway or was performed
knowledge/   = WHAT the system currently maintains as knowledge
raw_data/    = archived original source material, not version-controlled
inbox/       = material the human owner drops in for the system to use
outbox/      = system-produced material meant for human consumption
tooling/     = HOW deterministic structure is checked or compiled
```

`raw_data/`, `inbox/`, and `outbox/` sit outside `knowledge/` because none of them are knowledge: `raw_data/` is pre-evidence acquisition material a source record points to, `inbox/` is unprocessed intake, and `outbox/` is a derived export, not the system of record. See `knowledge/KNOWLEDGE_PROTOCOL.md` §2 for `raw_data/`; for `inbox/` and `outbox/`, the triggers are defined in `research/RESEARCH_PROTOCOL.md` §5, §6, and §21, with execution detail in `agents/boss/AGENTS.md` §14 and the ad-hoc synthesis path in `agents/professor/AGENTS.md` §3.D.

Every path in this document and its referenced protocols is relative to the repository root shown above. Agents MUST NOT assume their own working directory is the repository root — how each agent learns the root is described in its own `AGENTS.md`.

These responsibilities SHOULD remain distinct.

---

# 4. Actor Model

The system has four authority levels.

```text
Worker
  ↓
Boss
  ↓
Professor
  ↓
Human owner
```

This hierarchy does not mean every action must pass through every level.

It describes increasing judgment, cost, and authority.

---

# 5. Worker

Workers are ephemeral execution agents.

They SHOULD be cheap and replaceable.

Boss MAY narrow part of a Worker's task into one or more tool-free, single-judgment sub-tasks and dispatch them directly to Intern, an even cheaper ephemeral executor with no tools and no access beyond what it is given (`knowledge/WORKER_PROTOCOL.md`), folding the results into the Worker brief as ordinary pre-gathered input. Worker never dispatches Intern itself and is not asked to judge suitability for delegation — that judgment belongs entirely to task compilation (§16). Intern does not create a new authority level: its output is treated exactly like a Worker's own conclusions — not automatically correct, not canonical.

They are intended for bounded tasks such as:

- evidence extraction;
- source inspection;
- classification;
- comparison;
- locating relevant facts;
- candidate claim generation;
- identifying possible contradictions;
- structured evidence collection.

Workers MUST NOT be treated as authorities.

Workers normally:

```text
read:
- assigned source material
- relevant wiki context
- task brief
- WORKER_PROTOCOL.md

write:
- proposals
- designated research outputs
```

Workers SHOULD NOT directly modify canonical knowledge unless explicitly authorized by a higher-level rule.

Workers MUST distinguish source evidence from their own inference.

Workers MUST be allowed to return uncertainty, missing evidence, or failure.

---

# 6. Boss

Boss is the primary operational agent.

Boss is responsible for:

- executing approved research;
- maintaining research state;
- decomposing work;
- compiling precise Worker tasks;
- reviewing Worker output;
- managing sources and proposals;
- performing routine canonical wiki maintenance;
- triaging `inbox/` material into `raw_data/`, `knowledge/sources/`, or an active research project;
- writing finished human-facing deliverables to `outbox/`;
- deciding when further research is needed;
- recognizing when Professor review is warranted;
- notifying the human owner when attention is required.

Boss is the **normal day-to-day maintainer of canonical knowledge**.

Boss MUST be capable of making routine canonical updates without Professor approval.

Professor MUST NOT become a mandatory approval gate for ordinary knowledge maintenance.

Boss SHOULD use Professor only when stronger judgment has meaningful expected value.

Boss SHOULD use the cheapest adequate resource for each task.

Boss MUST preserve important state in files rather than relying on conversational memory.

---

# 7. Professor

Professor is the senior epistemic reviewer.

Professor exists to apply expensive, high-quality judgment at difficult boundaries.

Professor is appropriate for work such as:

- research-plan review;
- difficult contradiction analysis;
- consequential claim review;
- deep synthesis;
- major canonical restructuring;
- bounded knowledge audits;
- cases where several plausible interpretations remain.

Professor is NOT the routine maintainer of the wiki.

Professor is NOT required to review every Worker proposal or every Boss edit.

Professor SHOULD work on bounded review packets rather than entire repositories or historical backlogs.

By default, Professor invocation SHOULD require human approval before expensive frontier-model resources are consumed.

Professor runs continuously rather than being started per-session, so this approval MUST be an explicit event Professor waits for, not an assumption implied by how Professor happens to be started. Professor MUST relay a pending review request to the human and MUST NOT begin the review itself until the human explicitly authorizes it, and MUST record that authorization in the review request file once given (`agents/professor/AGENTS.md` §13).

Professor's own model knowledge MUST NOT automatically be treated as evidence.

---

# 8. Human Owner

The human owner has final authority.

The human controls:

- research objectives;
- major scope changes;
- expensive Professor invocation by default;
- value judgments;
- major strategic decisions;
- overrides of system conclusions;
- repository ownership and retention.

The system SHOULD reduce unnecessary demands on human attention.

The system MUST surface decisions where human preference or risk tolerance matters materially.

---

# 9. Research Lifecycle

Research is durable process state.

The expected hierarchy is:

```text
Human question
    ↓
RESEARCH_PLAN.md
    ↓
Professor review when appropriate
    ↓
Human approval
    ↓
WORK_PLAN.md
    ↓
Work package
    ↓
Boss task
    ↓
Worker brief
    ↓
Evidence and proposals
```

Ambiguity SHOULD decrease at each level.

Research projects MUST remain resumable from files after:

- process restart;
- model replacement;
- agent-session loss;
- long pauses;
- migration to another runtime.

Important research state MUST NOT depend on one chat session remembering prior work.

Past research SHOULD remain available as audit history after completion.

---

# 10. Knowledge Lifecycle

The intended knowledge flow is:

```text
external source
    ↓
raw_data/ (optional local archive)
    ↓
knowledge/sources/
    ↓
Worker or Boss interpretation
    ↓
knowledge/proposals/
    ↓
Boss review
    ↓
knowledge/wiki/
```

`raw_data/` is optional: a source record can be created directly in `knowledge/sources/` when no local archived copy is necessary.

Professor may review difficult cases, but is not required for the normal path.

The three zones MUST retain distinct meaning:

## sources/

Externally originating evidence or durable source records.

## proposals/

Untrusted candidate interpretations or graph mutations.

A proposal may be:

- correct;
- incomplete;
- duplicated;
- contradictory;
- speculative;
- rejected.

That is acceptable.

## wiki/

Canonical maintained knowledge.

Canonical means maintained and currently accepted by the system.

Canonical does NOT mean infallible or certain.

Valid canonical states include:

```text
supported
weakly supported
conditional
disputed
unknown
superseded
```

---

# 11. Canonical Wiki as a Graph

The wiki is conceptually a knowledge graph represented in human-readable Markdown.

Node types may include:

- entity;
- concept;
- claim;
- question;
- synthesis.

Links between Markdown pages represent relationships between knowledge nodes.

Folders are for human organization.

Folder hierarchy MUST NOT be treated as the graph itself.

Stable node IDs SHOULD be independent from filenames so pages can be renamed or reorganized without destroying identity.

Not every factual sentence needs its own claim node.

A proposition SHOULD become a first-class claim node when it is sufficiently important, disputed, uncertain, frequently referenced, consequential, or supported by multiple sources.

Questions are valid first-class knowledge nodes.

Unknowns SHOULD remain visible.

---

# 12. Evidence and Provenance Invariants

The following rules are architectural invariants.

## 12.1 External evidence and agent interpretation MUST remain distinguishable

A Worker summary is not a primary source.

A Boss synthesis is not a primary source.

A Professor judgment is not a primary source.

## 12.2 Canonical factual claims SHOULD be traceable to evidence

Important claims should allow the human owner to discover:

- what evidence supports them;
- what evidence contradicts them;
- where that evidence came from.

## 12.3 Models MUST NOT fabricate provenance

No actor may invent:

- sources;
- citations;
- quotations;
- source agreement;
- evidence not inspected.

## 12.4 Uncertainty MUST remain representable

The architecture MUST permit:

```text
unknown
disputed
insufficient evidence
conditional
partially supported
```

The system MUST NOT force a binary true/false answer when evidence does not justify one.

## 12.5 Contradictions SHOULD be preserved until responsibly resolved

Clean presentation is not more important than epistemic accuracy.

---

# 13. Proposal Model

A proposal is conceptually a candidate graph mutation.

Examples include:

```text
create node
modify node
add evidence
remove evidence
qualify claim
change confidence
change status
split node
merge node
add relationship
flag contradiction
create open question
supersede stale knowledge
```

Proposals MUST NOT automatically become canonical merely because a Worker completed its task.

Boss must review them.

---

# 14. Authority Boundaries

The intended authority model is:

```text
Worker
    proposes

Boss
    curates, decides routine cases, and maintains canonical knowledge

Professor
    adjudicates difficult cases, reviews major uncertainty, and performs high-value synthesis

Human
    sets goals, controls expensive judgment, and has final authority
```

A repository audit SHOULD flag any file that materially contradicts these boundaries.

Examples of violations:

- a Worker is instructed to freely rewrite canonical knowledge;
- Boss is forbidden from making any canonical change without Professor;
- Professor is required to review every claim;
- Professor can spend frontier-model resources without human approval despite no explicit authorization;
- routine work is unnecessarily routed to the most expensive model.

---

# 15. Cost and Model Hierarchy

The system SHOULD use the cheapest adequate mechanism.

A practical hierarchy is:

```text
deterministic tooling
        ↓
local Worker
        ↓
Boss reasoning
        ↓
Professor
        ↓
human judgment
```

This hierarchy represents cost and escalation, not absolute intelligence.

The system SHOULD avoid:

- sending entire repositories to expensive models;
- repeatedly rereading unchanged context;
- using Professor for routine editorial review;
- creating unnecessary sub-agents;
- generating large summaries with no downstream value.

Professor SHOULD generally receive bounded review packets.

Boss SHOULD compile narrow Worker briefs suitable for small local models.

---

# 16. Task Compilation Invariant

Boss's central execution capability is task compilation.

Vague objectives SHOULD NOT be passed directly to small Workers when they can be decomposed.

A good Worker task has:

- a bounded objective;
- explicit inputs;
- clear questions;
- evidence requirements;
- a defined output;
- clear completion criteria;
- instructions for failure or missing evidence.

The system SHOULD prefer a precise task over a broad instruction such as:

> Research this topic.

---

# 17. Durable State Invariant

Files are the system of record.

Important state MUST NOT live only in:

- Slack;
- chat history;
- model memory;
- transient sub-agent sessions;
- hidden reasoning.

Slack or another channel is an attention and command interface.

Git and repository files are the durable record.

If an important decision occurs through Slack or conversation, it SHOULD be reflected in the relevant research or knowledge artifact when necessary for future understanding.

---

# 18. Communication Model

Professor holds the configured communication channel to the human owner, such as Slack, while the system is running.

Boss does not message the human directly. Boss determines when human attention is warranted and leaves a durable notification record for Professor to relay (`agents/boss/AGENTS.md` §16).

Boss SHOULD leave a notification when:

- a meaningful decision is required;
- research is materially blocked;
- a major scope change is proposed;
- Professor review is recommended;
- an important unexpected finding warrants attention;
- a consequential failure occurs;
- a project completes.

Boss SHOULD NOT leave a notification merely because:

- a routine Worker completed;
- a normal source was added;
- a routine wiki edit occurred;
- nothing changed;
- no human action is needed.

Professor relays pending notifications to the human and relays the human's replies back into the relevant durable file (`agents/professor/AGENTS.md` §13) — the file that changed, not the conversation, remains authoritative (§17).

Communication SHOULD be concise and actionable.

---

# 19. Heartbeat Model

This section describes Boss's heartbeat. Professor's heartbeat is analogous in spirit — resume authorized work, surface what needs attention, stay quiet otherwise — but is scoped to relaying communication and continuing already-authorized review work rather than research execution; see `agents/professor/HEARTBEAT.md`.

Heartbeats exist to resume useful work and surface attention-worthy events.

Heartbeats MUST NOT become permission for uncontrolled autonomous activity.

A heartbeat SHOULD:

- inspect active research state;
- identify ready or blocked work;
- detect completed delegated work;
- continue authorized routine work when useful;
- leave a notification for Professor only when warranted (§18).

A heartbeat MUST NOT:

- invent new research objectives;
- expand scope without authorization;
- continuously modify unrelated wiki areas;
- automatically invoke Professor unless explicitly permitted.

If nothing useful requires action, silence is valid.

---

# 20. Research and Knowledge Separation

Research and knowledge are related but distinct.

```text
research/
    = investigation process and historical audit trail

knowledge/
    = maintained beliefs and evidence structure
```

Research artifacts SHOULD link to knowledge they produced.

Important knowledge nodes MAY link back to the research project from which they were derived.

The architecture SHOULD preserve bidirectional traceability without conflating process state with canonical knowledge.

---

# 21. Deterministic Tooling

Structural integrity SHOULD increasingly be enforced by deterministic software rather than LLM judgment.

Potential tooling responsibilities include:

- duplicate ID detection;
- broken-link detection;
- missing required metadata;
- orphaned nodes;
- claims without evidence;
- graph extraction;
- repository validation.

LLMs SHOULD focus on semantic work such as:

- whether two claims mean the same thing;
- whether sources actually contradict;
- whether a synthesis is warranted;
- whether evidence justifies confidence.

---

# 22. Explicit Graph Future

Markdown remains the canonical human-readable authoring format.

If graph analysis becomes necessary, tooling MAY compile the Markdown wiki into derived representations such as:

- JSON;
- CSV;
- SQLite;
- NetworkX structures;
- graph databases.

Derived graph state MUST NOT become a separately edited competing source of truth.

The intended flow is:

```text
Markdown wiki
    ↓ deterministic compile
explicit graph representation
    ↓
analysis / navigation / validation / context selection
```

---

# 23. Model Independence

No architectural role should be permanently bound to one model vendor.

The intended abstraction is:

```text
role specification
+ relevant protocols
+ bounded task context
        ↓
selected model
```

Professor may be instantiated using whichever frontier model is currently most appropriate.

Workers may be replaced by different local models.

Boss may change models without invalidating durable system state.

The repository SHOULD remain understandable without access to the model that originally created it.

---

# 24. Canonical Documents

The following files define the architecture and SHOULD be treated as canonical specifications.

```text
SYSTEM_SPEC.md

agents/boss/
    IDENTITY.md
    SOUL.md
    AGENTS.md
    HEARTBEAT.md

agents/professor/
    IDENTITY.md
    SOUL.md
    AGENTS.md
    HEARTBEAT.md

agents/worker/
    AGENTS.md

agents/intern/
    AGENTS.md

research/
    RESEARCH_PROTOCOL.md

knowledge/
    KNOWLEDGE_PROTOCOL.md
    WORKER_PROTOCOL.md
```

An audit SHOULD check whether all expected files exist.

An audit SHOULD also check whether additional instruction files introduce contradictory rules.

---

# 25. System Invariants

A healthy implementation SHOULD satisfy all of the following.

1. Evidence and agent interpretation remain distinguishable.
2. Important knowledge remains traceable to evidence.
3. Workers do not directly establish canonical truth.
4. Boss can maintain routine canonical knowledge without Professor approval.
5. Professor is an exceptional review layer, not a universal gate.
6. Expensive Professor invocation requires human authorization by default.
7. Research state is durable and resumable from files.
8. Slack or chat is not the sole record of important state.
9. Uncertainty and contradiction remain valid outcomes.
10. Models are replaceable.
11. The human owner has final authority.
12. Work is scoped toward active approved objectives.
13. Heartbeats do not create uncontrolled autonomous goals.
14. Small Workers receive bounded, precise tasks.
15. Expensive models receive bounded context whenever practical.
16. Canonical Markdown remains the source of truth if derived graph tooling is introduced.
17. Deterministic structure checking is preferred over LLM reasoning where deterministic checks are sufficient.
18. Research process artifacts and canonical knowledge remain semantically distinct.
19. No model's unsupported internal knowledge is treated as provenance.
20. The system may conclude that evidence is insufficient.

---

# 26. Failure Modes the Architecture Is Designed to Resist

A system audit should actively look for these failure modes.

## Epistemic laundering

```text
weak observation
    ↓
polished Worker report
    ↓
Boss summary
    ↓
canonical-looking claim
    ↓
later agent assumes established fact
```

The system should prevent presentation quality from substituting for evidence quality.

## Authority drift

Responsibilities gradually move between Worker, Boss, Professor, and Human without deliberate architectural change.

## Professor tax

Every routine knowledge update requires frontier-model review.

## Context explosion

Expensive agents repeatedly ingest whole repositories or backlogs instead of bounded context.

## Autonomous scope creep

Boss or heartbeat logic invents new objectives beyond approved research.

## Conversational state dependence

Important information exists only in one model session or messaging channel.

## Canonical duplication

The same proposition is represented as multiple disconnected nodes because agents fail to inspect existing knowledge.

## Premature certainty

Unknown or disputed questions are rewritten into simple confident answers.

## Evidence detachment

Canonical conclusions remain readable but no longer allow inspection of their supporting source chain.

## Competing truth stores

A derived database or graph becomes independently edited and diverges from canonical Markdown.

---

# 27. Repository Audit Procedure

A strong model auditing the repository SHOULD use this procedure.

## Step 1 — Read this specification

Treat `SYSTEM_SPEC.md` as the normative top-level architecture.

Do not assume other files are correct merely because they are more detailed.

## Step 2 — Inspect the repository structure

Check whether the expected major directories and canonical files exist.

Identify unexpected instruction files that may affect behavior.

## Step 3 — Read the canonical instruction files

Inspect:

```text
agents/boss/IDENTITY.md
agents/boss/SOUL.md
agents/boss/AGENTS.md
agents/boss/HEARTBEAT.md

agents/professor/IDENTITY.md
agents/professor/SOUL.md
agents/professor/AGENTS.md
agents/professor/HEARTBEAT.md

agents/worker/AGENTS.md

agents/intern/AGENTS.md

research/RESEARCH_PROTOCOL.md

knowledge/KNOWLEDGE_PROTOCOL.md
knowledge/WORKER_PROTOCOL.md
```

## Step 4 — Reconstruct the implied system

Without relying solely on this specification, infer from the implementation files:

- who has authority over what;
- how research begins;
- how work is decomposed;
- how Workers operate;
- how evidence enters the system;
- how canonical knowledge changes;
- when Professor is used;
- when the human is contacted;
- how durable state survives restarts.

Compare the implied system with this specification.

## Step 5 — Check for contradictions

Look for conflicts such as:

- one file permits an action another forbids;
- two actors both appear to own the same decision;
- no actor owns a required decision;
- a workflow depends on an undefined handoff;
- escalation rules contradict cost-control rules;
- protocol references point to nonexistent files.

## Step 6 — Check for missing mechanisms

A concept may be specified but not operationally implemented.

Examples:

- Boss is supposed to leave a notification for Professor but no heartbeat or notification behavior exists;
- Professor review is required but no review-packet mechanism is defined;
- research must be resumable but work-plan files lack status conventions;
- evidence must be traceable but source IDs are not specified.

## Step 7 — Check incentives and failure modes

Ask whether the instructions accidentally encourage:

- overproduction of prose;
- excessive Worker spawning;
- unnecessary Professor calls;
- premature certainty;
- excessive notifications;
- whole-repository context loading;
- autonomous research beyond approved scope.

## Step 8 — Check template readiness

Before the system has ever been used, verify that a fresh Boss or Professor session could understand:

- its role;
- the relevant protocols;
- the folder structure;
- where to read and write;
- what requires human approval;
- how uncertainty should be handled.

## Step 9 — Produce an audit report

Use approximately:

```text
# System Audit

## Overall Assessment
GOOD / MINOR CONCERNS / MAJOR CONCERNS / INCOHERENT

## Critical Violations
- ...

## Internal Contradictions
- ...

## Ambiguous Authority
- ...

## Missing Mechanisms
- ...

## Cost / Context Risks
- ...

## Epistemic Risks
- ...

## Folder / File Structure Issues
- ...

## Redundant or Conflicting Instructions
- ...

## Recommended Changes
1. ...
2. ...

## Invariants Verified
- ...

## Invariants Not Verified
- ...
```

Be specific.

Reference exact files and sections.

Do not recommend architectural redesign merely because an alternative design is possible.

Prefer the smallest changes needed to make the implementation coherent with this specification.

---

# 28. Root-Level Sanity Check Prompt

A fresh high-capability agent opened at the repository root may be given a task similar to:

> Read `SYSTEM_SPEC.md` first. Then inspect the repository structure and all canonical instruction/protocol files named by the specification. Perform a system-level architecture audit before this template is used. Determine whether the files collectively implement the intended system. Check for contradictions, ambiguous authority, missing handoffs, broken references, cost traps, epistemic failure modes, and folder-structure problems. Do not redesign the system unnecessarily. Produce a concise audit with specific file-level recommendations.

This audit is especially useful:

- after changing agent instructions;
- after changing protocol files;
- after adding new agents;
- after changing Professor invocation rules;
- after introducing automation;
- after introducing graph tooling;
- before copying the template into a new system instance.

---

# 29. Change Discipline

Changes to core architecture SHOULD update this specification when they alter:

- authority boundaries;
- actor responsibilities;
- research lifecycle;
- knowledge lifecycle;
- human approval requirements;
- model-use economics;
- durable-state rules;
- epistemic invariants.

Detailed implementation changes that do not alter architecture do not necessarily require a specification change.

When possible, architectural milestones SHOULD be versioned in Git.

---

# 30. Guiding Principle

> **Use AI aggressively for research and reasoning, but structure the system so that no important conclusion requires blind trust in the model that produced it. Preserve evidence, uncertainty, provenance, human control, and the ability to verify what the system believes and why.**
