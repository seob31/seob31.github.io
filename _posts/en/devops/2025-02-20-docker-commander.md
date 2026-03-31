---
layout: post
title: "Useful Docker Commands You Can Use Right Away"
topic: devops
categories: [docker]
image: assets/images/blog/devops/docker.png
tags: [featured]
language: en
show: true
---

Hi. Today I want to list Docker commands I frequently used while developing.  
I simply organized commands I personally used a lot at work.

*These commands are written for Red Hat based environments, so adjust commands for your OS if needed. Also, Docker commands are generally executed with root privileges.  
Depending on your version, if `yum` does not work, use `dnf`.*

`[]` is used as a placeholder marker. When you run commands, remove `[]` and input actual values.

---

# Docker Installation

| Command | Description | Note |
|:------------------------------------------------------|:------------------------------------------------------|:------------------------------------------------------|
| yum update | Update packages and update yum-utils to latest version | |
| yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo | Add repository for Docker installation | |
| yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin | Install Docker | You can install only what you need |
| yum remove docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin | Remove Docker | You can remove only what you need |
| docker -v | Check Docker version | |

---

# Docker Service Management

| Command | Description | Note |
|:------------------------------------------------------|:------------------------------------------------------|:------------------------------------------------------|
| systemctl start docker | Start Docker service | |
| systemctl stop docker | Stop Docker service | |
| systemctl restart docker | Restart Docker service | |
| systemctl enable docker | Enable Docker auto-start on boot | |

---

# Docker Image Management

| Command | Description | Note |
|:------------------------------------------------------|:------------------------------------------------------|:------------------------------------------------------|
| docker pull [image-info] | Download Docker image | e.g. `docker pull postgres:latest` |
| docker images | List container images | |
| docker rmi [image-id] | Remove container image | |
| docker commit [container-id] [target-image-id] | Create image from container | |
| docker save -o [file-name] [image-name] | Save image as file | |
| docker load -i [file-name] | Load image from file | |

---

# Docker Container Management

| Command | Description | Note |
|:------------------------------------------------------|:------------------------------------------------------|:------------------------------------------------------|
| docker run hello-world | Create and run Docker hello-world container | For testing |
| docker ps | List running containers | |
| docker ps -a | List all containers | |
| docker inspect [container-name] | Show container information | |
| docker rename [container-name] [new-name] | Rename container | |
| docker start [container-name] | Start container | |
| docker stop [container-name] | Stop container | |
| docker restart [container-name] | Restart container | |
| docker rm [container-name] | Remove container | |

---

# Logs and Status

| Command | Description | Note |
|:------------------------------------------------------|:------------------------------------------------------|:------------------------------------------------------|
| docker logs [container-name] | Check container logs | |
| docker logs -f [container-name] | Tail container logs in real time | |
| docker stats -a | Check status of all containers | |

---

# Container Access

| Command | Description | Note |
|:------------------------------------------------------|:------------------------------------------------------|:------------------------------------------------------|
| docker attach [container-name] | Attach to container | Container also stops when you exit |
| docker exec -it [container-name] /bin/bash | Access container shell | Container keeps running on exit / use `/bin/sh` if no bash |
| docker exec my_container [command] | Run command from outside container | e.g. `docker exec my_container ls /home` |

---

# Docker Network

| Command | Description | Note |
|:------------------------------------------------------|:------------------------------------------------------|:------------------------------------------------------|
| docker network list | Show network list | |
| docker network create [name] | Create network | e.g. `docker network create --gateway 192.10.0.1 --subnet 192.10.0.0/21 con_bridge` |