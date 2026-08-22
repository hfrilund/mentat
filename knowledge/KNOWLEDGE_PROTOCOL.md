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
├── raw/
├── proposals/
└── wiki/
```

### `sources/`

Contains source records: tracked, version-controlled Markdown describing external evidence — provenance metadata such as title, URL, author, publication and retrieval dates, source type, and, when an original is kept, its path into `raw/`.

Source records are what canonical claims cite and link to.

### `raw/`

Contains the archived original material a source record points to.

Examples:

- papers;
- articles;
- webpages;
- interview transcripts;
- datasets;
- documents;
- API responses;
- human observations;
- other archived external material.

`raw/` is not version-controlled (see `.gitignore`). It can be large, and it is not required for provenance — the source record in `sources/` already preserves the citable metadata. Treat `raw/` as a local cache, not the system of record.

A raw file's name should match its source record's ID (e.g. `sources/S-000052.md` ↔ `raw/S-000052.pdf`), so the link between them is discoverable without parsing frontmatter.

Agent-generated summaries, interpretations, or conclusions are **not sources**, whether in `sources/` or `raw/`.

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

## 5. Canonical Node Metadata

Canonical wiki nodes should use YAML frontmatter.

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

Suggested ID prefixes:

```text
E-       entity
CON-     concept
C-       claim
Q-       question
SYN-     synthesis
S-       source
```

IDs should remain stable even if titles or filenames change.

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
- path to the archived original in `raw/`, when one is kept;
- relevant page, section, timestamp, or excerpt reference;
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
- decides which issues require Professor review.

### Professor

Professor:

- reviews difficult or consequential proposals;
- performs synthesis;
- resolves or explicitly preserves contradictions;
- edits the canonical wiki;
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
