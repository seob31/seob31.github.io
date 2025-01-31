---
layout: post
title: "Jekyll 다국어 지원 적용 방법"
topic: others
categories: [Jekyll]
image: assets/images/blog/others/250129/jekyll.png
tags: [featured]
language: ko
---

오늘은 Jekyll 다국어 지원 적용한 방법에 대해서 공유하려 합니다.   
처음 gitpage를 시작하면서 테마를 선택하게 되는데요. 저는 커스텀하면서 블로그 오픈도 하기 전에 테마를 2번 바꾸게 되었어요.
그렇게 마지막으로 고른 테마가 mundana 인데, 참으로 좋고 잘 꾸며진 테마입니다.  
하지만, 제가 원하는 블로그의 형식은 아니었죠.... 그래서 테마를 살리면서 전체적으로 2 주간 기능 추가하고 커스텀을 하였습니다.

그리고 완성 되었다 하는 순간, 아뿔싸!!!! 한국어와 영어로 포스팅하려고 했는데 kramdown의 tab 지원이 없다는 걸 알았을 때, 다국어에 문제가 생겼습니다.   
해결책을 찾던 중 jekyll-polyglot 등의 플러그인을 통해 해결법이 있었지만, 플러그인하고, config 설정하고, 폴더 구조 변경, 배포 방식 설정 등의 복잡함을 보였습니다.

<br>
사실 개발을 몰랐다면 플러그인을 사용했을 텐데, 개발을 알기에... 다국어만 설정하면 되는데 저걸 다 할거면 플러그인을 왜 하나 생각이 들었습니다.
차라리 플러그인 없이 만들자라는 생각이 들었고, gitpage는 처음이기에 인터넷 서치를 하였습니다. 
플러그인 없이 설정하는 방법이 몇 가지가 있었는데, 현재 제가 커스텀한 테마에 적용하기에는 무리가 있었습니다.

<br>
플러그인 없이 다국어 설정한 글들에서 영감을 얻어 제가 커스텀한 테마에 맞춘 다국어 설정을 만들어 보자였습니다.
**고민 끝에 호출할 페이지만 다국어 처리를 하고 내용물은 include 해서 사용하면, 다국어 처리가 되겠구나 였습니다.
제 생각에 이 방법의 장점은 나름 플러그인 없이 간단히 설정할 수 있다 이고, 단점은 같은 페이지를 2개 만들어 다국어 처리를 해야 한다는 것입니다.**
그리고 지금 방식에서 더 고도화가 가능하다고 생각됩니다. 언어설정 파일을 두고 변환하는 작업을 할 수 있겠다는 점입니다.

기본 개념은 아래와 같습니다. 

![frame](/assets/images/blog/others/250129/frame.png)

**이렇게 하면 page.language의 설정을 header, contents, footer에서 사용할 수 있습니다.**   
  
<br>

### 1. 폴더 구조

---
> 폴더 구조 인데요. 현재 테마에 맞춰 구성하였기에 참고하시기 바랍니다.  
>  
>**- pages (한국어)**  
> ![page_ko](/assets/images/blog/others/250129/pages_ko.png)
>
>**- pages (영어)**  
> ![page_en](/assets/images/blog/others/250129/pages.png)  
> 페이지 폴더는 호출할 페이지를 나타내기 때문에 영어, 한국어 버전 1개씩 작성합니다. 아래의 layouts 폴더에서 적절히 page에 호출해 줍니다.
>
>**- layouts**  
> ![layouts](/assets/images/blog/others/250129/layouts.png)  
> 레이아웃 폴더는 위의 페이지에서 호출되며, 호출한 layout은 아래의 includes 폴더의 내용을 include하여 필요한 부분을 호출합니다.
> 
>**- includes**  
> ![layouts](/assets/images/blog/others/250129/includes.png)
> 
>**- posts**  
> ![layouts](/assets/images/blog/others/250129/posts.png)  
> 포스트는 위의 layouts 폴더나 includes 폴더에서 적절히 호출해 주시면 되겠습니다.  
>
> 포스트 폴더는 게시물도 영어 한국어 2개로 작성해주셔야 합니다.   

<br>

### 2. config 파일의 설정과 각 다국어를 적용할 폴더의 파일들 설정

---

>**_config.yml (설정 부분만)**

>```yml
>defaults:
>  - scope:
>      path: "_posts/en"
>      type: posts
>    values:
>      layout: post
>      permalink: 'en/posts/:title'
>      language: en
>  - scope:
>      path: "_posts/ko"
>      type: posts
>    values:
>      layout: post
>      permalink: 'posts/:title'
>      language: ko
>  
>  
>collections:
>  posts:
>    output: true
>```

<br>

>**pages 폴더의 page들의 다국어 설정**

>```yaml
>---
># 영어
>permalink: "/en/호출 페이지"
>language: en
>---
>```
  
>```yaml
>---
># 한국어 * 페이지는 default로 설정
>permalink: "/호출페이지"
>language: ko
>---
>```

<br>

>**posts 폴더의 post 들 다국어 설정**

>```yaml
>---
># 영어
>language: en
>---
>```
  
>```yaml
>---
>language: ko
>---
>```

<br>

### 3. header의 한국어 / 영어 버튼의 javascript 코드

---

> 이 javascript는 언어 선택 버튼을 클릭했을 경우 페이지의 urn을 재설정 하여 reload하는 로직입니다.  
> 언어 선택 버튼은 제작하시고 아래의 코드를 적용하시면 되겠습니다.  
> **참고로 저는 라디오 버튼으로 제작했기에 javascript 도 라디오로 작성되었습니다.**  

>```javascript
><script>
>  document.addEventListener('DOMContentLoaded', function () {
>  
>    document.querySelectorAll('input[name="language"]').forEach(function (radio) {
>      radio.addEventListener('change', function () {
>        if (this.value === 'en') {
>          if (!window.location.pathname.includes('/en/')) {
>            window.location.href = '/en' + window.location.pathname;
>          }
>        } else if (this.value === 'ko') {
>          if (window.location.pathname.includes('/en/')) {
>            window.location.href = window.location.pathname.replace('/en', '');
>          }
>        }
>      });
>    });
>  });
></script>
>```

<br>

### 4. 다국어 설정의 적절한 코드 적용

---
>```yml
>{% raw %}
> * 페이지 언어설정의 필터를 걸어주는 코드인데요. 저는 게시물 리스트 등의 필요한 곳에 중간중간에 넣어 사용하였습니다.  
> {% assign site_posts = site.posts | where: "language", page.language %}  
>  
> * 페이지 이동 시 페이지의 언어설정을 보고 urn을 변경해주는 역할을 하는데요. 저는 보통 <a>의 href에서 많이 사용했습니다.  
> {% if page.language == 'en' %}/en{% endif %}  
> 예) href="{% if page.language == 'en' %}/en{% endif %}/posts" 
>{% endraw %}
>```

<br>

이상으로 github pages에 다국어를 적용하는 방법을 알아보았습니다.  
감사합니다.