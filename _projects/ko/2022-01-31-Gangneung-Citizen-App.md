---
layout: project
title: "강릉시 커뮤니티 앱 (내손안에 강릉) - 개발"
topic: project
tags: [backend, mydata, mobile]
sticky: false
language: ko
show: true
image: assets/images/project/gangneung/main.jpg
main: true
---

## 프로젝트 개요
강릉의 스마트시티 챌린지 사업의 일부로 도서관증·시민증을 모바일로 발급받아 간편히 이용하고, 정부24 연계를 통해 마이데이터 기반 개인 맞춤 서비스와 복지·행정, 관광·여행 정보를 제공해 시민과 방문객 모두의 편의성을 높인 시민 생활형 통합 서비스 앱입니다.


| 항목 | 내용 |
|------|------|
| **기간** | 2021.08 ~ 2022.01 |
| **역할** | 프로젝트 설계, 백엔드 개발, SRE, 해외 개발자 지원 |
| **상태** | 1차 개발(설계·핵심 기능·아키텍처) 완료 및 안정화 후 타 프로젝트 설계로 인해 프로젝트 전환 |

<br>

## 담당 역할

### 백엔드 및 연동 개발
- 시스템 설계
- 정부 24 API 연동으로 공공 마이데이터 기능 개발
- 정부 24 API 연동 맞춤복지 기능 개발
- 국가 행정망 연동으로 강릉 시민 확인 기능 개발
- 모바일 -> 서버 통신간 RSA 암호화 기법을 이용하여 데이터 통신 개발

### 운영 및 배포
- Docker, Shell 기반 배포 자동화
- 테스트 서버 및 강릉시 운영 서버 구축 및 서버운영
- 해외 개발자 업무 지원 (Mobile 개발자)

---

## 주요 구현 및 성과

- **공공 API 연동 기반 마이데이터 기능 구현**
  - 국가행정망 연계, 정부24를 연계하여 주요 기능인 마이데이터, 맞춤복지 기능을 개발.  
    -> 개발 자체보다 장애 대응 및 문의 과정에서 담당 부서 식별의 어려움이 주요 이슈로 작용.

- **1차 개발 전 과정 주도적 참여**
  - 설계, 개발, 인프라 구축 등 프로젝트 전반에 걸쳐 핵심 역할 수행으로 전체 개발 기여도 **약 35% 이상** 담당

---

## 사용 기술
**Backend:** Java, MyBatis, Spring boot, SOAP (정부기관 API 연동)  
**Database:** PostgreSQL  
**Infrastructure:** Shell automation(Shell scripting) 

<br>
---

## 주요 화면
>> **메인**  
![main](/assets/images/project/gangneung/main.png)  
<br>
>> **마이데이터 증명서 발급**  
![mydata](/assets/images/project/gangneung/mydata.png)  
<br>
>> **마이데이터 지갑**  
![mydata2](/assets/images/project/gangneung/mydata2.png)  
<br>