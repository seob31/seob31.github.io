---
layout: post
title: "바로쓰기 좋은 docker 명령어 모음"
topic: devops
categories: [docker]
image: assets/images/blog/devops/docker.png
tags: [featured]
language: ko
show: true
---

안녕하세요. 오늘은 개발하면서 제가 자주 사용했던 도커 명령어를 나열해볼까 합니다.   
개인적으로 업무 시 많이 사용했던 명령어를 기억에서 꺼내 간단히 적어보겠습니다.

*명령어는 red hat 계열로 작성 하였기에 OS가 다르다면 해당 OS 맞게 변경하셔야 합니다. 또한, Docker 는 기본적으로 root 권한의 명령어으로 진행하셔야 합니다.  
버전에 따라 진행되는 명령어 yum이 안되실 경우 dnf로 진행하시면 되겠습니다.*

[]는 값을 구별하기 위한 구별자입니다. 명령어 실행시 []를 빼고 입력해서 사용하면 됩니다.

---

# Docker 설치

| 명령어 | 설명 | 비고 |
|:------------------------------------------------------|:------------------------------------------------------|:------------------------------------------------------|
| yum update | 패키지 업데이트 및 yum-utils 를 최신 버전으로 업데이트 | |
| yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo | Docker 설치를 위한 저장소 추가 | |
| yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin | Docker 설치 | 원하시는 부분만 설치하여 사용해도 무방 |
| yum remove docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin | Docker 삭제 | 원하시는 부분만 설치하여 사용해도 무방 |
| docker -v | Docker 버전 확인 | |

---

# Docker 서비스 관리

| 명령어 | 설명 | 비고 |
|:------------------------------------------------------|:------------------------------------------------------|:------------------------------------------------------|
| systemctl start docker | Docker 서비스 시작 | |
| systemctl stop docker | Docker 서비스 정지 | |
| systemctl restart docker | Docker 서비스 재시작 | |
| systemctl enable docker | 부팅 시 Docker 자동 시작 | |

---

# Docker 이미지 관리

| 명령어 | 설명 | 비고 |
|:------------------------------------------------------|:------------------------------------------------------|:------------------------------------------------------|
| docker pull [이미지 정보] | Docker 이미지 다운로드 | 예) docker pull postgres:latest |
| docker images | 컨테이너 이미지 목록 | |
| docker rmi [이미지 아이디] | 컨테이너 이미지 삭제 | |
| docker commit [컨테이너 아이디] [저장할 이미지 아이디] | 컨테이너 이미지화 | |
| docker save -o [파일명] [파일로 저장할 이미지명] | 이미지 파일화 | |
| docker load -i [파일명] | 파일의 이미지화 | |

---

# Docker 컨테이너 관리

| 명령어 | 설명 | 비고 |
|:------------------------------------------------------|:------------------------------------------------------|:------------------------------------------------------|
| docker run hello-world | 도커의 hello-world 컨테이너 생성 및 시작 | TEST 용 |
| docker ps | 실행중인 컨테이너 리스트 | |
| docker ps -a | 전체 컨테이너 리스트 | |
| docker inspect [컨테이너 이름] | 컨테이너 정보 확인 | |
| docker rename [컨테이너 이름] [새 이름] | 컨테이너 이름 변경 | |
| docker start [컨테이너 이름] | 컨테이너 시작 | |
| docker stop [컨테이너 이름] | 컨테이너 정지 | |
| docker restart [컨테이너 이름] | 컨테이너 재시작 | |
| docker rm [컨테이너 이름] | 컨테이너 삭제 | |

---

# 로그 및 상태 확인

| 명령어 | 설명 | 비고 |
|:------------------------------------------------------|:------------------------------------------------------|:------------------------------------------------------|
| docker logs [컨테이너 이름] | 컨테이너 로그 확인 | |
| docker logs -f [컨테이너 이름] | 컨테이너 실시간 로그 | |
| docker stats -a | 전체 컨테이너 상태 확인 | |

---

# 컨테이너 접속

| 명령어 | 설명 | 비고 |
|:------------------------------------------------------|:------------------------------------------------------|:------------------------------------------------------|
| docker attach [컨테이너 이름] | 컨테이너 접속 | exit 시 컨테이너도 같이 종료 |
| docker exec -it [컨테이너 이름] /bin/bash | 컨테이너 접속 | exit 시 컨테이너 유지 / bash 없으면 /bin/sh |
| docker exec my_container [명령어] | 컨테이너 외부에서 명령어 실행 | 예) docker exec my_container ls /home |

---

# Docker 네트워크

| 명령어 | 설명 | 비고 |
|:------------------------------------------------------|:------------------------------------------------------|:------------------------------------------------------|
| docker network list | 네트워크 목록 확인 | |
| docker network create [이름] | 네트워크 생성 | 예) docker network create --gateway 192.10.0.1 --subnet 192.10.0.0/21 con_bridge |
