---
layout: project
title: "Gangneung Community App (Gangneung in My Hand) - Development"
topic: project
tags: [backend, mydata, mobile]
sticky: false
language: en
show: true
image: assets/images/project/gangneung/main.jpg
main: true
---

## Project Overview
As part of Gangneung's Smart City Challenge initiative, this integrated civic-life app issues mobile library cards and citizen IDs for convenient use, and through Government24 integration provides MyData-based personalized services, welfare/administration, and travel/tourism information for both residents and visitors.


| Item | Details |
|------|------|
| **Period** | 2021.08 ~ 2022.01 |
| **Role** | Project design, backend development, SRE, overseas developer support |
| **Status** | Completed and stabilized phase 1 (design, core features, architecture), then transitioned due to assignment to another project design |

<br>

## Responsibilities

### Backend and Integration Development
- System design
- Developed public MyData features through Government24 API integration
- Developed personalized welfare features through Government24 API integration
- Developed Gangneung citizen verification through national administrative network integration
- Developed mobile-to-server data communication using RSA encryption
- Developed DB backup scripts

### Operations and Deployment
- Docker and Shell-based deployment automation
- Built and operated both test servers and Gangneung production servers
- Supported overseas developers (mobile developers)

---

## Key Achievements

- **Implemented MyData Features Based on Public API Integration**
  - Developed key features (MyData and personalized welfare) by linking the national administrative network and Government24.  
    -> The major challenge was identifying the responsible department during incident handling and inquiry processes.

- **Led the Full Phase-1 Development Cycle**
  - Played a core role across design, development, and infrastructure setup, contributing **over 35%** to overall development.

---

## Tech Stack
**Backend:** Java, MyBatis, Spring boot, SOAP (government API integration)  
**Database:** PostgreSQL  
**Infrastructure:** Shell automation (Shell scripting) 

<br>
---

## Key Screens
>> **Main**  
![main](/assets/images/project/gangneung/main.png)  
<br>
>> **MyData Certificate Issuance**  
![mydata](/assets/images/project/gangneung/mydata.png)  
<br>
>> **MyData Wallet**  
![mydata2](/assets/images/project/gangneung/mydata2.png)  
<br>
