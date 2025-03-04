---
layout: post
title: "How to apply Multilingual support in Jekyll"
topic: others
categories: [Jekyll]
image: assets/images/blog/others/250129/jekyll.png
tags: [featured]
language: en
show: true
---

Hi, Today, I'd like to talk about how I applied Multilingual support to this blog with Jekyll.
First, When starting with Github pages, We typically select a theme. I changed the theme twice during customization before opening it.
The final theme I chose was Mundana, and I think it's turly a well-designed.
However, It's not the type of theme for blog I wanted for my blog. So, I needed to customize this theme while keeping the design and adding features for 2 weeks.  

And just wen I thought it was complete, Oh.... No!! I realized there was an issue with multilingual support because I didn't know Kramdown is not support 'Tab' tag.
Because I was planning to write a post in both Korean and English.   
I found out a solution on the internet, Which was "jekyll-polyglot" plugin. 
The article included details about complexities such as config file settings, folder structure changes, and deployment setup.  

<br>
If I didn't have any development knowledge, I'd like to follow the plugin. 
In my opinion, the purpose of using a plugin is to simplify the setup.
So, I wondered, if I had to set all those things, what's the point of using the plugin?
Alright, let's find another way without using a plugin. I had to for a solution on the internet because it's my first time using Github pages.
There were couple of solutions how to apply multilingual support without plugin, But It was difficult to apply them to the theme I had customized.  

<br>
In the end, my conclusion was to take inspiration from the information I found and "let's handle multilingual setup myself.
**After much consideration, I suddenly realized that if I handle only the pages being called for multilingual setup and use includes for the content, the multilingual setup would work.
In my opinion, the advantage of this is that it allows for a relatively simple setup without the plugin, downside is that you have to create multiple versions of the same page for each language.**
I think it could be possible with further advancements. It means setting up a language configuration file and switching between languages.  


The basic concept is as follows.

![frame](/assets/images/blog/others/250129/frame.png)

**By doing this, the page.language setting can be used in the header, contents, and footer.**
  
<br>

### 1. Folder structure.

---
> I have configured it according to this theme I customized, so please take that into consideration.   
>  
>**- pages (Korean)**  
> ![page_ko](/assets/images/blog/others/250129/pages_ko.png)
>
>**- pages (English)**  
> ![page_en](/assets/images/blog/others/250129/pages.png)  
> 
> The pages folder represents the pages to be called, so you create one version for English and one for Korean. 
> And call the appropriate layout from the layout folder in page.  
>  
>**- layouts**  
> ![layouts](/assets/images/blog/others/250129/layouts.png)  
> The layout in the layout folder is called from the page, and the called layout calls the necessary include file from the includes folder.  
> 
>**- includes**  
> ![layouts](/assets/images/blog/others/250129/includes.png)
> 
>**- posts**  
> ![layouts](/assets/images/blog/others/250129/posts.png)  
> The post in the posts folder is called from the appropriate layout or include file.   
>
> It needs to create 2 posts for Korean and English in the posts folder.  

<br>

### 2. config.yml and each parts of the multilingual settings.

---

>**_config.yml (Only the configured parts)**

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

>**The multilingual settings of page in the pages folder.**

>```yaml
>---
># English
>permalink: "/en/The page to be called"
>language: en
>---
>```
  
>```yaml
>---
># Korean * defualt URL.
>permalink: "/The page to be called"
>language: ko
>---
>```

<br>

>**The multilingual settings of post in the posts folder posts.**

>```yaml
>---
># English
>language: en
>---
>```
  
>```yaml
>---
>language: ko
>---
>```

<br>

### 3. Javascript code for the Korean and English buttons in the header.  

---

> This JavaScript code resets the URL and reloads the page when the Select language button is clicked.  
> Create the select language button and apply the code below.  
> **Note that I created the button with raido buttons, so this code is also written for radio buttons.**  

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

### 4. Appropriate use of code for multilingual settings.  

---
>```yml
>{% raw %}
> * This is the code for applying language settings filters, I used it where necessary, such as the list of posts.  
> {% assign site_posts = site.posts | where: "language", page.language %}  
>  
> * This code switches the URN based on language settings when navigating pages. I mainly used it for the href attribute of <a> tag.  
> {% if page.language == 'en' %}/en{% endif %}  
> Example: href="{% if page.language == 'en' %}/en{% endif %}/posts" 
>{% endraw %}
>```

<br>

This is the end of this post about how to apply multilingual support on GitHub Pages.  
Thank you for reading.