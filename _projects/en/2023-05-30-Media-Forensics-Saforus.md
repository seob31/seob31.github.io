---
layout: project
title: "Media File Forensics Service Development (Saforus) - Development"
topic: project
tags: [backend, devops, MSA]
sticky: false
language: en
show: true
image: assets/images/project/forensic/saforus.jpg
main: true
---

## Project Overview
A forensic service development project supporting forensic watermark application, leak tracking, and DRM for media files. I covered project design, backend development, AWS-based server operations, and collaboration support for overseas developers, handling both product structure and operational stability.

| Item | Details |
|------|------|
| **Period** | 2023.01 ~ 2023.05 |
| **Role** | Project design, backend development, AWS server operations, SRE |

<br>

## Responsibilities

### System Design and Backend Development
- System design (MSA)
- Architecture design
- Developed orchestration module (workflow control module)
- Developed composer module (module combining watermarked media files)
- Developed forensic module (forensic watermark application module)
- Developed media file validation module
- Enhanced forensic functions using FFmpeg commands
- Implemented queue status inquiry across servers

### Infrastructure and Operations
- Built AWS infrastructure (EC2, ALB, EFS, S3, CDN, etc.)
- Separately managed AWS GPU servers
- Managed CI/CD deployment pipeline (git -> Jenkins -> Docker)

### Other
- Communicated with planning and design teams
- Supported overseas developers in the project (Frontend 2, Backend 1)  
  -> Technical support, project communication, and instruction delivery

---

## Key Achievements

- **Solo Development of Core Modules**
  - Independently developed SRE-related components and orchestration, composer, forensic, and validation modules.
  - Contributed **over 45%** to the overall project.

- **Improved Forensic Accuracy**
  - Optimized FFmpeg guideline commands for the forensic core library using resolution, frame, and GOP factors.
  - Improved leak-user tracking accuracy by **about 10%**.

- **Architecture Restructuring and Demo Leadership**
  - Reorganized system architecture during development and redistributed team tasks, successfully leading an urgent demo for Universal Studios (US).

- **Scale-out Decision Metrics**
  - Developed a feature that checks working-server load and derives queue-based scale-out/scale-in decision indicators.  
    -> Reason: AWS native scale-in/out indicators were not suitable for the project.
  
---

## Tech Stack
 - **Backend:** Java, MyBatis, Spring boot, JWT
 - **Database:** PostgreSQL, Redis
 - **Infra/DevOps:** AWS (EC2, S3, VPC, ALB), Docker, Jenkins  
 - **Media:** FFmpeg  
 - **Collaboration:** GitLab, Jira, Confluence
 - **Architecture**: MSA

---

## Key Screens
>> **Upload**  
![upload](/assets/images/project/forensic/upload.png)   
<br>
>> **Extract**  
![extract](/assets/images/project/forensic/extract.png)    
