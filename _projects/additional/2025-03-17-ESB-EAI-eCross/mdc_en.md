---
layout: page
title: "MDC-based Logging Structure Example"
permalink: /projects/additional/2025-03-17-ESB-EAI-eCross/mdc_en/
---

<a href="javascript:history.back()" class="btn btn-outline-success btn-sm">
  <- Back
</a>

# MDC-based Logging Structure Example
<br>

## Overview
In the legacy ESB/EAI system, multiple appenders were created and managed to split logs by interface, which increased configuration complexity and made maintenance difficult. To solve this, a dynamic log-splitting structure using MDC (Mapped Diagnostic Context) was applied to simplify logging configuration and improve operational efficiency.

<br>

## Core Code Example

```java
MDC.put("id", id);
MDC.clear();
```

**Before**  
```xml
<appender class="ch.qos.logback.classic.sift.SiftingAppender" name="DEV">
</appender>
<appender class="ch.qos.logback.classic.sift.SiftingAppender" name="DEV2">
</appender>
<appender class="ch.qos.logback.classic.sift.SiftingAppender" name="DEV3">
</appender>
```

**After** 
```xml
  <appender class="ch.qos.logback.classic.sift.SiftingAppender" name="DEV">
    <discriminator>
      <key>id</key>
      <defaultValue>defaultId</defaultValue>
    </discriminator>
    <sift>
      <appender class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>./logs/${id}.log</file>
        <encoder>
          <Pattern>${IF_DEV_LOG_PATTERN}</Pattern>
          <charset>UTF-8</charset>
        </encoder>
        <rollingPolicy class="rolling-pattern-class">
          <fileNamePattern>./logs/%d{yyyy/MM/dd}/${id}.%i.log</fileNamePattern>
          <maxFileCount>100</maxFileCount>
          <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
            <maxFileSize>100MB</maxFileSize>
          </timeBasedFileNamingAndTriggeringPolicy>
        </rollingPolicy>
      </appender>
```
<br>

## Key Points
1. **Simplified Logging Configuration Structure**
   - Consolidated many interface-specific appenders into one structure
   - Scales for new interfaces without config changes

2. **MDC-based Dynamic Log Separation**
   - Sets interface identifier (`id`) in MDC to split logs dynamically
   - Auto-generates log files in `${id}.log` format for interface-level management

3. **Improved Maintainability**
   - Reduced `logback.xml` complexity
   - Minimized change risk and improved operational stability
