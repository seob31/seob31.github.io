---
layout: post
title: "Spring 설정파일 통합 관리"
topic: backend
categories: [spring]
image: assets/images/blog/backend/250118/spring-config-manage.jpg
tags: [featured]
language: ko
---

Spring 설정파일 통합 관리에 대해 공유하려 합니다.   
config 파일이 많은 프로젝트에 참여하다 보니 spring config 파일을 효율적으로 관리할 수 있을까?
라는 의문점에서 시작하게 되었습니다.

프로젝트를 진행하다보면 의도치 않게 필요에 의해 application.yaml, bootstrap.yaml, xxxx_config.yaml 등
config 파일이 늘어나는 경우가 있습니다. 그러다 보면 설정값이 변경되었을 경우, 하나, 하나 config 파일을
눌러 변경을 해야 하는 귀찮음과 시간을 할애해야 하는 상황이 생깁니다. **그 부분을 한 파일에서 관리할 수 있으면 좋겠다.**
라는 생각이 들었습니다.

그래서 구글링해본 결과 제가 원하는 방식의 게시물이 보이지 않았고, 직접 찾기로 했습니다.
먼저, Spring 프로젝트가 실행되면 미들웨어 서버가 어떻한 방식으로 돌아가는지에 대한 것 이었습니다.
**설정 파일에는 우선 순위**가 있다는 것이 키워드였습니다.

applicaton.yaml 과 bootstrap.yaml이 있다면 bootstrap.yaml 먼저 로드되기에 특정 설정파일을 spring.import.config를 해준다 하더라도
bootstrap.yaml 및 applicaton.yaml의 설정을 관리할 없다가 결론이었습니다.
그럼 이보다 먼저 로드가 되어야 하는데 vm option의 -Dspring.import.config를 해보면 어떻까라는
생각이 들었고, 테스트를 해본 결과 우선순위가 높았던 bootstrap.yaml, applicaton.yaml 보다 먼저
로드된다는 것을 알게되어 해결하게 되었습니다.
**즉 결론은 우선순위가 높아도 vm options에 직접 -Dspring.import.config 준다면 더 높은 우선순위를 가진다는 것입니다.**


설정 방법은 아래와 같습니다.  
<br>

### 1. 프로젝트 구성

---
> 간단하게 프로젝트를 아래 그림과 같이 구성했습니다.

> ![createProject](/assets/images/blog/backend/250118/createProject.png)

<br>

### 2. config 파일의 설정

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

### 3. MyProjectApplication 코드

---

><small>이미 아시겟지만 @Value 어노테이션을 사용해도 됩니다.</small>

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

### 4. Vm options의 설정

---

>![configMenu](/assets/images/blog/backend/250118/configMenu.png)

>![config](/assets/images/blog/backend/250118/config.png)

<br>

### 5. 실행 결과

---

>![result](/assets/images/blog/backend/250118/result.png)  

config server를 이용하고 계시다면 위와 같이 적절하게 사용하시면 될 것 같습니다.  
이상으로 이번 포스팅을 마치겠습니다.