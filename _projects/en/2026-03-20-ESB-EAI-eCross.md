---
layout: project
title: "EAI/ESB Integration Solution Development (eCross) - Development"
topic: project
tags: [backend, react, MSA]
sticky: true
language: en
show: true
image: assets/images/project/ESB/esb.png
main: false
---

## Project Overview
An integration solution as ESB (Enterprise Service Bus) middleware software that connects and integrates services, applications, and resources within business environments. It enables easy integration/connection of distributed service components and supports reliable message communication.


| Item | Details |
|------|------|
| **Period** | 2023.09 ~ Present |
| **Role** | Feature design, backend-focused full-stack development, main product QA owner, cloud management |

<br>

## Responsibilities

### Core Backend and Common Feature Development
- Developed message-based interface processing logic
- Designed and implemented ETL feature prototypes
- Improved WebFlux-based asynchronous processing architecture
- Developed large-message segmented transfer functionality
- Developed interface communication simulation
- Implemented log management features
- Developed certificate encryption communication features
- Developed scheduling for interface communication
- Developed system scheduling
- Responded to monitoring troubleshooting
- Responded to client maintenance requests

### Frontend Development
- Developed React-based UI (during first year of project participation)
- Responded to frontend errors, changes, and CSS updates

### Operations and Quality Response
- Served as project QA owner within the center
- Supported SP/GS certification response
- Managed AWS cloud
- Handled cloud compatibility response

---

## Key Achievements

- **Improved MDC-Based Logging Structure**
  - Consolidated multiple appenders previously split by interface into an MDC-based structure.
  - Simplified `logback.xml` configuration by **over 90%**, improving maintainability.
  - [-> MDC-based logging structure example](/projects/additional/2025-03-17-ESB-EAI-eCross/mdc_en/)

- **Applied Saga Pattern**
  - Made core contributions to applying the Saga pattern in multi-server communication flows, improving distributed transaction efficiency.
  - Achieved **about 50% improvement in transaction management efficiency**.
  - [-> Saga processing structure and example](/projects/additional/2025-03-17-ESB-EAI-eCross/saga_en/)

- **Stabilized Large Message Processing**
  - Implemented WebFlux `expand`-based message segmentation to resolve OOM errors caused by message accumulation.
  - Reduced OOM errors during large-interface split processing by **100%**.
  - [-> OOM improvement example](/projects/additional/2025-03-17-ESB-EAI-eCross/oom_en/)

- **Verified ETL Prototype Performance**
  - Implemented an ETL prototype using Spring Boot based on customer requirements.
  - Verified that with 3 threads and 8GB heap memory, processing 10 million records was **about 6-8% faster than commercial solutions**.
  - [-> ETL prototype summary example](/projects/additional/2025-03-17-ESB-EAI-eCross/etl_en/)

- **Automated Release Build Testing**
  - Implemented automatic validation between DB metadata and current DB schema during releases.
  - Fully automated manual DB schema checks (100%), eliminating human error and improving verification reliability.
  - [-> DB metadata validation example](/projects/additional/2025-03-17-ESB-EAI-eCross/db_en/)

- **Quality and Certification Response**
  - Led cloud compatibility certification response - SCP (Samsung Cloud Platform, including cloud setup team training)
  - Participated in SP/GS certification acquisition, contributing to product standardization and reliability
  - Collaborated with cloud team to support quality management systems including release deployment framework and SBOM

---

## Tech Stack
  - **Backend:** Java, Spring Boot, Spring WebFlux, JPA, Kafka, Spring Batch, Mybatis  
  - **Frontend:** React  
  - **Database:** Multiple DBMS (Oracle, H2, Tibero, MSsql, etc.)  
  - **Infrastructure:** AWS, Docker  
  - **DevOps:** Jenkins  
  - **Architecture**: MSA

---

## Key Screens
>> **Statistics**  
![stati](/assets/images/project/ESB/stati.png)  
<br>
>> **Transaction Tracking**  
![transac](/assets/images/project/ESB/transac.png)  
<br>
>> **Interface Management**  
![interface](/assets/images/project/ESB/interface.png)  
<br>
>> **Log Management**  
![log](/assets/images/project/ESB/log.png)  
