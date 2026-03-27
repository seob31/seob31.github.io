---
layout: page
title: "DB Mata Data 검증 예시"
permalink: /projects/additional/2025-03-17-ESB-EAI-eCross/db/
---

<a href="javascript:history.back()" class="btn btn-outline-success btn-sm">
  ← 뒤로가기
</a>

# DB Mata Data 검증 예시
<br>

## 개요
프로젝트 릴리즈 시 DB Meta Data와 실제 운영 DB 스키마의 정합성을 검증하기 위한 테스트 자동화 구조. Gradle 테스트 설정과 JUnit Tag 기반 실행 전략을 활용하여 SQL 문법 검증과 스키마 검증을 분리하여 안정적인 릴리즈 품질을 확보하였습니다.

<br>
## 핵심 코드 예제
#### Extract Step
```java
if (project.name in releaseAutomation) {
    configure<TestingExtension> {
        suites {
            val test by getting(JvmTestSuite::class) {
                sources {
                    java {
                        setSrcDirs(listOf("src/test/java"))
                    }
                }

                targets {
                    all {
                        testTask.configure {
                            useJUnitPlatform {
                                includeTags("db")
                                includeTags("MetaDataValidation")
                            }
                        }
                    }
                }
            }
        }
    }
}
```
<br>
```java
// SQL 문법 검증
@Slf4j
@Tag("MetaDataValidation")
@TestPropertySource(properties = {"logging.config=classpath:logback.xml", "spring.main.banner-mode=off"})
public class MetaDataValidation {

}

// 스키마 검증
@Slf4j
@Tag("db")
@JdbcTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
@ContextConfiguration(classes = DBvalidation.JdbcOnlyConfig.class)
@TestPropertySource(properties = {"logging.config=classpath:logback.xml", "spring.main.banner-mode=off"})
public class DBvalidation {

}
```
<br>

## 핵심 구조  
 - Gradle JvmTestSuite 기반 테스트 실행 구성  
 - 릴리즈 시점 자동 실행 가능한 테스트 구조  
 - 실제 DB 환경 기반 검증  

<br> 

## 핵심 포인트
- DB Meta Data와 실제 스키마 간 불일치 사전 차단  
- 휴먼 에러 방지  
- 릴리즈 안정성 및 데이터 정합성 확보  
- 필요한 검증만 선택 실행 가능(효율성)

