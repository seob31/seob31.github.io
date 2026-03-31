---
layout: post
title: "Useful Linux Commands You Can Use Right Away"
topic: devops
categories: [linux]
image: assets/images/blog/devops/linux.jpg
tags: [featured]
language: en
show: true
---

Hi. Today I want to list Linux commands I frequently use while developing.  
I simply organized commands I personally used a lot at work.

`[]` is used as a placeholder marker. When you run commands, remove `[]` and input actual values.

| Command | Description | Note |
|:------------|:------------|:------------|
| cd [path] | Move to path | |
| cd ~ | Move to home path | |
| cd / | Move to root path | |
| ll or ls | View file list (Red Hat family) | |
| ls -al | View all files | |
| pwd | Show current path | |
| mkdir [folder-name] | Create folder | |
| rmdir [folder-name] | Remove folder (folder must be empty) | |
| rm -rf [folder-name] | Force remove folder including contents | |
| rm [file-name] | Remove file | |
| ln -s [file-name] | Create symbolic link | |
| touch [file-name] | Create file | |
| cp [source-file] [target-path] | Copy file | |
| cp -r [source-path] [target-path] | Copy subfolders and files recursively | |
| mv [target] [destination] | Move folder/file / `mv [file] [new-file]` can rename file | |
| cat [file] | Show file contents | |
| cat [content] > [file-name] | Write input content to file | |
| su | Login as root | |
| sudo [command] | Run command with root-like permission | |
| who | Show logged-in users | |
| history | Show command history | |
| top | Show process information | |
| uname | Show current OS information | |
| df -h | Show disk usage | |
| find [path] -name [target or option] | Find folders/files by name | e.g. `find / -name *.jpg`: find all jpg files |
| ps -ef `|` grep java | Show running java process list and info | |
| kill [pid] | Terminate process by pid. If needed, use `kill -9 pid` | |
| systemctl start [service] | Start service | |
| systemctl restart [service] | Restart service | |
| systemctl stop [service] | Stop service | |
| systemctl enable [service] | Enable service at boot | |
| systemctl disable [service] | Disable service | |
| systemctl status [service] | Show service status | |
| systemctl daemon-reload | Reload system daemon (used when systemctl has issues) | |
| vi ~/.bash_profile -> alias ll="ls" -> source ~/.bash_profile | Register alias | Install `vi` if unavailable |
| ping [ip] | Check network connectivity to ip | |
| netstat -an `|` grep [port] | Find port in use | Install `netstat` if unavailable |
| netstat -nlpt | Show TCP listening ports and programs | |
|=====
{: class="articleTable"}

<br>

|:------------|:----------| 
| chown [owner:group] [file-or-directory] | Change file/directory owner. |
| chmod 777 [file-or-directory] | Change file/directory permissions (777: full permissions). |
| owner / group / other  | Owner / Group / Others |
| R W X / R W X / R W X  | R(read)-4 / W(write)-2 / X(execute)-1  *[sum of RWX: 7]* |
|=====
{: class="articleTable"}
* When using `chmod` and `chown`, I often needed to apply changes to subfolders/files too, so I frequently used `chmod -r 751 [directory]`.

That is all for this Linux command summary.
