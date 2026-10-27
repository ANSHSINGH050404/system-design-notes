---
tags: [system-design, food-delivery, design]
created: 2026-10-27
status: draft
type: design
---

# 🍔 Food Delivery System Design

> [!info]
> **Goal:** Design a scalable food delivery platform similar to Zomato, Swiggy, or Uber Eats.

Related: [[System-Design-Home]] · [[Learning-Resources]]

---

## 📌 Requirements

### ✅ Functional Requirements

- User Registration & Login
- Search Restaurants
- Search Food Items
- View Menu
- Add Item to Cart
- Checkout
- Online Payment
- Place Order
- Live Order Tracking
- Rider Allocation
- Inventory Management
- Restaurant Dashboard
- Notifications
- Customer Support
- Ratings & Reviews

### 🚀 Non-Functional Requirements

- High Availability
- Low Latency
- Horizontal Scalability
- Fault Tolerance
- Strong Consistency for Payments
- Eventual Consistency for Tracking
- High Throughput
- Secure Authentication
- Monitoring & Logging

---

## 👤 User Flow

```text
User
    │
    ▼
Register/Login
    │
    ▼
Search Restaurant
    │
    ▼
Browse Menu
    │
    ▼
Add to Cart
    │
    ▼
Checkout
    │
    ▼
Payment
    │
    ▼
Place Order
    │
    ▼
Restaurant Accepts Order
    │
    ▼
Assign Rider
    │
    ▼
Pickup
    │
    ▼
Live Tracking
    │
    ▼
Delivered
```

---

## 🏗️ Core Services

> [!note] These are planned notes
> The links below point to service notes that do not exist yet. In Obsidian
> that is deliberate — a wikilink to a missing note is a placeholder, and
> clicking it creates the note.

- [[API Gateway]]
- [[Authentication Service]]
- [[User Service]]
- [[Restaurant Service]]
- [[Menu Service]]
- [[Search Service]]
- [[Cart Service]]
- [[Inventory Service]]
- [[Order Service]]
- [[Payment Service]]
- [[Delivery Service]]
- [[Notification Service]]
- [[Support Service]]

---

## 🌐 APIs

### Authentication

```http
POST /register
POST /login
POST /logout
```

### Restaurant

```http
GET /restaurants
GET /restaurants/{id}
GET /restaurants/{id}/menu
```

### Cart

```http
POST /cart
GET /cart
DELETE /cart/{itemId}
```

### Orders

```http
GET /orders/{id}
GET /orders/history
POST /orders
```

### Tracking

```http
GET /orders/{id}/tracking
```

---

## 🗄️ Database

- Users
- Restaurants
- Menu Items
- Inventory
- Cart
- Orders
- Payments
- Riders

---

## 📈 Scaling

- Redis Cache
- CDN
- Load Balancer
- Read Replicas
- Kafka/RabbitMQ
- Database Sharding
- Auto Scaling

---

## 📊 Monitoring

- Metrics
- Logs
- Distributed Tracing
- Alerts
- Health Checks

---

## 📌 Next Steps

- [ ] Capacity Estimation
- [ ] High-Level Design (HLD)
- [ ] Low-Level Design (LLD) → see `ATLAS/LLD`
- [ ] Database Schema
- [x] Excalidraw Architecture
- [ ] Failure Scenarios
- [ ] Trade-offs
- [ ] Interview Questions

---

## 🖼️ Architecture

[architecture drawing](Excalidraw/food-delivery.excalidraw.md)
