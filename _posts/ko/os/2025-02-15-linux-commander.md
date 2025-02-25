---
layout: post
title: "바로쓰기 좋은 Linux 명령어 모음"
topic: os
categories: [linux]
image: assets\images\blog\os\linux.jpg
tags: [featured]
language: ko
---

안녕하세요. 오늘은 개발하면서 제가 자주 사용하는 명령어를 나열해볼까 합니다.   
개인적으로 업무 시 많이 사용했던 명령어를 기억에서 꺼내 간단히 적어보겠습니다.

[]는 값을 구별하기 위한 구별자입니다. 명령어 실행시 []를 빼고 입력해서 사용하면 됩니다.   

| 명령어 | 설명 | 비고 |
|:------------|:------------|:------------|
| cd [경로] | 경로 이동 | |
| cd ~ | 루트 경로 이동 | |
| cd / | 최상위 경로 이동 | |
| ll or ls | 파일 목록 보기(레드헷 계열) | |
| ls -al | 모든 목록보기 | |
| pwd |현재 경로 보기 | |
| mkdir [폴더명] |폴더 만들기 | |
| rmdir [폴더명] | 폴더 지우기(단, 폴더는 전부 비워져 있어야 한다.) | |
| rm -rf [폴더명] | 안의 내용까지도 강력하게 지우는 명령어 | |
| rm [파일명] | 파일 지우기 | |
| ln -s [파일명] | 심볼릭 링크 | |
| touch [파일명] | 파일 생성 | |
| cp [해당파일] [복사할 경로] | 파일 복사 | |
| cp -r [해당경로] [복사할 경로] | 하위 폴더 및 파일까지 복사 | |
| mv [옮기려는대상] [옮길경로] | 폴더 및 파일 옮기기(move) / [파일명] [바꿀 파일명] - 파일 명을 바꿀 수 있다. | |
| cat [파일] | 파일의 내용보기 | |
| cat [내용] > [파일명] | 입력한 내용의 파일 쓰기 | |
| su | root 아이디로 로그인 | |
| sudo [명령어] | root 권한처럼 명령어 실행. | | 
| who | 로그인 된 사용자 출력 | |
| history | 사용했던 명령어 출력 | |
| top | 프로세스 정보 출력 | |
| uname | 현재 운영체제의 정보 출력 | |
| df -h | 디스크 사용량을 출력한다. | |
| find [경로] -name [타겟명 or 옵션] | 경로의 타겟명으로 된 폴더 및 파일을 찾는다. | ex) find / -name *.jpg : 모든 경로에서 모든 jpg 파일을 찾는다. |
| ps -ef `|` grep java | java로된 현재 프로세스 목록 및 정보를 보여준다. |
| kill [pid] | pid에 해당하는 프로세스를 종료한다. 종료가 안될 시  kill -9 pid 강제종료 명령어 | |
| systemctl start [서비스명] | 서비스를 시작한다. | |
| systemctl restart [서비스명] | 서비스를 재시작한다. | |
| systemctl stop [서비스명] | 서비스를 중지한다. | |
| systemctl enable [서비스명] | 서비스 활성화한다. | |
| systemctl disable [서비스명] | 서비스 비활성화한다. | |
| systemctl status [서비스명] | 서비스의 상태를 본다. | |
| systemctl daemon-reload | system 데몬 리로드(보통 systemctl에 문제 있을 때 사용했음.) | |
| vi ~/.bash_profile -> alias ll="ls" 추가 -> source ~/.bash_profile  | alias 등록 시 사용 | vi 명령어가 없을 시 설치 필요 |
| ping [ip] | 해당 ip에 대해 네트워크를 체크한다. | |
| netstat -an `|` grep [포트번호] | 사용 중인 포트번호를 찾는다 | netstat 명령어 없을 시 설치 필요 |
| netstat -nlpt | TCP listening 상태의 포트와 프로그램 표시한다. | |
|=====
{: class="articleTable"}

<br>

|:------------|:----------| 
| chown [소유자:소유자그룹] [파일 및 디렉토리] | 파일 및 디렉토리의 소유자를 변경한다. |
| chmod 777 [파일 및 디렉토리] | 파일 및 디렉토리의 권한을 변경한다. (777: 모든 권한) |
| owner / group / other  | 소유자 / 그룹 / 다른소유자  |
| R W X / R W X / R W X  | R(읽기) - 4 / W(쓰기) - 2 / X(실행) - 1  *[RWX를 더한 값 : 7] |
|=====
{: class="articleTable"}
* chmod 및 chown 을 쓸때 하위 폴더 및 파일도 같이 변경했기에 chmod -r 751 [디렉토리]를 자주 이용했습니다.

이상 리눅스 명령어 정리였습니다. 