---
tags: [system-design, learning, resources, roadmap]
created: 2026-10-27
status: active
type: reference
---

# Learning Resources

> [!summary] How to use this note
> Filtered for one specific gap: **I know the concepts, I need the implementation.**
> Most system-design content teaches interview pattern-matching — watch a diagram,
> memorize the components. This list is filtered down to material that shows
> *mechanisms and failure modes*.
>
> **Rule of thumb:** if it ends with a box-and-arrow diagram, skip it.
> If it ends with "here's what breaks at 3am", watch it.

Related: [[System-Design-Home]] · `ATLAS/LLD` · `opencode-docs/MISSION`

---

## 1. Courses

### MIT 6.5840 — Distributed Systems  ★★★★★

Course site: [pdos.csail.mit.edu/6.824](https://pdos.csail.mit.edu/6.824/index.html) (running Spring 2026)
Lecture recordings (2020): [YouTube playlist](https://www.youtube.com/playlist?list=PLrw6a1wE39_tb2fErI4-WkMbsvGQk9_UB)

The **labs are the real course**, and they map almost one-to-one onto the project ladder:

| Lab | Project it preps |
|---|---|
| Key/Value Server | URL shortener |
| **Raft** | Distributed log (Kafka-lite) |
| **Fault-tolerant KV store** | DynamoDB-lite |

> [!tip] Projects 10 and 11 of the ladder *are* the MIT labs.
> Do them together — the lab gives you the test harness, the project gives you
> the design document.

### CMU 15-445 — Introduction to Database Systems

Full course on YouTube (Andy Pavlo). Best free database internals course going.
Do it before project 4 and 9.

---

## 2. YouTube

### Tier A — "how it actually works"  ★★★★★

**[Hussein Nasser](https://www.youtube.com/@hnasr)** — 479K subs, ~1,000 videos

His *Backend Engineering Show* teaches mechanisms, not architectures. This is the
single best fit for the implementation gap.

| Video | Project |
|---|---|
| *Consistent Hashing* (multi-part, full syllabus: simple hashing → where it breaks → adding a server → removing a server → limitations) | 11 |
| *Redis In-Memory Database Crash Course* | 2 |
| *B-Tree vs B+ Tree* | 4, 9 |
| *Load balancing in Layer 4 vs Layer 7* | 5 |
| *How HTTP/2 Works* | 5 |

Free course: [backend.husseinnasser.com](https://backend.husseinnasser.com/)

### Tier B — design reasoning  ★★★★

**[ByteByteGo](https://www.youtube.com/@ByteByteGo)** — 1.4M subs, ~171 videos

Polished animations, ~10 min each. Pairs with the free Substack newsletter
(~10 min read weekly). Directly relevant:
*"Rate Limiter System Design: Token Bucket, Leaky Bucket, Scaling"*.

**[Gaurav Sen](https://www.youtube.com/@gkcs)** — 758K subs

[System Design Playlist](https://www.youtube.com/playlist?list=PLMCXHnjXnTnvo6alSjVkgxV-VH6EPyvoX) (26 videos).
His real value is **thinking out loud**, including the discarded first ideas,
rather than presenting a finished answer. That reasoning trace is the thing
that's missing when you only ever see the final diagram.

### Tier C — deep dives on one mechanism

- *Redis Cluster: hash slots, gossip protocol* — why Redis rejected consistent hashing
- *What is Consistent Hashing and where is it used* (Gaurav Sen) — the visual intuition version

---

## 3. Blogs

### Cache failure modes

| Resource | Why |
|---|---|
| **[antirez — Cache Stampede Prevention](https://redis.antirez.com/fundamental/cache-stampede-prevention.html)** | The canonical guide, written by the Redis author. Locking, request coalescing, and **X-Fetch**. |
| [a.co — Cache Stampede and Thundering Herd](https://a.co/2023/01/17/thundering-herd/) | The post that named it. Short, sharp. |
| [will-larson.com](https://www.lethain.com/) | *"Cache Stampede"* — the lock-based approach, from someone who ran production systems. |
| [redis.io/blog](https://redis.io/blog) | Official. Good on eviction and Lua. |

### Retries, backoff and jitter  ★★★★★ (read before project 3)

**["Exponential Backoff and Jitter"](https://www.awsarchitectureblog.com/2015/03/backoff-jitter.html)** — Marc Brooker, AWS.

Everything about why naive exponential backoff *synchronizes* your retries into
a thundering herd. **Highest-value single post for project 3.**

### How real systems break

- [highscalability.com](https://highscalability.com/) — real architecture case studies
- [martinfowler.com/articles](https://martinfowler.com/articles/) — caching patterns, circuit breaker, *"Poisonous Data"*
- [martin.kleppmann.com](https://martin.kleppmann.com/) — *"Please stop calling databases CP or AP"*
- [vlad.tech](https://vlad.tech/) — replication, failover
- [alexwest.dev](https://alexwest.dev/) — *"The Nasty State of Distributed Systems"*
- [cloudflare.com/blog](https://blog.cloudflare.com/) · [dropbox.tech](https://dropbox.tech/) · [discord.com/blog/engineering](https://discord.com/blog/engineering) · [shopify.engineering](https://shopify.engineering/) — real postmortems

> [!note] Dropbox's Magic migration and Shopify's caching write-ups are worth
> reading for a different reason: they show the *cost* of a decision, not just
> the decision.

---

## 4. Papers

The eight that matter, ordered by how directly they map to the ladder.

| Paper | Why | Project |
|---|---|---|
| **Sleator & Tarjan**, *Amortized Efficiency of List Update and Paging Rules* (CACM 1985) | The theory proving LRU is competitive. **The math behind the eviction-policy question.** | 2 |
| **Manes**, *A Performance Evaluation of Caching Algorithms* (2010) | The Caffeine benchmark: LRU vs LFU vs random vs ARC on real traces. | 2 |
| **Vattani et al.**, *Optimal Probabilistic Cache Stampede Prevention* (VLDB 2015) | The XFetch paper. | 2 |
| **Dean & Barroso**, *The Tail at Scale* (CACM 2013) | Why p99 matters and how latency compounds across fan-out. | 5, 7 |
| **Kleppmann**, *The Log: The Inferiority of RDBMS as a Message Queue* (2011) | The idea behind the distributed log, in 4 pages. | 3, 10 |
| **DeCandia et al.**, *Dynamo: Amazon's Highly Available KV Store* (2007) | Quorums, vector clocks, eventual consistency. | 11 |
| **Ongaro & Ousterhout**, *In Search of an Understandable Consensus Algorithm* (2014) | Raft. | 10 |
| **Kreps**, *Kafka: a Distributed Log in Simple Terms* (2011) | Partitions and consumer groups. | 10 |

---

## 5. Books

- **Designing Data-Intensive Applications** (Kleppmann) — the one book that changes how you think. Chapter 7 is where idempotency clicks.
- **Database Internals** (Alex Petrov) — LSM trees and B-trees. Read before projects 4 and 9.
- **A Philosophy of Software Design** (Ousterhout) — *deep modules*. The book behind the "the interface is the design decision" lesson.
- **Designing Distributed Systems** (Elkies) — approachable project-based intro.

---

## 6. Hands-on  ★★★★★ (matches how we actually learn)

- **[builddistributedsystem.com](https://builddistributedsystem.com/)** — supports **TypeScript**, Maelstrom-compatible, free Mini-Dynamo track. Message passing → consensus → storage engines.
- **[CodeCrafters](https://codecrafters.io/)** — Redis, Kafka, Raft, Bitcask, gRPC.
- **[alexxulu/system-design-primer](https://github.com/alexxulu/system-design-primer)** — the canonical free reference. Use as an index, not a read-through.
- [ashishps1/awesome-system-design-resources](https://github.com/ashishps1/awesome-system-design-resources) — curated index
- [karanpratapsingh/system-design](https://github.com/karanpratapsingh/system-design) — structured learning path

---

## 7. Mapped to the project ladder

| # | Project | Primary resources |
|---|---|---|
| 1 | Rate limiter | antirez Redis docs · AWS backoff post · ByteByteGo rate limiter video |
| 2 | Cache | Manes 2010 · Sleator & Tarjan 1985 · Vattani 2015 · antirez stampede guide |
| 3 | Job queue | **AWS backoff & jitter** · Kleppmann *The Log* · RabbitMQ/Kafka docs |
| 4 | URL shortener | CMU 15-445 · Database Internals |
| 5 | Load balancer | Hussein Nasser L4/L7 · Consistent hashing |
| 6 | Web crawler | robots.txt RFC · politeness delay literature |
| 7 | Chat service | WebSocket RFC 6455 · *The Tail at Scale* |
| 8 | News feed | Fan-out-on-read/write papers · Twitter architecture talks |
| 9 | Search engine | Inverted index papers (SPIMI) · CMU 15-445 |
| 10 | Distributed log | **MIT 6.5840 Raft lab** · Kreps · Kleppmann *The Log* |
| 11 | KV store | **MIT 6.5840 fault-tolerant KV lab** · Dynamo paper · consistent hashing |
| 12 | Global rate limiter | Two-tier / edge rate limiting · multi-region consistency |

---

## 8. Gaps this research found in my own work

Two things surfaced while researching — both in **project 2 (cache)**.

### 8.1 Single-flight is per-process, not global  ⚠️

The [cache stampede article](https://en.wikipedia.org/wiki/Cache_stampede) puts it precisely:

> With N app instances an in-process singleflight reduces the herd from 10,000
> to N — which for N in the tens is usually well within origin capacity.

Project 2 teaches "1 database query", and that is correct **within one
process**. With 10 API servers the same stampede produces **up to 10
concurrent loads** — one per server. The test cannot see it, because it only
runs one repository instance.

> [!warning] This is not a bug in project 2, it is a *boundary* the project
> was meant to expose. But it needs to be stated explicitly rather than
> discovered in production.
>
> Fixes: coalesce at the shared tier (Redis lock / `SETNX` + TTL), or use
> X-Fetch (below), or accept N and size the database for N.

### 8.2 TTL jitter is the weaker fix — X-Fetch is better

Jitter spreads expirations across the key *population*. **X-Fetch** spreads
them per *key*: it decouples logical expiry from physical expiry and lets
each request probabilistically volunteer to refresh **before** the key expires.

```
if !value or time() - delta * beta * ln(rand()) >= expiry then
    recompute_value()
```

`delta` = how long the last recomputation took, `beta` = aggressiveness.
The refresh probability rises smoothly as expiry approaches, so refreshes
spread out per key with **no lock**, and therefore no lock-contention failure
mode.

Roughly 15 lines, and it slots straight into the repository as a fourth
defence alongside single-flight, negative caching and jitter.

---

## 9. If you only do three things this month

1. **Read DDIA chapters 5, 6, 7** (~3 hours) — reframes everything being built.
2. **Watch Hussein Nasser's Consistent Hashing series** (~1 hour) — needed for project 11.
3. **Read the AWS backoff-and-jitter post** (~20 min) — needed for project 3, which is next.

---

## 9. What this research changed in the projects

Two findings from this research turned into real code, not just notes.

### 8.1 Single-flight is per-process → project 12

The [cache stampede article](https://en.wikipedia.org/wiki/Cache_stampede) puts it
precisely:

> With N app instances an in-process singleflight reduces the herd from 10,000
> to N — which for N in the tens is usually well within origin capacity.

Project 2 teaches "1 database query", and that is correct **within one
process**. With 10 API servers the same stampede produces **up to 10
concurrent loads** — one per server. The test cannot see it, because it only
runs one repository instance.

This is not a bug in project 2. It is a *boundary* the project was meant to
expose. But it needs stating explicitly rather than discovering in production.

**Where it got resolved:** project 12 makes the local/global split explicit,
and the sizing rule there — *the local limit is a fraction of the global
limit, divided by the expected instance count* — is precisely the rule that
accounts for N local tiers.

### 8.2 TTL jitter is the weaker fix → XFetch

Jitter spreads expirations across the key *population*. **X-Fetch** spreads
them per *key*: it decouples logical expiry from physical expiry and lets
each request probabilistically volunteer to refresh **before** the key expires.

```
if !value or time() - delta * beta * ln(rand()) >= expiry then
    recompute_value()
```

`delta` = how long the last recomputation took, `beta` = aggressiveness.
The refresh probability rises smoothly as expiry approaches, so refreshes
spread out per key with **no lock**, and therefore no lock-contention failure
mode.

Roughly 15 lines, and it slots straight into the repository as a fourth
defence alongside single-flight, negative caching and jitter.

**Still open** — see the questions below.

---

## Open questions worth chasing

1. Does the per-process single-flight gap deserve a *distributed* coalescing
   implementation, or is accepting N loads (and sizing the DB for N) the honest
   answer? Depends on N and on the herd size.
2. Is XFetch strictly better than jitter, or are they complementary — jitter
   for the population, XFetch for the individual key?
3. What is the right negative TTL? Too short and penetration returns; too long
   and a newly-created item stays invisible.
4. Should the two-tier rate limiter's local tier ever be allowed to *loosen*
   the effective limit — for example, to absorb a burst the global tier would
   otherwise reject? Project 12 says no. Is that the right call for every
   workload?

Related: [[System-Design-Home]] · [[Projects]]
