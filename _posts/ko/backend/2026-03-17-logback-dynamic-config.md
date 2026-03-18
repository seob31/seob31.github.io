---
layout: post
title: "Logback 동적 설정 및 Tomcat Access Log 관리"
topic: backend
categories: [java]
image: assets/images/blog/backend/onePic/logback.png
tags: [featured]
language: ko
show: true
---

## 개요
Spring Boot 애플리케이션에서 Logback 설정을 런타임에 동적으로 수정하고, Tomcat의 Log를 관리하는 기능입니다. 런타임 중에 특정상황에서 로그를 끄고 싶거나, 이미 메인 logback 설정되어 다른 로그를 수정할 수 없을때, 유동적으로 로그 레벨, 파일 경로, 롤링 정책 등을 실시간으로 변경할 수 있습니다.

## 주요 기능

### 1. log 중지
실행 중인 Access Log를 안전하게 중지합니다.

```java
public void stopAccessLog(TomcatServletWebServerFactory factory) {
   log.info("Stop Access Log");
   factory.getContextValves().forEach(valve -> {
       if (valve instanceof LogbackValve) {
           LogbackValve logValve = (LogbackValve) valve;
           if ("AccessLog".equals(logValve.getName()) && logValve.isStarted()) {
               Iterator<Appender<IAccessEvent>> iterator = logValve.iteratorForAppenders();
               while (iterator.hasNext()) {
                   iterator.next().stop();
               }
           }
       }
   });
}
```

### 2. Log 설정 변경 후 재 실행
Dto logConfig는 변경되어야 할 항목을 담는 오브젝트를 생성 후 진행하면 됩니다.
아래의 코드는 로그 파일 경로, 파일 크기, 보관 개수 등을 동적으로 수정한 후 로그를 재실행 시킵니다.

```java
public void modifyAccessLog(TomcatServletWebServerFactory factory, Dto logConfig) {
   factory.getContextValves().stream()
           .filter(valve -> valve instanceof LogbackValve && ((LogbackValve) valve).getName().equals("AccessLog"))
           .map(LogbackValve.class::cast)
           .filter(LogbackValve::isStarted)
           .forEach(logValve -> {
               Iterator<Appender<IAccessEvent>> iterator = logValve.iteratorForAppenders();
               while (iterator.hasNext()) {
                   iterator.next().stop();
               }

               RollingFileAppender<IAccessEvent> appender = (RollingFileAppender<IAccessEvent>) logValve.getAppender("access");
               String logPrefix = "/" + getValueFromXml("경로/access-log.xml", logConfigData.getCategory(),
                       "LOG_PREFIX");
               ((FileAppender<IAccessEvent>) appender).setFile(logConfig.getLogDir() + logPrefix + ".log");

               RollingPolicy rollingPolicy = appender.getRollingPolicy();
               if (rollingPolicy instanceof LimitedFileCountRollingPolicy) {
                   SizeAndTimeBasedFNATP<?> sizeAndTimeBasedFNATP = (SizeAndTimeBasedFNATP<?>) ((LimitedFileCountRollingPolicy<?>) rollingPolicy).getTimeBasedFileNamingAndTriggeringPolicy();
                   sizeAndTimeBasedFNATP.setMaxFileSize(
                           new FileSize(logConfig.getMaxFileSize() * FileSize.MB_COEFFICIENT));

                   ((LimitedFileCountRollingPolicy<?>) rollingPolicy).setMaxFileCount(logConfig.getMaxFileCount());
                   ((LimitedFileCountRollingPolicy<?>) rollingPolicy).setFileNamePattern(
                           logConfig.getLogDir() + "/%d{yyyy/MM/dd}" + logPrefix + ".%i.log");
               }
               appender.getRollingPolicy().start();
               appender.start();
           });
}

// logback의 내용을 가져옵니다.
private static final XMLInputFactory XML_INPUT_FACTORY;
public String getValueFromXml(String configPath, String id, String name) {
        try (FileInputStream inputStream = new FileInputStream(configPath)) {
            XMLStreamReader reader = XML_INPUT_FACTORY.createXMLStreamReader(inputStream);
            String result = "";

            while (reader.hasNext()) {
                int event = reader.next();

                if (event == XMLStreamConstants.START_ELEMENT && "property".equals(reader.getLocalName())) {
                    String currentId = reader.getAttributeValue(null, "id");
                    String currentName = reader.getAttributeValue(null, "name");

                    if (id.equals(currentId) && name.equals(currentName)) {
                        result = reader.getAttributeValue(null, "value");
                        break;
                    }
                }
            }
            reader.close();
            return result;
        } catch (IOException | XMLStreamException e) {
            log.warn(e);
        }
```

XML의 내용은 이렇습니다.

{% raw %}
```xml

<?xml version="1.0" encoding="UTF-8" standalone="no"?><configuration>
    <property name="LOG_PREFIX" value="access"/>
    <property name="LOG_DIR" value="./logs"/>
    <property name="MAX_FILE_SIZE" value="100"/>
    <property name="MAX_FILE_COUNT" value="10"/>

    <appender class="ch.qos.logback.core.rolling.RollingFileAppender" name="access">
        <file>${LOG_DIR}/${LOG_PREFIX}.log</file>
        <rollingPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy">
            <fileNamePattern>${LOG_DIR}/%d{yyyy/MM/dd}/${LOG_PREFIX}.%i.log</fileNamePattern>
            <maxFileCount>${MAX_FILE_COUNT}</maxFileCount>
            <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
                <maxFileSize>${MAX_FILE_SIZE}MB</maxFileSize>
            </timeBasedFileNamingAndTriggeringPolicy>
        </rollingPolicy>

        <encoder class="net.logstash.logback.encoder.AccessEventCompositeJsonEncoder">
            <providers>
                <pattern>
                    <omitEmptyFields>true</omitEmptyFields>
                    <pattern>
                        {
                        "date": "%date{yyyy-MM-dd HH:mm:ss:SSS}",
                        "remoteAddr": "%a",
                        "request": "%r",
                        "user": "%reqAttribute{userId}",
                        "httpXForwardedFor": "%i{X-Forwarded-For}",
                        "referer": "%i{Referer}",
                        "userAgent": "%i{User-Agent}",
                        "byteSent": "#asLong{%B}",
                        "duration": "#asDouble{%T}",
                        "status": "%s",
                        "contentType": "%responseHeader{Content-Type}"
                        }
                    </pattern>
                </pattern>
            </providers>
        </encoder>
    </appender>

    <appender-ref ref="access"/>

</configuration>

```
{% endraw %}


## 상세 내용

Spring Boot에서는 외부 Tomcat의 server.xml을 직접 수정하는 방식 대신,  내장 Tomcat을 코드로 구성하는 구조를 사용합니다. 기본적인 Access Log 설정은 application.yml이나 logback.xml로 처리할 수 있지만, 런타임에 동적으로 변경하려면 TomcatServletWebServerFactory를 통해  Context Valve(LogbackValve)에 접근해 Appender를 재구성해야 합니다. 다만, logback.xml의 `<configuration scan="true" scanPeriod="30 seconds">` 를 사용해 자동으로 로그 설정을 감지하는 방법도 있지만, 위에서 언급하였듯이, logback을 2개를 관리해야 하거나 하는 특수한 상황에서는 위의 방법이 있습니다.

---

## 관련 문서

- [Logback 공식 문서](http://logback.qos.ch/)
- [Spring Boot Logging](https://spring.io/guides/gs/logging/)
- [Tomcat Valve Documentation](https://tomcat.apache.org/tomcat-9.0-doc/config/valve.html)
