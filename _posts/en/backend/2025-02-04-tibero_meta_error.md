---
layout: post
title: "getSchema Error in Tibero connection - AbstractMethodError"
topic: backend
categories: [tibero]
# image: assets/images/blog/backend/
tags: [featured]
language: en
---

Hi, It's very cold with temperatures at -10 in this February moring.
Today, I'd like to share some issues that came up while working with DB metadata.   

In the current project, we are required to use various DBMSs rather than one DBMS. The additional of Tibero Database hs caused issues.
I think this issue only happens Tibero JDBC version 5 or 6.
For detailed explanations, please see below.


<br>

### 1. Error  

---   
It appears that Tibero JDBC does not support getSchema. So when Calling connection.getSchema as shown below,
It retrieves current_schema. But in the case of Tibero, an AbstractMethodError의 occurs.   


>```java
> // The code that caused the issue.
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

### 2. The changed code.
---   

>아래와 같이 해결한 이유는 다양한 jdbc를 사용하는 상황에서 connection.getSchema가 아닌 connection.getMetaData를 가져와
metaData의 getTables로 현재 current_schema에서 찾으려는 tableName을 검색 조건으로 주면 테이블에 대한 정보가 나옵니다.
그 정보에서 현재 검색하려는 테이블의 current_schema의 정보를 가져오는 방법으로 진행하였습니다.   

> metaData.getTables(null, null, tableName, new String[]{"TABLE"}) - (Tibero) This is the query that operates when executed.   
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
* The code was tested with Oracle, Tibero, and Postgresql only. I expect it to work with other DBMSs.   

   
<br>

추가적으로 모든 스키마를 가져오고 싶을 경우, metaData.getSchemas()를 이용하여 전체를 가져오는 방법이 있으며,
찾고자 하는 스키마의 테이블을 while(metaData.getSchemas().next())를 활용하여 username에 연결되어 있는 스키마의
테이블을 검색하실 수 있습니다.   

Thank you for reading this post on how to retrieve Table Information and Schema Information from metaData.   