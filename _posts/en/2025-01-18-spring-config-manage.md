---
layout: post
title: "Unified Management of Spring Configuration Files"
topic: backend
categories: [spring]
image: assets/images/blog/backend/250118/spring-config-manage.jpg
tags: [featured]
language: en
---

I would like to share about centralized management of Spring configuration files.  

While working on projects with many config files, I started wondering: "Is there a way to manage Spring config files more efficiently?"
This curiosity led me to explore better solutions.

As a project progresses, config files like application.yaml, bootstrap.yaml, and xxxx_config.yaml tend to increase unexpectedly as needed.
When configuration values change, you have to open and edit each file one by one, which can be time-consuming and inconvenient.
**I thought, "Wouldn't it be great if we could manage all of this in a single file?"**

So, I searched on Google, but I couldn’t find any posts that matched what I wanted.
I decided to figure it out myself. First, I looked into how the middleware server works when a Spring project runs.
The key point was that **configuration files have a priority order.**

If there are both application.yaml and bootstrap.yaml, bootstrap.yaml is loaded first.
So, even if I use spring.import.config to import a specific config file, I realized that I cannot fully control the settings in bootstrap.yaml and application.yaml.
To solve this, I thought, "What if I load the config file even earlier using the VM option -Dspring.import.config?"
After testing, I found that the file loaded through -Dspring.import.config has a higher priority than both bootstrap.yaml and application.yaml.
Conclusion:
**Even if a config file has a high priority, using -Dspring.import.config in VM options gives it an even higher priority.**


The setup method is as follows.
<br>

### 1. Project Structure

---
> I have simply structured the project as shown in the image below.

> ![createProject](/assets/images/blog/backend/250118/createProject.png)

<br>

### 2. Configuration file settings

---

>**application.yaml**

>```yaml
>spring:
>  application:
>    name: ${project.name}
>    server: ${project.server}
>```

<br>

>**env.yaml**

>```yaml
>project:
>  name: "testProject"
>  server: "Main server"
>```

<br>

### 3. MyProjectApplication Code

---

><small>As you may already know, you can also use the @Value annotation.</small>

>```java
>package com.example.myProject;
>
>import org.springframework.boot.SpringApplication;
>import org.springframework.boot.autoconfigure.SpringBootApplication;
>import org.springframework.context.ApplicationContext;
>import org.springframework.core.env.Environment;
>
>@SpringBootApplication
>public class MyProjectApplication {
>
>	public static void main(String[] args) {
>		ApplicationContext context = SpringApplication.run(MyProjectApplication.class, args);
>		Environment env = context.getEnvironment();
>
>
>		System.out.println("-------------------------------------");
>		System.out.println("application name: "+ env.getProperty("spring.application.name"));
>		System.out.println("application server: "+ env.getProperty("spring.application.server"));
>		System.out.println("-------------------------------------");
>	}
>
>}
>```

<br>

### 4. VM options settings

---

>![configMenu](/assets/images/blog/backend/250118/configMenu.png)

>![config](/assets/images/blog/backend/250118/config.png)

<br>

### 5. Result

---

>![result](/assets/images/blog/backend/250118/result.png)  

If you are using a Config Server, you can use it appropriately as shown above.

That’s the end of this post. 