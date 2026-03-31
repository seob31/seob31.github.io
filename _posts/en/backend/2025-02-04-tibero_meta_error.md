---
layout: post
title: "getSchema Error in Tibero connection - AbstractMethodError"
topic: backend
categories: [tibero]
# image: assets/images/blog/backend/
tags: [featured]
language: en
show: true
---

Hi, it's very cold with temperatures at -10 in this February morning.
Today, I'd like to share issues that came up while working with DB metadata.

In the current project, we need to support multiple DBMSs instead of only one. The addition of Tibero DB caused an issue.
I think this issue occurs in Tibero JDBC version 5 or 6.
Please see details below.


<br>

### 1. Error

---
It appears Tibero JDBC does not support `getSchema`. So when calling `connection.getSchema()` as shown below,
it should retrieve `current_schema`. But in Tibero, an `AbstractMethodError` occurs.


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
>The reason for the solution below is to handle various JDBC drivers, and some JDBC drivers do not support `connection.getSchema()`.
In such cases, you can use `connection.getMetaData()`, then use `metaData.getTables()`
to find existing table information within `current_schema` by using the target `tableName` as a search condition.

> `metaData.getTables(null, null, tableName, new String[]{"TABLE"})` - (Tibero) This is the query executed.
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
* The code was tested only with Oracle, Tibero, and PostgreSQL. I expect it to work with other DBMSs.


<br>
Additionally, if you need all schemas, you can use `metaData.getSchemas()`.
You can also find the desired table in all schemas available to the connected username by using `while(metaData.getSchemas().next())`.

Thank you for reading this post about retrieving table and schema information from metadata.