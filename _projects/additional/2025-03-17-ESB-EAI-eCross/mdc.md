---
layout: page
title: "MDC 기반 로깅 구조 정리 예시"
permalink: /projects/additional/2025-03-17-ESB-EAI-eCross/mdc/
---

<a href="javascript:history.back()" class="btn btn-outline-success btn-sm">
  ← 뒤로가기
</a>

#  MDC 기반 로깅 구조 정리 예시
<br>

## 개요
기존 ESB/EAI 시스템에서는 인터페이스별로 로그를 분리하기 위해 다수의 Appender를 생성하여 관리하고 있었으며, 이로 인해 설정 복잡도 증가 및 유지보수 어려움 문제가 발생. 이를 해결하기 위해 MDC(Mapped Diagnostic Context)를 활용한 동적 로그 분리 구조를 적용하여 로깅 설정을 단순화하고 운영 효율성을 개선.

<br>

## 핵심 코드 예제

```java
MDC.put("id", id);
MDC.clear();
```

**기존**  
```xml
<appender class="ch.qos.logback.classic.sift.SiftingAppender" name="DEV">
</appender>
<appender class="ch.qos.logback.classic.sift.SiftingAppender" name="DEV2">
</appender>
<appender class="ch.qos.logback.classic.sift.SiftingAppender" name="DEV3">
</appender>
```

**개선** 
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
        <rollingPolicy class="롤링패턴 class">
          <fileNamePattern>./logs/%d{yyyy/MM/dd}/${id}.%i.log</fileNamePattern>
          <maxFileCount>100</maxFileCount>
          <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
            <maxFileSize>100MB</maxFileSize>
          </timeBasedFileNamingAndTriggeringPolicy>
        </rollingPolicy>
      </appender>
```
<br>

## 핵심 포인트
1. **로깅 설정 구조 단순화**
   - 인터페이스별로 분산되어 있던 다수의 Appender를 단일 구조로 통합
   - 신규 인터페이스 추가 시 설정 변경 없이 확장 가능

2. **MDC 기반 동적 로그 분리**
   - MDC에 인터페이스 식별자(id)를 설정하여 로그를 동적으로 분리
   - `${id}.log` 형태로 자동 파일 생성되어 인터페이스 단위 로그 관리 가능

3. **유지보수성 향상**
   - `logback.xml` 설정 복잡도 감소
   - 설정 변경 리스크 최소화 및 운영 안정성 확보
