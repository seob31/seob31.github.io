---
layout: project
title: "미디어 파일 포렌식 서비스 개발 (Saforus)"
topic: project
tags: [backend, devops]
sticky: false
language: ko
show: true
image: assets/images/project/forensic/saforus.jpg
main: true
---

## 프로젝트 개요
미디어 파일의 포렌식 워터마그 적용 및 유출 추적, DRM 적용을 지원하는 포렌식 서비스 개발 프로젝트입니다. 프로젝트 설계부터 백엔드 개발, AWS 기반 서버 운영, 해외개발자 협업 대응까지 함께 맡으며 제품 구조와 운영 안정성을 동시에 다뤘습니다.

| 항목 | 내용 |
|------|------|
| **기간** | 2023.01 ~ 2023.05 |
| **역할** | 프로젝트 설계, 백엔드 개발, AWS 서버 운영, SRE |

<br>

## 담당 역할

### 시스템 설계 및 백엔드 개발
- 시스템 설계
- 아키텍쳐링
- 오케스트레이션 모듈 개발 (작업 흐름 제어 모듈)
- 컴포저 모듈 개발 (워터마크가 적용된 미디어 파일 조합 모듈)
- 포렌식 모듈 개발 (포렌식 워터마크 적용 모듈)
- 미디어 파일 검증 모듈 개발
- FFmpeg의 명령어를 이용한 포렌식 기능 강화
- 각 서버의 Queue 상태 조회 기능

### 인프라 및 운영
- AWS 환경의 인프라 구축(EC2, ALB, EFS, S3, CDN 등)
- AWS의 GPU 서버 별도 관리
- git -> Jenkins -> Docker 기반 배포 환경 관리

### 기타
- 기획, 디자인 팀과의 커뮤니케이션
- 프로젝트에 속한 해외 개발자 서포트 (Front-end 2, Back-end 1)  
  -> 기술 지원, 프로젝트 관련 내용 및 지시사항 전달

---

## 주요 구현 및 성과

- **핵심 모듈 단독 개발**
  - SRE 개발, 오케스트레이션·컴포저·포렌식·검증 모듈을 단독으로 개발.
  - 전체 프로젝트 기준으로 **45% 이상 기여**했습니다.

- **포렌식 정확도 개선**
  - Resolution, Frame, GOP 등을 이용한 포렌식 코어 라이브러리의 FFmpeg 가이드라인 커맨드를 최적화.
  - 미디어 유출 사용자 추적 정확도를 **약 10% 향상**시켰습니다.

- **아키텍처 재구성과 데모 리딩**
  - 개발 중 시스템 아키텍처를 재구성하고 팀원 업무 배분함으로 Universal Studios(US) 대상 긴급 데모를 성공적으로 주도.

- **Scale Out에 필요한 수치**
  - Working server의 작업량을 조회하고, Queue 기반으로 Scale-out 및 Scale-in 판단 지표를 산출하는 기능 개발.  
    -> 개발이유 : AWS에서 제공하는 Scale-in & out의 수치와 프로젝트와 부적합.
  
---

## 사용 기술
 - **Backend:** Java, MyBatis, Spring boot, JWT
 - **Database:** PostgreSQL, Redis
 - **Infra/DevOps:** AWS (EC2, S3, VPC, ALB), Docker, Jenkins  
 - **Media:** FFmpeg  
 - **Collaboration:** GitLab, Jira, Confluence
 - **Architecture**: MSA

---

## 주요 화면
>> **업로드**  
![upload](/assets/images/project/forensic/upload.png)   
<br>
>> **검출**  
![extract](/assets/images/project/forensic/extract.png)    
