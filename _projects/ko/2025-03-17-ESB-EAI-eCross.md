---
layout: project
title: "EAI/ESB 연계 솔루션 개발 (eCross)"
topic: project
tags: [backend, react, microservices]
sticky: true
language: ko
show: true
image: assets/images/project/ESB/esb.png
main: true
---

## 프로젝트 개요
다양한 시스템과 애플리케이션을 메시지 기반으로 연결하는 EAI/ESB 연계 솔루션 개발 프로젝트입니다.  
백엔드 중심의 풀스택 개발을 담당하며, 인터페이스 처리 구조 개선, 운영 편의성 향상, 품질 인증 대응까지 함께 수행했습니다.

| 항목 | 내용 |
|------|------|
| **기간** | 2023.09 ~ 현재 |
| **팀 규모** | 8명 |
| **역할** | 백엔드 중심 풀스택 개발, 제품 QA, 클라우드 관리 |

---

## 담당 역할

### 백엔드 및 공통 기능 개발
- 메시지 기반 인터페이스 처리 로직 개발
- ETL 기능 프로토타입 설계 및 구현
- WebFlux 기반 비동기 처리 구조 개선
- 대용량 메시지 분할 전송 기능 구현

### 프론트엔드 개발
- React 기반 모니터링 대시보드 구현
- 인터페이스 상태 및 처리 현황 시각화
- 로그 및 처리 결과 조회 화면 개발

### 운영 및 품질 대응
- 프로젝트 관리 및 제품 품질 문서 체계화
- SP/GS 인증 대응 및 품질 이슈 개선 참여
- AWS/SCP 기반 클라우드 운영 환경 관리

---

## 주요 구현 및 성과

- **MDC 기반 로깅 구조 개선**
  - 인터페이스별로 분산되어 있던 다수의 Appender를 MDC 기반으로 통합
  - `logback.xml` 설정을 **90% 이상 단순화**하여 유지보수성을 높였습니다.
  - [→ MDC 기반 로깅 구조 정리](/projects/additional/2025-03-17-ESB-EAI-eCross/mdc/)
- **Saga 패턴 적용**
  - 인터페이스 통신 과정에 Saga 패턴을 적용해 분산 트랜잭션 관리 효율을 개선했습니다.
  - 지원서 기준으로 **트랜잭션 관리 효율 약 50% 개선** 성과를 만들었습니다.
  - [→ Saga 처리 구조 및 예시](/projects/additional/2025-03-17-ESB-EAI-eCross/saga/)

- **대용량 메시지 처리 안정화**
  - WebFlux `expand` 기반 메시지 분할 기능을 구현해 힙 메모리 사용량을 크게 줄였습니다.
  - 인터페이스 처리 중 발생하던 **OOM 오류를 90% 감소**시켰습니다.
  - [→ OOM 개선 내용 보기](/projects/additional/2025-03-17-ESB-EAI-eCross/oom/)

- **ETL 프로토타입 성능 검증**
  - 고객 요청 기반 ETL 기능을 프로토타입으로 구현했습니다.
  - **3개 스레드, 8GB 힙 메모리 환경에서 1천만 건 데이터를 처리**했고, 상용 솔루션 대비 **약 10% 빠른 성능**을 확인했습니다.
  - [→ ETL 프로토타입 정리](/projects/additional/2025-03-17-ESB-EAI-eCross/etl/)

- **품질 및 인증 대응**
  - 프로젝트 관리와 제품 품질 관련 문서를 체계적으로 수립하고 개선했습니다.
  - SP/GS 인증 획득에 참여해 제품의 표준화와 신뢰도 향상에 기여했습니다.

---

## 사용 기술
**Backend:** Java, Spring Boot, Spring WebFlux, JPA, Spring Batch, Kafka, Quartz, JWT  
**Frontend:** React, JavaScript  
**Database:** Oracle, 다양한 DBMS, JPA  
**Infrastructure:** Docker, VMware, AWS, Jenkins  
**Tools:** IntelliJ, Eclipse, VS Code, GitLab, Notion, Redmine, DBeaver, Scouter  
**Architecture:** Message-driven Integration, Saga Pattern, Microservices

---

## 프로젝트 특징
- 백엔드 구조 개선과 운영 효율화를 함께 수행한 제품형 프로젝트
- 인터페이스 처리 안정성, 메모리 사용량, 운영 로그 구조를 동시에 개선
- 품질 인증, 운영 문서화, 클라우드 환경 관리까지 폭넓게 담당
