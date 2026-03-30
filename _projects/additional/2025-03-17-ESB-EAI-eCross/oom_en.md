---
layout: page
title: "OOM Improvement Example"
permalink: /projects/additional/2025-03-17-ESB-EAI-eCross/oom_en/
---

<a href="javascript:history.back()" class="btn btn-outline-success btn-sm">
  <- Back
</a>

# OOM Improvement Example
<br>

## Overview
An issue was found where data accumulated in nested chains due to a flatMap-based chain and blocking handling, keeping references alive until the full flow completed, which caused OOM during large split processing.
To improve this, the flow was converted to a non-blocking structure by removing `.block()`, and repetitive step handling was restructured into an `expand`-based stream. This reduced reference retention time of prior-step objects and mitigated thread occupation and memory accumulation during large split processing.

<br>

## Core Code Example

**Before**  
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

**After**  
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

## Key Points

1. **Resolved Thread Occupation by Removing Blocking**
 - Removed `.block()` to solve request-level thread occupation
 - Prevented failures caused by processed data lingering too long in chains during large split processing

2. **Shifted to Repetitive Stream (`expand`) Processing Structure**
 - Replaced nested flatMap chains with an expand-based iterative structure
