---
title: "使用 Hugo 搭建个人博客"
date: 2020-09-23
lastmod: 2021-04-13
tags: [Hugo, Github Pages]
categories: [Tips]
draft: false
---

使用 [Hugo](https://gohugo.io/) 配合 [Github Pages](https://pages.github.com/) 搭建静态博客，利用 [Github Actions](https://github.com/features/actions) 自动部署。

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

由于 LoveIt 主题支持 Gitalk，只需要注册一个 GitHub Application (位于 Settings -> Developer settings -> OAuth Apps)，并在 LoveIt 的配置中设置好相应内容即可启用。

## 关联到 Github

使用 `hugo` 命令会生成静态网站，默认在 `public` 文件夹中。需要 Github 展示的是 `public` 文件夹的内容，而不是整个项目的内容。

可以采用子模块的方式管理这两个项目 (生成的 `public` 文件夹下静态网站以及 `Blog` 网站)，将 `public` 文件夹关联到 Github 远程仓库 `<username>.github.io` (`username` 是 Github 账户的用户名)，然后将该项目以子模块的形式添加到本项目 (即 `Blog` 项目)。这样就可以方便地管理这两个项目。

## 设置 Github Pages

在 Github 的 `<username>.github.io` 仓库中设置启用 Github Pages，使用 master 分支以及根路径。

保存后等待 Github 完成相应的构建，即可访问 `https://<username>.github.io`，查看个人博客。注意，有时候博客已经完成构建，但该网址仍然无法访问，Github 完成网址的映射可能需要几分钟甚至数个小时。

## 克隆项目

由于项目带子模块，采用如下方式克隆：

```bash
git clone --recurse-submodules <url>
```

或者：

```bash
git clone <url>
cd <project>
git submodule init
git submodule update
```

后两个命令还可以合并为 `git submodule update --init`。

## 自动化脚本

建立脚本来简化常用的操作。

注意：现在已经可以利用 Github Actions 自动部署了，见 [自动部署](#自动部署)。

### 一键预览

通常运行 `hugo serve` 即可，但以 LoveIt 主题为例，希望启用一些生成环境的功能，使用如下脚本：

```bash
hugo serve --disableFastRender -e production
```

### 一键部署

同时部署 `Blog` 和 `<username>.github.io` 项目：

```bash
echo "Deploying updates to GitHub..."

cd public
git rm -rf . > /dev/null

cd ..
hugo

cd public
git add .

msg="Rebuild site on `date '+%x %X'`"
if [ -n "$*" ]; then
    msg="$*"
fi
git diff-index --quiet HEAD || git commit -m "$msg"

git push origin master

cd ..
git add .
git diff-index --quiet HEAD || git commit -am "$msg"
git push --recurse-submodules=check origin master
```

每次生成静态网站前强制删了了以前的文件，这是为了应对修改了某些博文所在的目录后，原本的目录会残留的问题，目前没想到更好的解决办法。

### 一键更新

使用 `git pull --rebase --recurse-submodules` 命令更新会让子模块位于分离头指针的状态，分别更新它们：

```bash
echo "Updating public..."
cd public
git pull --rebase

echo "Updating LoveIt..."
cd ../themes/LoveIt
git pull --rebase

echo "Updating Blog..."
cd ../
git pull --rebase
```

## 自动部署

本博客现在已经采用自动部署的方式。

### Github Actions 配置

TODO

### Github Pages 配置

TODO

### 依赖自动更新

TODO
