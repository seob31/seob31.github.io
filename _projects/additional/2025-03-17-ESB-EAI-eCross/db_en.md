---
layout: page
title: "DB Metadata Validation Example"
permalink: /projects/additional/2025-03-17-ESB-EAI-eCross/db_en/
---

<a href="javascript:history.back()" class="btn btn-outline-success btn-sm">
  <- Back
</a>

# DB Metadata Validation Example
<br>

## Overview
A test automation structure for validating consistency between DB metadata and actual production DB schema during project releases. By using Gradle test configuration and JUnit Tag-based execution strategy, SQL syntax validation and schema validation were separated to ensure stable release quality.

<br>
## Core Code Example
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
// SQL syntax validation
@Slf4j
@Tag("MetaDataValidation")
@TestPropertySource(properties = {"logging.config=classpath:logback.xml", "spring.main.banner-mode=off"})
public class MetaDataValidation {

}

// Schema validation
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

## Core Structure
 - Gradle JvmTestSuite-based test execution configuration  
 - Test structure that can run automatically at release time  
 - Validation against real DB environments

<br> 

## Key Points
- Prevent mismatch between DB metadata and actual schema in advance  
- Prevent human error  
- Improve release stability and data consistency  
- Allow selective execution of only required validation (efficiency)
