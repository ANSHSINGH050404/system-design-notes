# System Design Notes

Written notes for the twelve-project system design ladder — the concepts, the
resources worth reading, and the bugs that the implementation actually hit.

> [!summary] What this is
> A companion to the [`system-design`](https://github.com/ANSHSINGH050404/system-design)
> code repo, which contains twelve working implementations of the mechanisms
> these notes describe: rate limiting, caching, job queues, consistent hashing,
> quorums, vector clocks and more.
>
> **340 tests. 0 failures. Every failure mode demonstrated, not described.**

---

## The notes

| Note | What it covers |
|---|---|
| [Projects.md](Projects.md) | The twelve projects, what each teaches, and **the 15 real bugs the tests caught** |
| [Learning-Resources.md](Learning-Resources.md) | Courses, YouTube, blogs, papers and hands-on platforms — filtered for implementation over diagrams |
| [System-Design-Home.md](System-Design-Home.md) | The map of the whole thing, and the vault conventions |
| [Quick-Commerce-System-Design.md](Quick-Commerce-System-Design.md) | A food delivery platform design (Zomato/Swiggy scale) |

---

## The ladder, in one table

| # | Project | The one lesson |
|---|---|---|
| 1 | Distributed rate limiter | Read-decide-write must be a single indivisible step |
| 2 | LRU cache + cache-aside | A cache reduces load by *collapsing duplicate work* — and if you don't collapse it explicitly, the duplicate work arrives all at once |
| 3 | Idempotent job queue | At-least-once + an idempotent handler = the *illusion* of exactly-once |
| 4 | URL shortener + analytics | The read:write ratio decides the design; the analytics write never belongs on the read path |
| 5 | Load balancer / reverse proxy | Only idempotent methods may be retried — a data-corruption rule, not an availability rule |
| 6 | Web crawler | A failure to find robots.txt looks exactly like permission |
| 7 | Chat service | Write durably BEFORE you publish; the log is the truth, the bus is the path |
| 8 | News feed | Fan-out is a read/write tradeoff chosen per author, not per system |
| 9 | Search engine | The query and the index MUST use the same tokenizer, or search silently returns nothing |
| 10 | Distributed log (Kafka-lite) | Offsets are consumer state, not log state |
| 11 | KV store (DynamoDB-lite) | You cannot have strong consistency, availability and partition tolerance |
| 12 | Global rate limiter | The local tier can only make the limit *stricter*, never looser |

---

## The thread through all twelve

| Lesson | First seen | Repeated in |
|---|---|---|
| Read-decide-write must be atomic | 1 | 3, 9, 11 |
| One clock, one truth | 1 | 4, 7, 11 |
| State must be bounded (TTL, eviction, retention) | 1 | 2, 4, 6, 9, 10 |
| Duplicate work must be collapsed explicitly | 2 | 3, 5, 7, 12 |
| Failure must be a decision, not an accident | 1 | 2, 3, 5, 6, 9, 11 |
| The fast tier is local; the correct tier is shared | 2 | 5, 12 |
| Capacity math eliminates options before you build | 1 | 4, 6, 8, 10 |
| You cannot have all three of CAP | 11 | 12 |

> Most of system design is **one question asked twelve times**: *what happens
> when this breaks, and what have you decided?*

---

## The bugs the tests caught

The most valuable output of the ladder — each is a bug that reads fine and is
invisible in review.

| Where | The bug |
|---|---|
| 1 | A naive `GET`-then-`INCR` limiter admits **5× the limit** under concurrency |
| 2 | The `LruMap` auto-trimmed itself, so the eviction *policy* was never consulted |
| 3 | `MAX(sequence)+1` is not atomic — 20 concurrent writers all read the same value |
| 4 | A Snowflake sequence rollover **overwrote the advanced timestamp**, emitting a duplicate id |
| 4 | `Date.now()` and `performance.now()` mixed, producing a negative duration |
| 5 | `least-response-time` treated an unmeasured backend (latency 0) as the fastest — it would get *all* the traffic |
| 5 | Slow start treated a never-checked backend as newly healthy, so every existing backend got the ramped weight |
| 6 | `siteOf()` dropped the port, so robots.txt was fetched from the wrong place — and a missing rules file looks like permission |
| 6 | The content hash included the page title, so mirrored pages never deduped |
| 7 | The sequence counter was off by one (`next_sequence - 1` instead of `next_sequence`) |
| 8 | `DESC` is not valid inside a `PRIMARY KEY` constraint in Postgres |
| 9 | The trie used the *prefix* count as term frequency, so "car" outranked "cargo" |
| 10 | Committed offsets used the last-processed convention; Kafka uses the next-offset one |
| 11 | FNV-1a has poor avalanche for similar keys — it broke the hash ring's load distribution entirely |
| 11 | A *crashed* node was being removed from the ring, silently re-sharding the keyspace during an outage |
| 12 | The hierarchical limiter reported limits it was not enforcing — one limiter, three unused `limit` fields |

Almost every one of these is a **silent** failure: not an exception, not a
failed assertion — a wrong answer that looks like a right one. Which is why
the projects assert on *state* (query counts, memory usage, hit rates) rather
than only on return values.

---

## Running the code

```bash
git clone https://github.com/ANSHSINGH050404/system-design.git
cd system-design
docker compose up -d --wait     # Redis + Postgres

cd project-1-rate-limiter
bun install
bun test
```

Each project has `design.md` (the written design) and `exercises.md` (tasks
where you break the system on purpose and predict the failure first).

---

## How these notes are maintained

These files are a **published snapshot** of an Obsidian vault. The vault is
the source of truth; `sync-from-vault.ps1` copies the notes out and rewrites
the handful of references that only make sense inside a vault.

```powershell
.\sync-from-vault.ps1
git add -A
git commit -m "sync: refresh notes from the vault"
git push
```

A few references in these notes point to other folders in the author's vault
(`ATLAS/LLD`, `opencode-docs/*`). They appear as plain text here and resolve
as links in Obsidian.
