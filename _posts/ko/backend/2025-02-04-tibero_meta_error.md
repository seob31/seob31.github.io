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

Tibero의 jdbc에서 getSchema 를 지원하지 않는 것으로 판단이 됩니다. 그래서 아래와 같이 connection.getSchema를 했을 경우
current_schema를 검색하게 되는데요. Tibero의 경우, AbstractMethodError의 에러가 발생하게 됩니다.   


>```java
> // 문제가 됬던 코드
>try (Connection connection = DriverManager.getConnection("url", "username", "password")) {
>        String schema = connection.getSchema();
>} catch (SQLException e) {
>    throw new RuntimeException(e);
>}
>
>```

>Exception Error Message : Handler dispatch failed; nested exception is java.lang.AbstractMethodError: Receiver class com.tmax.tibero.jdbc.TbConnection does not define or inherit an implementation of the resolved method 'abstract java.lang.String getSchema()' of interface java.sql.Connection.   
>
> ![tiberoerror](/assets/images/blog/backend/250204/tiberoError.png)   

<br>

### 2. 변경된 코드
---   

>아래와 같이 해결한 이유는 다양한 jdbc를 사용하는 상황에서 connection.getSchema가 아닌 connection.getMetaData를 가져와
metaData의 getTables로 현재 current_schema에서 찾으려는 tableName을 검색 조건으로 주면 테이블에 대한 정보가 나옵니다.
그 정보에서 현재 검색하려는 테이블의 current_schema의 정보를 가져오는 방법으로 진행하였습니다.   

> metaData.getTables(null, null, tableName, new String[]{"TABLE"}) - (Tibero) 을 했을 경우 동작하는 쿼리입니다.   
>![debug](/assets/images/blog/backend/250204/debug.png)     
>
>```java
> 
>try (Connection connection = DriverManager.getConnection("url", "username", "password")) {
>    
>    DatabaseMetaData metaData = connection.getMetaData();
>    ResultSet table = metaData.getTables(null, null, tableName, new String[]{"TABLE"});
>    if (table.next()) {
>        return table.getString("TABLE_SCHEM");
>    }
>    return null;
>            
>} catch (SQLException e) {
>   throw new RuntimeException("Failed to get schema information", e);
>}
>
>```   
* 해당 코드는 orcle, tibero, postgresql 정도만 테스트했습니다. 테스트한 DBMS외에도 동작할 것으로 예상하고 있습니다.   
   
<br>

추가적으로 모든 스키마를 가져오고 싶을 경우, metaData.getSchemas()를 이용하여 전체를 가져오는 방법이 있으며,
찾고자 하는 스키마의 테이블을 while(metaData.getSchemas().next())를 활용하여 username에 연결되어 있는 스키마의
테이블을 검색하실 수 있습니다.   


이상으로 Java에서 metaData를 이용한 테이블 정보 및 스키마 정보를 호출하는 내용의 포스팅을 마치겠습니다.  