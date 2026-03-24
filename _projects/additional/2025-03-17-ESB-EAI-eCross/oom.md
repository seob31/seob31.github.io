---
layout: page
title: "OOM 개선 내용 예시"
permalink: /projects/additional/2025-03-17-ESB-EAI-eCross/oom/
---

<a href="javascript:history.back()" class="btn btn-outline-success btn-sm">
  ← 뒤로가기
</a>

# OOM 개선 내용 예시  
<br>

## 개요  
flatMap 기반 체인과 블로킹 처리로 중첩 체인 안에서 데이터가 누적되어 흐름이 완전히 끝날 때까지 참조가 남는 현상이 발견되어 대용량 분할 처리에서 OOM이 발생. 
이를 개선하기 위해 `.block()`을 제거한 non-blocking 구조로 전환하고, 반복적인 Step 처리를 `expand` 기반 스트림으로 재구성하여, 이전 단계 객체의 참조 유지 시간이 줄어들고, 대용량 분할 처리 시 쓰레드 점유와 메모리 누적이 완화됨.

<br>

## 핵심 코드 예제  

**기존**  
```java
return Mono.just(previousResponse)
        .flatMap(response -> {
            return processNextSteps()
            .flatMap(resp -> {
                return processPreviousStep();
            });
        })
        .block();
```

**개선**  
```java
Mono.just(previousResponse)
        .expand(response -> {
            return processNextSteps()
                .flatMap(resp -> {
                    return processPreviousStep();
                });
        }).last();
```
<br>

## 핵심 포인트

1. **Blocking 제거로 쓰레드 점유 해소**
 - `.block()` 제거를 통해 요청 단위 쓰레드 점유 문제 해결
 - 대량 분할 처리 시처리 완료된 데이터가 체인에 장시간 남아 누적되는 장애 방지

2. **반복 스트림(expand) 기반 처리 구조 전환**
 - 중첩된 flatMap 체인을 expand 기반 반복 구조로 변경