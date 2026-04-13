---
layout: project
title: "EAI/ESB 연계 솔루션 개발 (eCross) - 개발"
topic: project
tags: [backend, react, MSA]
sticky: true
language: ko
show: true
image: assets/images/project/ESB/esb.png
main: true
---

## 프로젝트 개요
비즈니스 내에서 서비스, 애플리케이션, 자원을 연결하고 통합하는 미들웨어, ESB(Enterprise Service Bus) S/W로써 이를 통해 분산된 서비스 컴포넌트를 쉽게 통합·연동할 수 있어 신뢰성 있는 메시지 통신을 가능하게 하는 연계 솔루션입니다.


| 항목 | 내용 |
|------|------|
| **기간** | 2023.09 ~ 현재 |
| **역할** | 기능 설계, 백엔드 중심 풀스택 개발, 제품 QA 메인 담당, 클라우드 관리 |

<br>

## 담당 역할

### 주요 백엔드 및 공통 기능 개발
- 메시지 기반 인터페이스 처리 로직 개발
- ETL 기능 프로토타입 설계 및 구현
- WebFlux 기반 비동기 처리 구조 개선
- 대용량 메시지 분할 전송 기능 개발
- 인터페이스 통신의 시뮬레이션 개발
- Log 관리 기능 구현
- 인증서 암호화 통신 기능 개발
- 인터페이스 통신의 스케줄 개발
- 시스템 스케줄 개발
- 모니터링 트러블 슈팅 대응
- 고객사 유지보수 대응

### 프론트엔드 개발
- React 기반 UI 개발(프로젝트 투입 초기 1년간)
- 프론트 에러, 변경, CSS 등의 대응

### 운영 및 품질 대응
- 센터 내 프로젝트 QA 담당
- SP/GS 인증 대응
- AWS 클라우드 관리
- 클라우드 호완성 대응

---

## 주요 성과

- **MDC 기반 로깅 구조 개선**
  - 인터페이스별로 분산되어 있던 다수의 Appender를 MDC 기반으로 통합
  - `logback.xml` 설정을 **90% 이상 단순화**하여 유지보수성을 높였습니다.
  - [→ MDC 기반 로깅 구조 정리 예시](/projects/additional/2025-03-17-ESB-EAI-eCross/mdc/)

- **Saga 패턴 적용**
  - 다수의 서버의 통신 과정에 Saga 패턴을 적용에 핵심 부분 기여로 분산 트랜잭션 관리 효율 개선.
  - **트랜잭션 관리 효율 약 50% 개선** 성과를 만들었습니다.
  - [→ Saga 처리 구조 및 예시](/projects/additional/2025-03-17-ESB-EAI-eCross/saga/)

- **대용량 메시지 처리 안정화**
  - WebFlux `expand` 기반 메시지 분할 기능을 구현으로 통신의 메시지 누적으로 인한 에러(OOM) 해결
  - 대용량 인터페이스 분할 처리 중 발생하던 **OOM 오류를 100% 감소**시켰습니다.
  - [→ OOM 개선 내용 예시](/projects/additional/2025-03-17-ESB-EAI-eCross/oom/)

- **ETL 프로토타입 성능 검증**
  - 고객 요청 기반 Spring boot를 이용한 ETL 기능을 프로토타입 구현.
  - **3개 스레드, 8GB 힙 메모리 환경에서 1천만 건 데이터를 처리에 상용 솔루션 대비 약 6~8% 빠른 성능**을 확인했습니다.
  - [→ ETL 프로토타입 정리 예시](/projects/additional/2025-03-17-ESB-EAI-eCross/etl/)

- **릴리즈 빌드 테스트 자동화**
  - 프로젝트 릴리즈 시 DB Meta Data와 현행 DB 스키마를 자동 검증하는 기능을 구현.
  - 수작업으로 진행하던 DB 스키마 검증을 100% 자동화하여 휴먼 에러를 제거하고 검증 신뢰도를 향상시켰습니다.
  - [→ DB Mata Data 검증 예시](/projects/additional/2025-03-17-ESB-EAI-eCross/db/)

- **품질 및 인증 대응**
  - 클라우드 호완성 인증 주도 - SCP(Samgsung Cloud Platform, 클라우드 설정 팀원 교육)
  - SP/GS 인증 획득에 참여해 제품의 표준화와 신뢰도 향상에 기여
  - 클라우드 팀과 협력하여 릴리스 배포 체계 및 SBOM 등 품질 관리에 관한 체계 지원

---

## 사용 기술
  - **Backend:** Java, Spring Boot, Spring WebFlux, JPA, Kafka, Spring Batch, Mybatis  
  - **Frontend:** React  
  - **Database:** 다양한 DBMS(Oracle, H2, Tibero, MSsql 등)  
  - **Infrastructure:** AWS, Docker  
  - **DevOps:** Jenkins  
  - **Architecture**: MSA

---

## 주요 화면
>> **통계**  
![stati](/assets/images/project/ESB/stati.png)  
<br>
>> **트랜잭션 추적**  
![transac](/assets/images/project/ESB/transac.png)  
<br>
>> **인터페이스 관리**  
![interface](/assets/images/project/ESB/interface.png)  
<br>
>> **로그 관리**  
![log](/assets/images/project/ESB/log.png)  
