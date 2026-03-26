---
layout: page
title: "Isolate SandBox 예제"
permalink: /projects/additional/2022-05-31-Coding-Test-System/isolate/
---

<a href="javascript:history.back()" class="btn btn-outline-success btn-sm">
  ← 뒤로가기
</a>

# Isolate SandBox 예제
<br>

## 개요
코딩 테스트 시스템에서 사용자 코드를 안전하게 실행하기 위한 isolate Sandbox 예제 입니다.

<br>
## 핵심 코드 예제
#### 컴파일 예제
```java
isolate --cg \
  -b 1 \
  -M metadata.txt \
  -t 5 \
  -x 1 \
  -w 10 \
  -E HOME=/tmp \
  --run \
  -- /bin/bash compile
  > compile_out.txt
```

#### 실행 예제
```java
isolate --cg \  
    -b 1 \ 
    -M metadata.txt \  
    -t 5 \
    -x 1 \  
    -w 10 \  
    -E HOME=/tmp \  
    --run \  
    -- /bin/bash run \  
    > stdout_file.txt 2> stderr_file.txt  
```

<br>

## 핵심 구조  
 - 컴파일 / 실행 단계 분리하여 단계별 실행 가능  
 - isolate 옵션을 통한 실행 환경 제어  

## 핵심 포인트
- 사용자 코드 실행을 완전히 격리하여 시스템의 안정성 확보  
- 실행 결과를 기반으로 한 채점 및 후처리 가능 구조  
