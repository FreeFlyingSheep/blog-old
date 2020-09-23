---
title: "使用 Hugo 搭建个人博客"
date: 2020-09-23
lastmod: 2020-09-24
tags: [Hugo, Github Pages]
categories: [Tips]
draft: true
---

使用 [Hugo](https://gohugo.io/) 配合 [Github Pages](https://pages.github.com/) 搭建静态博客。

<!--more-->

## 安装 Hugo

### Windows

从 [Hugo Releases](https://github.com/gohugoio/hugo/releases) 页面下载软件压缩包，之后解压到想要的目录，并添加环境变量。

### Linux

在大部分发行版中，直接安装软件包 `hugo` 即可。

## 新建网站

运行以下命令新建一个名为 `Blog` 的网站。

```bash
hugo new site Blog
```

## 使用主题

此处以本人使用的 [LoveIt](https://hugoloveit.com/zh-cn/) 主题为例。

使用如下命令初始化 Git 仓库并添加主题子模块：

```bash
git init
git submodule add https://github.com/dillonzq/LoveIt.git themes/LoveIt
```

主题的配置可以参考相应主题的文档。

## 使用 Gitalk

静态博客不具备评论功能，使用 [Gitalk](https://github.com/gitalk/gitalk/) 实现评论功能。

新建 GitHub Application

## 同步到 Github



## 设置 Github Pages



## 自动化脚本

建立脚本来简化常用的操作。

### 一键预览

### 一键部署

### 一键更新
