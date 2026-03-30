---
layout: project
title: "Coding Test Service Development - Development"
topic: project
tags: [backend, SRE]
sticky: false
language: en
show: true
image: assets/images/project/coding/coding.png
main: true
---

## Project Overview
A coding test service that supports 12 programming languages. It measures code execution CPU time, elapsed wall time, and peak memory usage during execution, then provides these metrics to users.


| Item | Details |
|------|------|
| **Period** | 2022.02 ~ 2022.05 |
| **Role** | System design, backend development, SRE |
| **Status** | Development stopped after phase 1 due to marketability concerns before launch |

<br>

## Responsibilities

### Backend Development
- System design
- API server development
- Developed execution server using Isolate Sandbox
  - [-> Isolate Sandbox example](/projects/additional/2022-05-31-Coding-Test-System/isolate_en/)

### Infrastructure and Operations
- Designed and developed Docker-based on-premise deployment architecture
- Managed IDC server operations and deployment
- Installed compilers for each language

---

## Key Achievements

- **Developed Core Engine Supporting 12 Languages and Contributed Over 40%**
  - Built an execution environment supporting **12 language versions** using Isolate Sandbox.   
    -> Java, C, C++, C#, Scala, Swift, Python2, Python3, Go, Kotlin, Javascript, R  
  - Personally handled design, architecture, core development, deployment, and server operations.

- **Reduced On-Premise Installation Time**
  - Built a Docker-based on-premise solution that simplified installation and reduced setup time by **over 25%**.

---

## Tech Stack
**Backend:** Java, JWT, Spring boot, Mybatis, Isolate Sandbox, Websocket  
**Database:** MariaDB    
**Infra & Ops:** Docker-based deployment, Shell automation  
