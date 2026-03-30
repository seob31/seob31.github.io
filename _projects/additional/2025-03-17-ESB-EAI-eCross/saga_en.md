---
layout: page
title: "Reactor-based Async Workflow & Saga Processing Structure"
permalink: /projects/additional/2025-03-17-ESB-EAI-eCross/saga_en/
---

<a href="javascript:history.back()" class="btn btn-outline-success btn-sm">
  <- Back
</a>

# Reactor-based Async Workflow & Saga Processing Structure
<br>

## Overview
A structure that enables applying the Saga pattern for transaction management across microservices in an ESB/EAI system, implementing an asynchronous workflow with Reactor.
<br>

## Core Code Example
### 1. Step status management and asynchronous processing
```java
@Getter
public enum WorkflowStepStatus {
    READY,
    PENDING,
    PARTIAL_COMPLETE,
    COMPLETE,
    FAILED
}

public Mono<ResponseDto> process(RequestDto request) {
    stepStatus = WorkflowStepStatus.PENDING;

    return webClient.post()
        .bodyValue(request)
        .retrieve()
        .bodyToMono(ResponseDto.class)
        .doOnSuccess(res -> {
            if (res.getCount().isSucced()) {
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

### 2. Split processing and subsequent-process branching
```java
Mono<ResponseDto> responseMono = step.beforeProcess(log, monitoringDto)
    .process(RequestDto)
    .doOnSuccess(responseDto -> {
       monitoringData(...);
    })
    .onErrorResume(error -> {
        monitoringData(...);
        return skipProcess(step, error, false);
    });

return responseMono.flatMapMany(responseDto -> {
    List<String> nextIds = step.getNextIds();

    if (!nextIds.isEmpty()) {
        return splitStream(responseDto, ...)
            .flatMapMany(streamResponse -> {
                // Prevent sequential duplication
                if (streamResponse.getSplitDto().getSeq() == -1
                        && streamResponse.getSplitDto().getIsSplit().equals(StatusCode.Y_FLAG)) {
                    return doProccesswithFlux(nextIds, ...);
                }
                return doProccesswithFlux(nextIds, ...);
            });
    }
    return Flux.just(responseDto);
});

```
<br>

## Key Points
1. **Simplified Inter-channel Transaction Management**
   - Managed execution state per step to simplify complex flow control
   - When errors occur, allows skip/follow-up branching based on settings for stable processing without full-stop

2. **Split Processing Support**
   - Supports chunk-level processing for large data volumes
   - Distinguishes post writer/reader flows to prevent duplicate execution

3. **Asynchronous Workflow Processing**
   - Non-blocking call structure using WebClient

4. **Operations-focused Failure Handling**
   - Monitoring records status so failure points can be identified quickly
