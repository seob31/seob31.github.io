---
layout: page
title: "Isolate Sandbox Example"
permalink: /projects/additional/2022-05-31-Coding-Test-System/isolate_en/
---

<a href="javascript:history.back()" class="btn btn-outline-success btn-sm">
  <- Back
</a>

# Isolate Sandbox Example
<br>

## Overview
An isolate Sandbox example for safely executing user code in a coding test system.

<br>
## Core Code Example
#### Compile Example
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

#### Run Example
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

## Core Structure
 - Compile / run stages are separated for step-by-step execution  
 - Runtime environment is controlled via isolate options

## Key Points
- Full isolation of user code execution for system stability  
- Structure supports grading and post-processing based on execution results
