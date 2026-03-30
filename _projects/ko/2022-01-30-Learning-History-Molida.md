---
layout: project
title: "블록체인 기반 교육 이력 및 자격증 인증 서비스 (Molida) - 개발"
topic: project
tags: [fullstack]
sticky: false
language: ko
show: true
image: assets/images/project/molida/logo.png
main: true
---

## 프로젝트 개요
교육 이력, 수상이력과 자격증 정보 등을 관리하고 증명서 발급을 넘어 기관(대학, 지자체, 공기업 등)의 증명서 발급 및 제작까지 지원하는 블록체인 기반 서비스 프로젝트입니다.  

| 항목 | 내용 |
|------|------|
| **기간** | 2019.11 ~ 2022.01 |
| **역할** | 시스템 설계, 백엔드 개발, 프론트엔드 개발, 서버 운영 |

<br>

## 담당 역할

## 설계
- 시스템 설계  
- 화면 설계  

### 백엔드 개발
- 메인기능(블록체인 기반 학습이력 관리) 기능 개발
- 블록체인 기반 학습이력 관리의 자동등록 기능 개발
- 블록체인 연동의 증명서 검증과 증명서 생성 기능 개발
- MariaDB Event Scheduler와 Stored Procedure 기반 데이터 격리 보관 자동화 개발 
- MariaDB Stored Procedure 기반의 데이터 격리 보관 자동화 기능의 로그 관리 기능 개발
- 증명서 직접 제작 기능의 백엔드 개발
- 보안 취약점 대응
- 고객사 요구사항 대응 및 유지보수
- 휴대폰 본인 인증 기능 연동
- 다양한 게시판, 회원가입 등의 홈페이지 기능 기본에 관련한 백엔드 개발  
  -> 사용자, 기관, 운영자 페이지
- 운영서버 트러블 슈팅 대응
- 정기점검 관련 대응

### 프론트 개발
- 증명서 직접 제작 기능의 프론트엔드 개발
- 다양한 게시판, 팝업, 회원가입 등의 홈페이지 기능 기본에 관련한 프론트 개발  
  -> 사용자, 기관, 운영자 페이지
- 퍼블리싱의 수정 및 퍼블리싱을 이용한 프론트엔드 개발

## 서버운영
- IDC 서버 운영 담당
- Docker, Shell 기반 배포 자동화 관리
- ISMS-P 인증의 서버 보안 관련 대응

---

## 주요 성과

- **증명서 생성 기능 내재화**  
  - 증명서 생성 기능을 직접 설계하고, 프론트엔드(JavaScript)와 백엔드(Java)를 모두 자체 개발  
    -> 외부 라이브러리 의존성을 제거하여 **약 2천만 원의 개발 비용 절감**  
  - [→ 증명서 생성 기능 일부 예시](/projects/additional/2022-01-30-Learning-History-Molida/cert/)

- **ISMS-P 취득**  
  - MariaDB 저장 프로시저 및 이벤트 스케줄러를 활용한 데이터 분리·보관 자동화 시스템 구축  
  - 프로시저 단위 로깅 시스템 개발, 물리 서버 보안 강화 및 보안 취약점 대응 수행  
    -> 이를 통해 **ISMS-P 인증 획득에 20% 이상 기여**

---

## 사용 기술
**Backend:** Java, MyBatis, Spring framework, Maven, Shell Script  
**Frontend:** HTML, JavaScript, jQuery, Ajax, JSP  
**Database:** MariaDB
**Infrastructure:** Docker, HAProxy  
**Monitoring:** Prometheus, Grafana   
**DevOps / Tools:** Portainer 


## 주요 화면
>> **학습이력 리스트**  
![list](/assets/images/project/molida/list.png)  
<br>
>> **학습이력 상세**  
![detail](/assets/images/project/molida/detail.png)  
<br>
>> **워터마크 화면**  
![watermark](/assets/images/project/molida/watermark.png)  
<br>
>> **증명서 발급 리스트 화면**  
![certList](/assets/images/project/molida/certList.png)  
<br>
>> **증명서 발급 화면**  
![cert](/assets/images/project/molida/cert.png)  
<br>
>> **기관 증명서 신청 화면**  
![request](/assets/images/project/molida/request.png)  