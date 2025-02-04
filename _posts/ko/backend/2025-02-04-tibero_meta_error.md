---
layout: post
title: "Tibero의 Connection에서 getSchema 에러 - AbstractMethodError"
topic: backend
categories: [tibero]
# image: assets/images/blog/backend/
tags: [featured]
language: ko
---

안녕하세요. 오늘은 2월의 오전 -10도로 엄청 추운 날이네요. 
오늘은 DB 메타 정보를 가지고 작업을 해야 하는 도중에 나왔던 사항을 공유하려 합니다.   

현재 진행하는 프로젝트는 하나의 DB만 사용하는 것이 아닌 DBMS를 다양하게 사용해야 하는 상황에
Tibero DB가 추가되어 문제가 생긴 이슈 입니다. 현 상황은 Tibero jdbc 5와 6버전에서 에서 일어나는 상황 같습니다.
자세한 설명은 아래에서 보시겠습니다.


<br>

### 1. 에러 내용

---
>```java
> // 문제가 됬던 코드
>try (Connection connection = DriverManager.getConnection("url", "username", "password")) {
>        String schema = connection.getSchema();
>} catch (SQLException e) {
>    throw new RuntimeException(e);
>}
>
>```

<br>

>Exception Error Message : Handler dispatch failed; nested exception is java.lang.AbstractMethodError: Receiver class com.tmax.tibero.jdbc.TbConnection does not define or inherit an implementation of the resolved method 'abstract java.lang.String getSchema()' of interface java.sql.Connection.   
>
> ![createProject](/assets/images/blog/backend/250204/tiberoError.png)

<br>


### 2. 변경된 코드

---

>```java
> 
>try (Connection connection = DriverManager.getConnection("url", "username", "password")) {
>            String schema = null;
>
>            try {
>                schema = connection.getSchema();
>            } catch (AbstractMethodError e) {
>                DatabaseMetaData metaData = connection.getMetaData();
>                String currentUser = metaData.getUserName();
>
>                try (ResultSet schemas = metaData.getSchemas()) {
>                    while (schemas.next()) {
>                        String tableSchem = schemas.getString("TABLE_SCHEM");
>                        if (currentUser.equalsIgnoreCase(tableSchem)) {
>                            schema = tableSchem;
>                            break;
>                        }
>                    }
>                }
>            }
>        } catch (SQLException e) {
>            throw new RuntimeException("Failed to get schema information", e);
>        }
>
>```


이상으로 이번 포스팅을 마치겠습니다.  