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

In the current project, we are required to use various DBMSs rather than one DBMS. The additional of Tibero Database caused issues.
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
>The reason for the solution below is to handle various JDBC drivers, and some of JDBC drivers don't support connection.getSchema.
In such cases, you can retrieve the metadata using connection.getMetaData, and then use metaData.getTables 
to find the existing table information within the current_schema by inputting the desired tableName as a search condition.   

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
Additionally, If you need to get all schemas, you can use metaData.getSchemas. 
Moreover, you can find the desired table in all schemas connected to the username by using "while(metaData.getSchemas().next())"

Thank you for reading this post on how to retrieve Table Information and Schema Information from metaData.   