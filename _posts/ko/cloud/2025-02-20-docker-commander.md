---
layout: post
title: "바로쓰기 좋은 docker 명령어 모음"
topic: cloud
categories: [docker]
image: assets\images\blog\cloud\docker.png
tags: [featured]
language: ko
show: true
---

안녕하세요. 오늘은 개발하면서 제가 자주 사용했던 도커 명령어를 나열해볼까 합니다.   
개인적으로 업무 시 많이 사용했던 명령어를 기억에서 꺼내 간단히 적어보겠습니다.
*명령어는 red hat 계열로 작성 하였기에 OS가 다르다면 해당 OS 맞게 변경하셔야 합니다. 또한, Docker 는 기본적으로 root 권한의 명령어으로 진행하셔야 합니다.
버전에 따라 진행되는 명령어 yum이 안되실 경우 dnf로 진행하시면 되겠습니다.

[]는 값을 구별하기 위한 구별자입니다. 명령어 실행시 []를 빼고 입력해서 사용하면 됩니다.   

| 명령어 | 설명 | 비고 |
|:------------|:------------|:------------|
| yum update | 패키지 업데이트 및 yum-utils 를 최신 버전으로 업데이트  | |
| yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo | Docker 설치를 위한 저장소 추가  | |
| yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin | Docker 설치  | 원하시는 부분만 설치하여 사용해도 무방 |
| yum remove docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin | Docker 설치  | 원하시는 부분만 설치하여 사용해도 무방 |
| docker -v | Docker 버전 확인  |  |
| docker pull [이미지 정보] | Docker 이미지 다운로드  | 예) docker pull postgres:latest |
| systemctl start docker | Docker 서비스 시작  |  |
| systemctl stop docker | Docker 서비스 정지  |  |
| systemctl restart docker | Docker 서비스 재시작  |  |
| systemctl enable docker | 부팅 시 Docker 자동 시작  |  |
| docker run hello-world | 도커의 hellow-world 컨테이너 생성 및 시작  | TEST 용 |
| docker ps | 실행중인 컨테이너의 전체 리스트  |  |
| docker ps -a | 전체 컨테이너 리스트  |  |
| docker inspect [컨테이너 이름] | 컨테이너 정보  |  |
| docker rename [컨테이너 이름] [새 이름] | 컨테이너 이름 변경  |  |
| docker logs [컨테이너 이름] | 컨테이너 로그  |  |
| docker logs -f [컨테이너 이름] | 컨테이너 실시간 로그  |  |
| docker start [컨테이너 이름] | 컨테이너 시작  |  |
| docker stop [컨테이너 이름] | 컨테이너 정지 |  |
| docker restart [컨테이너 이름] | 컨테이너 재시작  |  |
| docker stats -a | 전체 컨테이너 상태  |  |
| docker attach [컨테이너 이름] | 컨테이너 접속  | 터미널 종료시(exit)시 컨테이너도 같이 종료 |
| docker exec -it [컨테이너 이름] /bin/bash | 컨테이너 접속  | 터미널 종료시(exit)시 컨테이너 유지 */bin/bash가 안될 경우 /bin/sh로 실행 |
| docker exec my_container [명령어] | 컨테이너 밖에서 컨테이너에 명령어 실행  | 예) docker exec my_container ls /home |
| docker network list | 네트워크 목록  |  |
| docker network create [이름] | 네트워크 생성  | 예) docker network create --gateway 192.10.0.1 --subnet 192.10.0.0/21 con_bridge 세부설정을 안하면 기본 브릿지를 생성 합니다. 갑자기 컨테이너의 DB에 접속이 안되거나 했을 경우 네트워크 문제이므로 컨테이너 만들 시 알아두면 좋습니다. |
| docker rm [컨테이너 이름] | 컨테이너 삭제  |  |
| docker images | 컨테이너 이미지 목록  |  |
| docker rmi [이미지 아이디]| 컨테이너 이미지 삭제  |  |
| docker volume ls| 도커 볼륨 목록  |  |
| docker volume create [이름]| 도커 볼륨 생성  |  |
| docker volume rm [이름]| 도커 볼륨 삭제 |  |
| docker commit [컨테이너 아이디] [저장할 이미지 아이디]| 컨테이너 이미지화 |  |
| docker save -o [파일명] [파일로 저장할 이미지명]| 이미지 파일화 |  |
| docker load -i [파일명] | 파일의 이미지화 |  |
| docker cp [호스트 경로] [컨테이너 이름]:[컨테이너 경로] | 호스트에서 컨테이너로 파일 복사(반대로도 가능) | 예) docker cp /home/test.txt hellow-world:/home/  |
|=====
{: class="articleTable"}

컨테이너 생성 및 실행 예시문

docker run --restart=always \  
	--log-driver=json-file \
	-p 18080:8080 \
	-v /home/project/:/home/container \
	-e LANG=ko_KR.utf-8 -e LC_ALL=ko_KR.utf8 \
	-d -i -t \
	--privileged \
	--name container1 [image 명]:[태그]

--restart=always : 컨테이너가 비정상 종료되거나 Docker 데몬 재시작 시 자동으로 재시작
--log-driver=json-file : 로그를 JSON 파일 형식으로 저장
-p 18080:8080 : 포트 포워딩 로컬의 18080포트를 컨테이너 8080 포트에 연결
-v /home/project/:/home/container : 호스트 디렉토리(/home/project)를 컨테이너의 /home/container에 볼륨 마운트
-e LANG=ko_KR.utf-8 : 환경 변수 설정 – 언어 설정
-d : Detached 모드 – 백그라운드에서 실행
-i : 표준 입력(입력 대기)을 유지 (보통 -t와 같이 사용)
-t : 터미널을 할당 (터미널처럼 인터페이스 제공)
--privileged : 컨테이너가 호스트의 거의 모든 권한을 가지도록 허용 
--name container1 : 컨테이너 이름 지정
[이미지명]:[태그] : 실행할 이미지 이름과 태그 예) ubuntu:20.04, nginx:latest

<br>


이상 도커 명령어 정리였습니다. 