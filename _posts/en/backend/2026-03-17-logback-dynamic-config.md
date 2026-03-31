---
layout: post
title: "Dynamic Logback Configuration and Tomcat Access Log Management"
topic: backend
categories: [java]
image: assets/images/blog/backend/onePic/logback.png
tags: [featured]
language: en
show: true
---

## Overview
This feature dynamically updates Logback settings and manages Tomcat access logs at runtime in a Spring Boot application. If you need to disable logs under specific runtime conditions, or when the main Logback config is already fixed and difficult to change, you can dynamically update log level, file path, and rolling policy in real time.

## Main Features

### 1. Stop logs
Safely stops active access logs.

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

### 2. Restart logs after configuration changes
`Dto logConfig` should contain fields that need to be changed.
The code below dynamically updates log file path, file size, and retention count, then restarts logging.

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
               String logPrefix = "/" + getValueFromXml("path/access-log.xml", logConfigData.getCategory(),
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

// Reads values from logback XML.
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

The XML content is as follows.

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


## Details

In Spring Boot, instead of directly modifying external Tomcat `server.xml`, embedded Tomcat is configured in code. Basic access log settings can be handled with `application.yml` or `logback.xml`, but runtime dynamic updates require accessing `Context Valve` (`LogbackValve`) through `TomcatServletWebServerFactory` and reconfiguring appenders. You can also use `<configuration scan="true" scanPeriod="30 seconds">` for auto-detection, but as mentioned above, in special cases (for example, managing two Logback configs) this programmatic approach is useful.

---

## References

- [Logback Official Documentation](http://logback.qos.ch/)
- [Spring Boot Logging](https://spring.io/guides/gs/logging/)
- [Tomcat Valve Documentation](https://tomcat.apache.org/tomcat-9.0-doc/config/valve.html)
