---
layout: project
title: "ESB/EAI 시스템 개발(eCross)"
topic: project
tags: [backend, react, microservices]
sticky: true
language: ko
show: true
image: assets/images/project/ESB/esb.png
main: true
---

## 📋 프로젝트 개요
중앙 집중식 소프트웨어 컴포넌트가 다양한 애플리케이션 간의 메시지 기반 통합을 수행하는 기업용 ESB/EAI 플랫폼입니다. 엔터프라이즈급 메시지 통합 솔루션으로서 실시간 데이터 통합, 모니터링, 로깅을 통해 비즈니스 프로세스를 안정적으로 지원합니다.

| 항목 | 내용 |
|------|------|
| **기간** | 2023.09 - 현재 (약 6개월 이상) |
| **팀 규모** | 8명 |
| **직책** | 개발팀 시니어 개발자 |

---

## 🎯 프로젝트 배경
기업의 다양한 레거시 시스템들을 연결하고 실시간 메시지 기반 통합이 필요한 상황에서, 안정적이고 확장 가능한 ESB 플랫폼을 개발하여 시스템 간의 느슨한 결합(Loose Coupling)을 구현하고 운영 효율성을 높이는 것을 목표로 함.

---

## 💼 담당 역할

### Front-end 개발
- **React 기반 모니터링 대시보드** 구현
  - 실시간 인터페이스 상태 모니터링 화면
  - 메시지 흐름 시각화 및 분석 화면

## 🔧 주요 기능 및 구현

- **메시지 기반 시스템 통합**: 다양한 채널(HTTP, JDBC, JMS 등)을 통한 애플리케이션 간 메시지 교환
- **실시간 모니터링 대시보드**: 인터페이스 상태, 처리량, 응답시간 등 주요 지표 시각화
- **고급 로깅 시스템**: 인터페이스별 상세 로그 관리 및 분석 기능
- **메시지 분할 전송**: 대용량 메시지를 안전하게 분할하여 전송
- **트랜잭션 관리**: Saga Pattern을 통한 분산 트랜잭션 처리
  - [→ Saga Pattern 상세 구현 코드 및 성능 분석](/projects/additional/2025-03-17-ESB-EAI-eCross/saga-pattern-implementation/)

---
- 채널 라이브러리 패치 기능 구현
- 마이크로서비스 간 통신 로직 개발
- REST API 및 메시지 큐 연동

### 핵심 기능 구현
- 로그 관리 시스템 전체 구축
- 인터페이스 시뮬레이션 엔진 개발
- 메시지 분할 전송 기능 구현
- 실시간 메시지 모니터링 기능

### 제품 관리
- 제품 LMS 기술 지원 및 문서화

---

## 사용 기술
**Backend:** Java, Spring Boot, Spring WebFlux, JPA, Quartz, JWT  
**Frontend:** React, JavaScript  
**Database:** Oracle, JPA  
**Infrastructure:** Docker, AWS, VM ware, Jenkins  
**Tools:** IntelliJ, Eclipse, VS Code, GitHub Copilot, Notion, GitLab, DBeaver  
**Architecture:** Saga Pattern, Microservices

---

## 주요 성과
1. **SP 인증 및 GS 인증 취득**
   - 제품의 신뢰성 및 보안 수준 검증 완료

2. ⭐ 프로젝트 특징

- **엔터프라이즈급 안정성**: SP/GS 인증을 통한 신뢰성 검증
- **실시간 메시지 추적**: 메시지 흐름의 시작부터 종료까지 완전 추적
- **멀티 채널 지원**: 다양한 프로토콜 및 시스템 통합 (HTTP, JDBC, JMS, File 등)
- **높은 확장성**: 마이크로서비스 기반 아키텍처로 수평 확장 용이
- **운영 효율화**: 직관적인 모니터링 대시보드

---

## 📝 추가 가능한 섹션

다음 항목들을 필요에 따라 추가해주세요:

- **프로젝트 아키텍처**: 시스템 다이어그램, 컴포넌트 구조도
- **성능 지표**: 처리량(Throughput), 응답시간(Latency), 안정성(Uptime)
- **배운 점**: 분산 시스템 설계, 대규모 팀 협업 경험
- **향후 개선 사항**: 계획 중인 기능, 성능 최적화 계획
- **팀 기여도**: 개인의 구체적인 기여 부분
- **고객 피드백**: 사용자 만족도, 성과 평가효율화**
   - Saga Pattern 도입으로 인터페이스 통신의 트랜잭션 관리 개발 **30% 간소화**
   - 복잡한 분산 트랜잭션 처리 단순화

---

## 프로젝트 특징
- 엔터프라이즈급 메시지 통합 플랫폼
- 실시간 메시지 모니터링 및 추적 기능
- 다양한 채널 통합 지원
- 높은 안정성과 확장성
