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
Spring Boot 애플리케이션에서 Logback 설정을 런타임에 동적으로 수정하고, Tomcat의 Access Log를 관리하는 기능입니다. 로그 레벨, 파일 경로, 롤링 정책 등을 실시간으로 변경할 수 있습니다.

## 주요 기능

### 1. 로그 설정 동적 수정
XML 설정 파일을 직접 수정하여 로그 설정을 변경합니다.

```java
public void editLogConfig(LogConfigDto logConfigData) throws EcrossException {
   try {
       String logType = logConfigData.getLogType();
       String configFilePath = logbackUtils.getConfigPath(logType);
       File xmlFile = new File(configFilePath);

       if (xmlFile.exists()) {
           logbackUtils.modifyXmlLogFile(xmlFile, logConfigData);

           if (LogType.ACCESS.getType().equals(logType)) {
               if (!logConfigData.isEnableLog()) {
                   if (factory.isPresent() && logbackTomcatUtils.isPresent()) {
                       logbackTomcatUtils.get().stopAccessLog(factory.get());
                   }
               } else {
                   if (factory.isPresent() && logbackTomcatUtils.isPresent()) {
                       logbackTomcatUtils.get().modifyAccessLog(factory.get(), logConfigData);
                   }
               }
           }

           if (LogType.INTERFACE.getCategory().equalsIgnoreCase(logType)) {
               logbackUtils.deleteAllLogConfig();
               refreshService.refreshConfigWithYaml("LogConfig.yaml");
           }
       }
   } catch (IOException | JoranException e) {
       throw new EcrossException(EcrossCode.ERR_FETCH, e.getMessage(), true);
   }
}
```

### 2. Access Log 중지
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

### 3. Access Log 설정 변경
로그 파일 경로, 파일 크기, 보관 개수 등을 동적으로 수정합니다.

```java
public void modifyAccessLog(TomcatServletWebServerFactory factory, LogConfigDto logConfigData) {
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
               String logPrefix = "/" + logbackUtils.getValueFromXml(EcrossConsts.ACCESS_LOG_PATH, logConfigData.getCategory(),
                       LogbackUtils.PROP_LOG_PREFIX);
               ((FileAppender<IAccessEvent>) appender).setFile(logConfigData.getLogDir() + logPrefix + ".log");

               RollingPolicy rollingPolicy = appender.getRollingPolicy();
               if (rollingPolicy instanceof LimitedFileCountRollingPolicy) {
                   SizeAndTimeBasedFNATP<?> sizeAndTimeBasedFNATP = (SizeAndTimeBasedFNATP<?>) ((LimitedFileCountRollingPolicy<?>) rollingPolicy).getTimeBasedFileNamingAndTriggeringPolicy();
                   sizeAndTimeBasedFNATP.setMaxFileSize(
                           new FileSize(logConfigData.getMaxFileSize() * FileSize.MB_COEFFICIENT));

                   ((LimitedFileCountRollingPolicy<?>) rollingPolicy).setMaxFileCount(logConfigData.getMaxFileCount());
                   ((LimitedFileCountRollingPolicy<?>) rollingPolicy).setFileNamePattern(
                           logConfigData.getLogDir() + "/%d{yyyy/MM/dd}" + logPrefix + ".%i.log");
               }
               appender.getRollingPolicy().start();
               appender.start();
           });
}
```

## 상세 내용

*상세 내용은 나중에 추가 예정입니다.*

---

## 관련 문서

- [Logback 공식 문서](http://logback.qos.ch/)
- [Spring Boot Logging](https://spring.io/guides/gs/logging/)
- [Tomcat Valve Documentation](https://tomcat.apache.org/tomcat-9.0-doc/config/valve.html)
