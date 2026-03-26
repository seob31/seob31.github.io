---
layout: project
title: "코딩 테스트 서비스 개발 - 개발"
topic: project
tags: [backend, SRE]
sticky: false
language: ko
show: true
image: assets/images/project/coding/coding.png
main: true
---

## 프로젝트 개요
12개의 개발 언어를 지원하는 코딩 테스트 서비스입니다. 코드문제 및 코드 실행의 CPU 시간, 실제 경과 시간, 실행 중 최대 메모리 등을 측정하여, 사용자에게 제공합니다.


| 항목 | 내용 |
|------|------|
| **기간** | 2022.02 ~ 2022.05 |
| **역할** | 시스템 설계, 백엔드 개발, SRE |
| **상태** | 1차 개발 완료 후 오픈 전 시장성에 대한 문제로 중단 |

<br>

## 담당 역할

### 백엔드 개발
- 시스템 설계
- API 서버 개발
- Isolate SandBox를 이용한 Execution Server 개발

### 인프라 및 운영
- Docker 기반 온프레미스 배포 구조 설계 및 개발
- IDC 서버 운영 및 배포 관리
- 각 언어의 Compiler 설치

---

## 주요 구현 및 성과

- **12개 언어 지원 코딩 테스트 코어 개발 및 프로젝트 40% 이상 기여**
  - Isolate 샌드박스를 활용해 특정 버전의 **12개 개발 언어**를 지원하는 실행 환경을 구현.   
    -> Java, C, C++, C#, Scala, Swift, Python2, Python3, Go, Kotlin, Javascript, R  
  - 설계, 아키텍쳐링, 핵심 개발, 배포, 서버 운영을 모두 전담.

- **온프레미스 설치 시간 단축**
  - Docker 기반 온프레미스 솔루션을 구성해 설치 과정의 단순화 및 설치 시간 **25% 이상 단축**.

---

## 사용 기술
**Backend:** Java, JWT, Spring boot, Mybatis, Isolate Sandbox, Websocket  
**Database:** MariaDB    
**Infra & Ops:** Docker-based deployment, Shell automation 
