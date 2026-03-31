---
layout: project
title: "Blockchain-Based Learning History and Certificate Verification Service (Molida) - Development"
topic: project
tags: [fullstack]
sticky: false
language: en
show: true
image: assets/images/project/molida/logo.png
main: true
---

## Project Overview
A blockchain-based service project that manages learning history, award records, and certificate data, and supports not only certificate issuance but also certificate production for institutions (universities, local governments, public enterprises, etc.).

| Item | Details |
|------|------|
| **Period** | 2019.11 ~ 2022.01 |
| **Role** | System design, backend development, frontend development, server operations |

<br>

## Responsibilities

## Design
- System design  
- Screen design  

### Backend Development
- Developed core features for blockchain-based learning history management
- Developed auto-registration features for blockchain-based learning history management
- Developed blockchain-linked certificate verification and certificate generation features
- Developed automated isolated-data storage using MariaDB Event Scheduler and Stored Procedures
- Developed log management for MariaDB Stored Procedure-based isolated-data storage automation
- Developed backend for direct certificate authoring features
- Responded to security vulnerabilities
- Handled client requirements and maintenance
- Integrated mobile identity verification
- Developed backend features for core website capabilities (boards, registration, etc.)  
  -> User, institution, and operator pages
- Responded to production server troubleshooting
- Responded to periodic maintenance activities

### Frontend Development
- Developed frontend for direct certificate authoring features
- Developed frontend for core website capabilities (boards, popups, registration, etc.)  
  -> User, institution, and operator pages
- Implemented frontend development and updates through publishing tasks

## Server Operations
- Managed IDC server operations
- Managed deployment automation based on Docker and Shell
- Responded to server security requirements for ISMS-P certification

---

## Key Achievements

- **Internalized Certificate Generation Feature**  
  - Directly designed the certificate generation function and developed both frontend (JavaScript) and backend (Java) in-house  
    -> Removed external library dependencies and **saved about KRW 20 million in development cost**  
  - [-> Partial example of certificate generation feature](/projects/additional/2022-01-30-Learning-History-Molida/cert_en/)

- **ISMS-P Acquisition**  
  - Built an automated data isolation/storage system using MariaDB Stored Procedures and Event Scheduler  
  - Implemented procedure-level logging, strengthened physical server security, and handled security vulnerabilities  
    -> Contributed **over 20%** to obtaining ISMS-P certification

---

## Tech Stack
**Backend:** Java, MyBatis, Spring framework, Maven, Shell Script  
**Frontend:** HTML, JavaScript, jQuery, Ajax, JSP  
**Database:** MariaDB
**Infrastructure:** Docker, HAProxy  
**Monitoring:** Prometheus, Grafana   
**DevOps / Tools:** Portainer 


## Key Screens
>> **Learning History List**  
![list](/assets/images/project/molida/list.png)  
<br>
>> **Learning History Detail**  
![detail](/assets/images/project/molida/detail.png)  
<br>
>> **Watermark Screen**  
![watermark](/assets/images/project/molida/watermark.png)  
<br>
>> **Certificate Issuance List Screen**  
![certList](/assets/images/project/molida/certList.png)  
<br>
>> **Certificate Issuance Screen**  
![cert](/assets/images/project/molida/cert.png)  
<br>
>> **Institution Certificate Request Screen**  
![request](/assets/images/project/molida/request.png)  
