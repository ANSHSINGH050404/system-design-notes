---
tags: [moc, system-design, index]
created: 2026-10-27
status: active
type: map
---

# System Design — Home

Entry point for this folder. Everything else in the vault is reachable from here.

Related: [[Learning-Resources]] · `ATLAS/LLD` · `opencode-docs/MISSION`

---

## 📍 In this folder

| Note | What it is |
|---|---|
| [[Projects]] | The twelve projects, what each teaches, and the bugs the tests caught |
| [[Learning-Resources]] | Courses, YouTube, blogs, papers, books, hands-on platforms — filtered for implementation over diagrams |
| [[Quick-Commerce-System-Design]] | Food delivery platform design (Zomato/Swiggy scale) |
| [[Pi-vs-OpenCode-Architecture]] | Deep dive comparing two agent harnesses — includes 13 Mermaid diagrams and a "what to steal" section |

---

## 🗂️ Elsewhere in the vault

- `ATLAS/LLD` — low-level design notes
- `opencode-docs/MISSION` — the mission doc
- `opencode-docs/NOTES` — working notes

---

## 🏗️ The build ladder

Projects live in `ANSHSINGH050404/system-design` (git-tracked). Each one isolates a few
concepts, implements them against real Redis/Postgres, and ends with a written
design document and a set of exercises that break the system on purpose.

| # | Project | Core concepts | Status |
|---|---|---|---|
| 1 | Distributed rate limiter | Atomicity, concurrency, TTL, clocks, fail-open vs fail-closed | ✅ Done |
| 2 | LRU cache + cache-aside | Data structures, eviction policies, stampede, penetration, avalanche, invalidation | ✅ Done |
| 3 | Idempotent job queue | At-least-once vs exactly-once, backoff + jitter, dead-letter queues, idempotency keys | ✅ Done |
| 4 | URL shortener + analytics | Key generation, 301 vs 302, Snowflake IDs, write-behind counters | ✅ Done |
| 5 | Reverse proxy / load balancer | Balancing algorithms, active + passive health checks, idempotent retries, draining | ✅ Done |
| 6 | Web crawler | URL canonicalization, robots.txt, priority frontier, politeness, content dedupe | ✅ Done |
| 7 | Chat service | WebSockets, presence, message ordering, cross-instance pub/sub, replay | ✅ Done |
| 8 | News feed | Fan-out on write vs read, the hybrid, celebrity problem, keyset pagination | ✅ Done |
| 9 | Search engine | Inverted index, BM25, tokenization, stemming, trie autocomplete | ✅ Done |
| 10 | Distributed log (Kafka-lite) | Partitions, offsets, consumer groups, rebalancing | ✅ Done |
| 11 | KV store (DynamoDB-lite) | Consistent hashing, quorums, vector clocks, conflict detection | ✅ Done |
| 12 | Global rate limiter | Two-tier global+local, hierarchical limits, per-region budgets | ✅ Done |

**340 tests, 0 failures, typecheck clean.**

> [!tip] The rule of the ladder
> Every project must have a **failure mode you can trigger on purpose**.
> A rate limiter that never loses Redis teaches nothing. A rate limiter that
> over-admits under concurrency teaches the single most important lesson in
> system design.

### The thread between them

> [!summary] Project 1 → Project 2
> Project 1 taught that a limit has to be **global** to be a limit, and that
> local-only enforcement is not enforcement.
>
> Project 2 hit the same wall from the other side: a cache is fast because it
> is **local**, and correct because it is **shared**. Same resolution in both
> cases — two tiers, local in front of shared — because the fast tier protects
> the shared tier, and the shared tier provides the global view and the global
> invalidation.

---

## 🔬 What each project is for

| Project | The one lesson |
|---|---|
| 1 | Reading state and writing state must be a single indivisible step |
| 2 | A cache doesn't reduce load by being fast; it reduces load by *collapsing duplicate work* — and if you don't collapse it explicitly, the duplicate work arrives all at once |
| 3 | At-least-once delivery + idempotency = the *illusion* of exactly-once |

---

## 📝 Vault conventions

For consistency across notes:

- **Frontmatter** — `tags`, `created` (`YYYY-MM-DD`), `status`, and `type`
  (`reference` · `map` · `design`).
- **Callouts** — `> [!info]` for context, `> [!summary]` for the thesis,
  `> [!tip]` for what to steal, `> [!warning]` for a known gap, `> [!danger]`
  for a hard constraint.
- **Links** — double-bracket wikilinks for vault notes; add a folder path or a
  `|label` alias when the name needs disambiguating. Broken links are noise —
  either create the note or write plain text.

  ```text
  [[Note]]
  [[folder/note]]
  [[folder/note|custom label]]
  ```

- **Diagrams** — Mermaid for anything structured; Excalidraw for
  architecture sketches (saved to `Excalidraw/`).
- **Tables over bullet lists** for comparisons, always.

---

## 🧭 Where to pick up next

**Project 3** (idempotent job queue) is next, and it needs one blog post read
first: ["Exponential Backoff and Jitter"](https://www.awsarchitectureblog.com/2015/03/backoff-jitter.html).

Before starting it, finish the **project 2 exercises** — specifically #1
(stampede), #3 (avalanche) and #9 (lost invalidation). Those are the three
that would actually page you.
