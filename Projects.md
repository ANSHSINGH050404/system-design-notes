---
tags: [system-design, projects, index]
created: 2026-10-27
status: active
type: map
---

# The Twelve Projects

Every project lives in `ANSHSINGH050404/system-design` (git-tracked). Each one isolates a
few concepts, implements them against real Redis/Postgres, and ends with a
written design document and exercises that break the system on purpose.

Related: [[System-Design-Home]] · [[Learning-Resources]]

---

## The ladder

| # | Project | The one lesson | Tests |
|---|---|---|---|
| 1 | `project-1-rate-limiter` | Read-decide-write must be a single indivisible step | 40 |
| 2 | `project-2-cache` | A cache reduces load by *collapsing duplicate work* — and if you don't collapse it explicitly, the duplicate work arrives all at once | 61 |
| 3 | `project-3-job-queue` | At-least-once + an idempotent handler = the *illusion* of exactly-once | 27 |
| 4 | `project-4-url-shortener` | The read:write ratio decides the design; the analytics write never belongs on the read path | 31 |
| 5 | `project-5-load-balancer` | Only idempotent methods may be retried — this is a data-corruption rule, not an availability rule | 29 |
| 6 | `project-6-web-crawler` | A failure to find robots.txt looks exactly like permission | 43 |
| 7 | `project-7-chat-service` | Write durably BEFORE you publish; the log is the truth, the bus is the path | 12 |
| 8 | `project-8-news-feed` | Fan-out is a read/write tradeoff chosen per author, not per system | 14 |
| 9 | `project-9-search-engine` | The query and the index MUST use the same tokenizer, or search silently returns nothing | 21 |
| 10 | `project-10-distributed-log` | Offsets are consumer state, not log state — that is what makes many independent readers possible | 23 |
| 11 | `project-11-kv-store` | You cannot have strong consistency, availability and partition tolerance | 23 |
| 12 | `project-12-global-rate-limiter` | The local tier can only make the limit *stricter*, never looser | 16 |

**340 tests, 0 failures.**

---

## The lessons, and where they repeat

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

> [!summary] The through-line
> Most of system design is **one question asked twelve times**: *what happens
> when this breaks, and what have you decided?*
>
> Project 1 asks it about atomicity. Project 11 asks it about CAP. It is the
> same question wearing different clothes.

---

## The bugs the tests caught

These are the most valuable output of the whole ladder — each one is a bug
that reads fine and is invisible in review.

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

> [!tip] The pattern
> Almost every one of these is a **silent** failure. Not an exception, not a
> failed assertion — a wrong answer that looks like a right one. Which is
> exactly why the projects are built around tests that assert on *state*
> (query counts, memory usage, hit rates) rather than only on return values.

---

## Running them

```bash
cd ANSHSINGH050404/system-design
docker compose up -d --wait      # Redis + Postgres

cd project-1-rate-limiter
bun install
bun test
```

Each project also has `bun run demo` (projects 1–5) to watch the mechanism
behave, `design.md` for the written design, and `exercises.md` for the tasks
where you break it on purpose.

---

## Next

1. **Do the exercises.** 7–10 per project. The ones that matter are where
   you predict wrong.
2. **MIT 6.5840.** The KVS lab is project 11 with a fault injector; the
   Raft lab is project 10 done properly.
3. **Build something of your own.** The ladder is a curriculum; the skill
   only arrives on something nobody assigned you.

Related: [[System-Design-Home]] · [[Learning-Resources]]
