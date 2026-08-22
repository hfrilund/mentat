# Knowledge Protocol

**Version:** 0.1  
**Status:** Experimental  
**Purpose:** Define how the personal intelligence system collects evidence, proposes knowledge, and maintains the canonical knowledge graph.

---

## 1. Mission

This repository is a personal, model-independent knowledge system.

Its purpose is to maintain an inspectable, version-controlled representation of:

- what is known;
- what is believed;
- why it is believed;
- what evidence supports or contradicts it;
- how certain the system is;
- what remains unknown or disputed.

No model is treated as an authority.

Important conclusions should remain traceable through:

```text
Conclusion
   ↓
Canonical wiki node / claim
   ↓
Supporting and contradicting evidence
   ↓
Source record
   ↓
Original source
```

The human owner must always be able to inspect this chain without relying on an AI model.

---

## 2. Repository Structure

```text
knowledge/
├── README.md
├── KNOWLEDGE_PROTOCOL.md
├── WORKER_PROTOCOL.md
├── sources/
├── proposals/
└── wiki/
```

`raw_data/` (see below) lives at the repository root, as a sibling of `knowledge/`, not inside it — see `SYSTEM_SPEC.md` §3.

### `sources/`

Contains source records: tracked, version-controlled Markdown describing external evidence.

A source record holds two distinct kinds of content. Keep them separate.

**Provenance metadata** — title, URL, author, publication and retrieval dates, source type, and, when an original is kept, its path into `raw_data/`.

**Cited content** — by default, the record also holds the actual passage a claim relies on, not just a pointer to it:

- for text sources, a verbatim excerpt of the specific passage cited — the passage actually referenced, not the whole document;
- for non-text sources (images, audio, etc.), a literal, low-interpretation transcription or description of what the medium shows — visible text, chart values, what is depicted — explicitly labeled as agent-generated and unverified, since turning an image into words is inherently interpretive in a way copying text verbatim is not.

This is why the abstraction is worth the extra step: `raw_data/` is untracked and can be lost (disk cleanup, migration, `.gitignore`'d by design), but `sources/` is in Git. Copying the cited passage in means the exact thing a claim rests on survives even if the archived original doesn't — a bare URL-plus-metadata record does not offer that.

Cited content is evidence of what the source says, not an interpretation of it. A source record must never explain why the source matters, what it proves, or how it's relevant — that judgment belongs in a proposal or claim that cites the source (see `proposals/` and `wiki/` below), never in the record itself. Blurring this is exactly the epistemic laundering this protocol's own §8 (Source Integrity) and `SYSTEM_SPEC.md` §26 exist to prevent.

A source record may optionally note why it was *included* — e.g. `retrieved_for: WP-04` or `retrieved_for: R-0007`, naming the task or research project that prompted fetching it, mirroring the `derived_from_research` pattern in `research/RESEARCH_PROTOCOL.md` §13. This is acquisition context, not a relevance judgment: it says what prompted archiving the source, never what the source is taken to show. If the note starts explaining what the source demonstrates, it belongs in a proposal instead.

Source records are what canonical claims cite and link to.

Example:

```yaml
---
id: S-000052
source_type: article
title: "..."
url: "..."
author: "..."
published: 2026-06-01
retrieved: 2026-08-22
raw_data: raw_data/S-000052.pdf
retrieved_for: WP-04
---
```

```markdown
## Cited excerpt

> "...the exact passage a claim relies on..."
```

### `raw_data/`

Root-level, alongside `knowledge/`. Contains the archived original material a source record points to.

Whenever a source exists as a retrievable file — a downloaded PDF, a saved webpage, an image, a dataset export, an API response — archiving it here is the **default**, not an optional extra. A source record alone lets a human trust a citation; the archived file in `raw_data/` lets them independently re-open and re-check it later, even if the live URL changes, is paywalled, or disappears. That is what keeps claims verifiable per `SYSTEM_SPEC.md` §2, so do not skip this step merely because the source record's metadata already looks sufficient.

Skip archiving only when there genuinely is no retrievable file to save — e.g. a live human observation typed up as a note, or a source too large to be practical to mirror locally. In those cases the source record itself is the only durable artifact, and that limitation should be visible (e.g. no `raw_data/` path in the record).

Examples of what belongs here:

- downloaded papers, articles, and other documents (PDF, HTML, etc.);
- saved copies of webpages;
- images and screenshots;
- datasets;
- raw API responses;
- interview transcripts and other typed-up human observations, when a durable copy exists.

`raw_data/` is not version-controlled (see `.gitignore`). It can be large. It is not required for provenance in the sense that the source record in `sources/` already preserves the citable metadata — but it is required for independent re-verification, which is the whole point of keeping it. Treat `raw_data/` as a local cache, not the system of record.

A file in `raw_data/` should be named to match its source record's ID (e.g. `sources/S-000052.md` ↔ `raw_data/S-000052.pdf`), so the link between them is discoverable without parsing frontmatter.

Agent-generated summaries, interpretations, or conclusions are **not sources**, whether in `sources/` or `raw_data/`.

### `proposals/`

Contains untrusted candidate knowledge and proposed changes to the canonical graph.

Examples:

- extracted findings;
- candidate claims;
- candidate nodes;
- proposed links;
- suggested edits;
- possible contradictions;
- unanswered questions.

Material in `proposals/` is **not canonical knowledge**.

### `wiki/`

Contains the canonical knowledge graph.

Canonical does not mean unquestionably true. A canonical node may explicitly be:

- uncertain;
- disputed;
- weakly supported;
- superseded;
- unresolved;
- unknown.

Canonical means that the node has been deliberately accepted into the maintained knowledge graph.

---

## 3. The Wiki Is a Graph

The canonical wiki is a graph of Markdown pages.

Each page is a **node**.

Markdown links between pages form **edges**.

Folder structure exists mainly for human convenience and does not define the graph.

Agents should prefer explicit links to related canonical nodes when those nodes already exist.

---

## 4. Node Types

Version 0.1 recognizes these node types.

### `entity`

A person, company, organization, project, product, place, system, or other identifiable thing.

### `concept`

An idea, category, method, technology, phenomenon, or general subject.

### `claim`

A proposition that may be supported, contradicted, qualified, or revised.

A proposition should usually become its own claim node when it is:

- consequential;
- uncertain;
- disputed;
- supported by multiple sources;
- referenced by multiple other nodes;
- likely to change;
- important enough that its evidence should be directly inspectable.

Not every trivial fact needs a dedicated claim page.

### `question`

A known gap in the knowledge graph.

Questions are first-class knowledge objects.

### `synthesis`

A higher-level interpretation built from multiple claims, entities, concepts, or sources.

Syntheses must distinguish established observations from inference and speculation.

---

## 5. IDs and Canonical Node Metadata

### ID Prefixes

IDs are allocated from one shared registry across the repository, so a prefix always identifies the same kind of thing wherever it's cited — even though only some of these prefixes are canonical wiki nodes.

```text
E-       entity        (wiki node)
CON-     concept       (wiki node)
C-       claim         (wiki node)
Q-       question      (wiki node)
SYN-     synthesis     (wiki node)
S-       source        (source record — not a wiki node; see §2, `sources/`)
```

IDs should remain stable even if titles or filenames change.

### Canonical Node Frontmatter

Canonical wiki nodes (`E-`, `CON-`, `C-`, `Q-`, `SYN-`) should use YAML frontmatter.

Example:

```yaml
---
id: C-000184
type: claim
status: supported
confidence: medium
created: 2026-08-22
updated: 2026-08-22
---
```

Source records (`S-`) are evidence, not wiki nodes — they don't carry `status` or `confidence`. Their frontmatter is shown in §2, `sources/`.

---

## 6. Status and Confidence

Suggested claim statuses:

```text
supported
weakly-supported
disputed
superseded
rejected
unknown
```

Suggested question statuses:

```text
open
investigating
resolved
blocked
```

Use coarse confidence labels initially:

```text
low
medium
high
```

Confidence should consider:

- source reliability;
- evidence strength;
- independent corroboration;
- recency;
- contradictory evidence;
- extraction certainty;
- amount of interpretation required;
- known commercial or institutional incentives.

Confidence must not simply reflect how confident a model sounds.

---

## 7. Evidence and Provenance

Important factual claims should identify supporting and contradicting evidence.

Example:

```markdown
## Evidence

### Supporting

- [[S-000017]]
- [[S-000024]]

### Contradicting

- [[S-000031]]
```

Where practical, source records should preserve:

- original URL or location;
- source title;
- author or publisher;
- publication or observation date;
- retrieval date;
- source type;
- path to the archived original in `raw_data/` (default whenever a retrievable file exists — see `raw_data/` above);
- the cited excerpt or transcription itself, plus a page, section, or timestamp locator within the original (see `sources/` above);
- known commercial or institutional relationship.

A human should be able to use the source record to inspect the original evidence.

---

## 8. Source Integrity

The system must preserve the distinction between:

```text
external evidence
```

and:

```text
AI interpretation of external evidence
```

Agent-generated summaries, reports, explanations, inferred facts, synthetic examples, and confidence statements must never become evidence merely because an agent produced them.

Agent output may become canonical knowledge only through review and promotion.

Agent output does not become evidence for itself.

---

## 9. Commercial and Incentive Provenance

Known incentives should be recorded when relevant.

Examples:

- manufacturer;
- advertiser;
- affiliate;
- sponsored placement;
- seller;
- employee;
- competitor;
- research institution;
- government;
- anonymous user.

Commercial evidence is not automatically unreliable. Its relationship to the claim must simply remain visible.

---

## 10. Contradictions

Credible contradictory evidence must not be silently removed.

When evidence conflicts:

1. preserve both sides;
2. link the relevant evidence or claims;
3. qualify the canonical statement;
4. mark the node disputed where appropriate;
5. create an open question if more evidence is needed;
6. do not force a resolution merely to make the graph cleaner.

A well-maintained contradiction is better than a false resolution.

---

## 11. Unknowns

`unknown` and `insufficient evidence` are valid outcomes.

Agents must not manufacture conclusions because a task appears to expect an answer.

When evidence is insufficient:

```text
record uncertainty
   ↓
create or update a question node
   ↓
identify evidence that could resolve it
```

Knowledge gaps should be reusable as future research tasks.

---

## 12. Links and Duplicate Prevention

Agents should link relevant canonical nodes explicitly.

Before creating a new node:

1. search for an existing node representing the same thing;
2. prefer updating or linking to the existing node;
3. create a new node only when it represents meaningfully distinct knowledge.

If duplicate nodes are discovered later, merge them deliberately and preserve relevant information.

---

## 13. Proposals

Workers should normally write to `proposals/`, not directly to `wiki/`.

A proposal is a suggested mutation to the canonical graph.

It may propose:

- creating a node;
- modifying a node;
- adding or removing a link;
- qualifying a claim;
- splitting or merging nodes;
- creating a question;
- changing confidence or status;
- recording a contradiction.

A proposal should identify:

- the task or question being addressed;
- sources examined;
- candidate finding or change;
- supporting evidence;
- contradicting evidence;
- confidence;
- uncertainties;
- relevant existing wiki nodes;
- suggested graph changes.

Proposals may be incomplete, duplicated, contradictory, or wrong.

They are a work queue, not trusted knowledge.

---

## 14. Promotion to the Canonical Wiki

A proposal becomes canonical only after review.

A reviewer may:

```text
accept
modify
merge
split
reject
defer
request more evidence
```

Before promotion, check:

1. Does an equivalent node already exist?
2. Does the cited evidence actually support the statement?
3. Is important contrary evidence represented?
4. Is uncertainty expressed appropriately?
5. Are relevant existing nodes linked?
6. Is confidence justified?
7. Is the knowledge significant enough to preserve?
8. Does the change create or resolve an open question?

Prefer a qualified true statement over a stronger unsupported statement.

---

## 15. Canonical Editing

When modifying canonical knowledge:

- preserve useful existing information;
- preserve relevant evidence;
- preserve credible contradictions;
- avoid unnecessary rewrites;
- prefer existing nodes over duplicates;
- link related nodes;
- update metadata when appropriate;
- keep pages understandable to a human reader.

The canonical wiki must remain useful without access to the model that created it.

---

## 16. Review Philosophy

Reviewers are not oracles.

The correct review question is:

> Given the available evidence, what can we responsibly maintain in the knowledge graph?

not:

> What does my model believe is true?

Important review decisions should remain understandable through the resulting page, associated proposal, and Git history.

---

## 17. Human and Machine Readability

The canonical wiki should be useful to both humans and software.

Use:

- ordinary Markdown;
- consistent YAML frontmatter;
- stable IDs;
- explicit wiki links;
- predictable headings;
- explicit status and confidence fields.

Avoid proprietary formats that make the repository dependent on one AI system.

---

## 18. Explicit Graph Representation

Markdown is the canonical authoring format.

A future deterministic compiler may derive an explicit graph containing:

```text
nodes
edges
node types
status
confidence
source relationships
```

The generated graph is derived state and must never become an independently edited competing source of truth.

Conceptually:

```text
Markdown wiki
    ↓ compile
explicit graph index
    ↓
analysis / navigation / context selection
```

---

## 19. Structural Validation

Deterministic tooling should eventually check:

- duplicate IDs;
- broken links;
- malformed frontmatter;
- missing source references;
- orphaned nodes;
- claim nodes without evidence;
- missing required metadata.

Do not spend LLM reasoning on tasks deterministic software can perform reliably.

---

## 20. Semantic Maintenance

Agents should handle semantic work such as:

- identifying conceptual duplicates;
- detecting contradictions;
- evaluating whether evidence supports a claim;
- deciding whether a proposition deserves its own node;
- synthesizing multiple claims;
- identifying missing concepts;
- distinguishing similar terms with different meanings.

High-capability models should be reserved for difficult or consequential semantic work.

---

## 21. Git and Ownership

The canonical knowledge repository should be version-controlled.

Git history should make it possible to inspect:

- what changed;
- when it changed;
- what evidence was added or removed;
- which conclusions were revised;
- how the graph evolved.

The repository and evidence chain belong to the human owner, not to any model provider.

---

## 22. Agent Responsibilities

### Ephemeral Worker

Workers:

- read assigned sources;
- read relevant canonical wiki nodes;
- search for existing nodes;
- produce proposals;
- identify possible contradictions and knowledge gaps.

Workers must not:

- treat their own output as evidence;
- invent sources;
- hide uncertainty;
- silently create canonical truth;
- modify `wiki/` unless explicitly authorized.

Workers should follow `WORKER_PROTOCOL.md`.

### Boss

Boss:

- interprets high-level research goals;
- decomposes them into bounded tasks;
- writes precise worker briefs;
- organizes and reviews proposals;
- requests more evidence when needed;
- promotes routine, adequately supported proposals into canonical knowledge;
- performs routine canonical wiki maintenance;
- decides which difficult or consequential issues require Professor review.

Boss is the normal day-to-day maintainer of canonical knowledge and does not need Professor approval for routine promotions (`SYSTEM_SPEC.md` §6).

### Professor

Professor:

- reviews difficult or consequential proposals and canonical changes;
- performs synthesis;
- resolves or explicitly preserves contradictions;
- may edit or recommend edits to the canonical wiki when invoked;
- identifies conceptual errors and important gaps.

Professor must remain evidence-bound and auditable.

### Human Owner

The human has final authority and must always be able to:

- inspect sources;
- inspect proposals;
- inspect canonical pages;
- inspect Git history;
- challenge conclusions;
- override agent decisions.

---

## 23. Core Rule

The system optimizes for **inspectable knowledge**, not convincing answers.

For an important conclusion, it should remain possible to ask:

```text
Why do we believe this?
What evidence supports it?
What evidence contradicts it?
How certain are we?
What remains unknown?
What changed this conclusion?
Can I inspect the original source myself?
```

If the system cannot answer those questions, the knowledge is not mature enough.

---

## 24. Version 0.1 Constraint

This protocol is deliberately incomplete.

Do not add complexity merely because it may someday be useful.

New node types, metadata, graph representations, review mechanisms, and automation should be added only when real usage demonstrates a need.

The protocol itself should evolve through Git.

---

## Guiding Principle

> **Models are fallible participants. Evidence is preserved. Knowledge is versioned. Important conclusions remain independently verifiable by the human who owns the system.**
