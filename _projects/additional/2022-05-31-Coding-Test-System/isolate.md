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
Spring Batch의 Partitioning 구

<br>
## 핵심 코드 예제
#### 컴파일 예제
```java
isolate --cg \
  -b 62 \
  -M metadata.txt \
  -t 5 \
  -x 1 \
  -w 10 \
  --cg-mem=128000 \
  -E HOME=/tmp \
  --stderr-to-stdout \
  --run \
  -- /bin/bash compile
  > compile_out.txt
```

#### 실행 예제
```java
isolate --cg \
    -b 62 \
    -M metadata.txt \
	-t 5 \
    -x 1 \
    -w 10 \
    --cg-mem=128000 \
    -E HOME=/tmp \
    --run \
    -- /bin/bash run \
    > stdout_file.txt 2> stderr_file.txt
```

<br>

## 핵심 구조  
 - Partitioning 기반 병렬 처리  
 - Chunk 단위 데이터 처리  
 - 예외 발생 시 skip 처리 (전체 중단 방지)  
 - Listener 기반 로깅 및 후처리  

<br> 

## 핵심 포인트
- 대용량 데이터 처리 성능 향상 (멀티스레드)
- 장애 발생 시에도 작업 지속 가능
- 실행 이력 및 상태 추적 가능
