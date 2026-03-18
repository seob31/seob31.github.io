---
layout: page
title: "Reactor 기반 비동기 워크플로우 & Saga 처리 구조"
permalink: /projects/additional/2025-03-17-ESB-EAI-eCross/saga/
---

<p>
  <a href="/projects/ESB-EAI-eCross/" class="btn btn-outline-success btn-sm">← 뒤로가기</a>
</p>

# Reactor 기반 비동기 워크플로우 & Saga 처리 구조

## 개요
ESB/EAI 시스템에서 마이크로서비스 간 트랜잭션 관리를 위한 Saga Pattern을 적용할 수 있는 구조 기반으로, Reactor를 활용한 비동기 워크플로우를 구현.

## 핵심 코드 예제
### 1. Step 상태 관리 및 비동기 처리
```java
@Getter
public enum WorkflowStepStatus {
    READY,
    PENDING,
    PARTIAL_COMPLETE,
    COMPLETE,
    FAILED
}

public Mono<AdapterResponseDto> process(AdapterRequestDto request) {
    stepStatus = WorkflowStepStatus.PENDING;

    return webClient.post()
        .bodyValue(request)
        .retrieve()
        .bodyToMono(AdapterResponseDto.class)
        .doOnSuccess(res -> {
            if (res.getDataCount().isFullySuccessful()) {
                stepStatus = WorkflowStepStatus.COMPLETE;
            } else {
                stepStatus = WorkflowStepStatus.PARTIAL_COMPLETE;
            }
        })
        .onErrorResume(error -> {
            stepStatus = WorkflowStepStatus.FAILED;
            return Mono.error(error);
        });
}

```

### 2. 분할 처리 및 후속 프로세스 분기
```java
Mono<AdapterResponseDto> responseMono = step.beforeProcess(isLogging, messageMonitoringDto)
    .process(adapterRequestDto)
    .doOnSuccess(responseDto -> {
        manageMonitoringData(...);
    })
    .onErrorResume(error -> {
        manageMonitoringData(...);
        return skipProcess(step, error, false);
    });

return responseMono.flatMapMany(responseDto -> {
    List<String> nextProcessIds = step.getNextProcessIds();

    if (!nextProcessIds.isEmpty()) {
        return splitStream(responseDto, ...)
            .flatMapMany(streamResponse -> {
                // 에러가 마지막 step에서 error 발생 시 같은 step이 stream 안에서 1번 stream 외부에서 1번 실행 / 연속 중복 방지
                if (streamResponse.getSplitProcessInfoDto().getSeq() == -1
                        && streamResponse.getSplitProcessInfoDto().getIsSplitProcess().equals(StatusCode.Y_FLAG)) {
                    return doProccesswithFlux(nextProcessIds, ...);
                }
                return doProccesswithFlux(nextProcessIds, ...);
            });
    }
    return Flux.just(responseDto);
});

```

## 핵심 포인트
1. **Hub 채널 간 트랜잭션 관리 단순화**
   - ProcessStep 단위로 실행 상태를 관리하여 복잡한 흐름 제어를 단순화
   - 실패 시 skip / 후속 처리 분기를 통해 전체 중단 없이 안정적인 처리 가능

2. **분할 처리 (Split Processing) 지원**
   - 대용량 데이터 처리 시 split 단위로 처리 가능
   - writer/reader 이후 흐름을 구분하여 중복 실행 방지

3. **비동기 워크플로우 처리**
   - WebClient를 활용한 non-blocking 호출 구조

4. **운영 중심 장애 처리**
   - 모니터링에 상태가 기록됨으로 어느 구간에서 장애 발생 파악 가능
