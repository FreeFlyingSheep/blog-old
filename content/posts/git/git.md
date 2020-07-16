---
title: "Git"
date: 2020-07-16
lastmod: 2020-07-16
tags: [Git]
categories: [Git]
draft: false
--- 

根据 *[Pro Git (2nd Edition)](https://git-scm.com/book/zh/v2)* (中文版) 整理。

<!--more-->

## Git 基础

### 初次运行 Git 前的配置

    git config --global user.name "FreeFlyingSheep"
    git config --global user.email "fyang.168.hi@163.com"

### 代理配置

#### 设置代理

    git config --global https.proxy "http://127.0.0.1:xxxx"
    git config --global https.proxy "https://127.0.0.1:xxxx"
    git config --global http.proxy "socks5://127.0.0.1:xxxx"
    git config --global https.proxy "socks5://127.0.0.1:xxxx"

#### 取消代理

    git config --global --unset http.proxy
    git config --global --unset https.proxy

### 获取 Git 仓库

#### 在已存在目录中初始化仓库

    cd my_project
    git init

#### 克隆现有的仓库

    git clone <url> [my_name]

### 查看文件状态

    git status

### 查看修改内容

    git diff

`git diff` 本身只显示尚未暂存的改动，而不是自上次提交以来所做的所有改动。

### 跟踪新文件

    git add <file> ...

### 提交更新

    git commit -m '<message>'

### 忽略文件

文件 .gitignore 的格式规范如下：

- 所有空行或者以 `#` 开头的行都会被 Git 忽略
- 可以使用标准的 glob 模式匹配，它会递归地应用在整个工作区中
- 匹配模式可以以 (`/`) 开头防止递归
- 匹配模式可以以 (`/`) 结尾指定目录
- 要忽略指定模式以外的文件或目录，可以在模式前加上叹号 (`!`) 取反

所谓的 glob 模式是指 shell 所使用的简化了的正则表达式：

- 星号 (`*`)匹配零个或多个任意字符；`[abc]` 匹配任何一个列在方括号中的字符 (这个例子要么匹配一个 `a`，要么匹配一个 `b`，要么匹配一个 `c`）
- 问号 (`?`) 只匹配一个任意字符
- 如果在方括号中使用短划线分隔两个字符，表示所有在这两个字符范围内的都可以匹配 (比如 `[0-9]` 表示匹配所有 `0` 到 `9` 的数字)
- 使用两个星号 (`**`) 表示匹配任意中间目录，比如 `a/**/z` 可以匹配 `a/z`、`a/b/z` 或 `a/b/c/z` 等

GitHub 有一个十分详细的针对数十种项目及语言的 [.gitignore 文件列表](https://github.com/github/gitignore)。

在最简单的情况下，一个仓库可能只根目录下有一个 .gitignore 文件，它递归地应用到整个仓库中。 然而，子目录下也可以有额外的 .gitignore 文件。子目录中的 .gitignore 文件中的规则只作用于它所在的目录中。

### 移除文件

    git rm <file> ...

如果要删除之前修改过或已经放到暂存区的文件，则必须使用强制删除选项 `-f`。
另外一种情况是，我们想把文件从 Git 仓库中删除(亦即从暂存区域移除)，但仍然希望保留在当前工作目录中。 换句话说，你想让文件保留在磁盘，但是并不想让 Git 继续跟踪。当你忘记添加 .gitignore 文件，不小心把一个很大的日志文件或一堆 .a 这样的编译生成文件添加到暂存区时，这一做法尤其有用。为达到这一目的，使用 `--cached` 选项。

### 移动文件

    git mv <file_from> <file_to>

### 查看提交历史

    git log
    git log --graph --pretty=oneline --abbrev-commit

### 撤消操作

#### 补上遗漏的文件

有时候我们提交完了才发现漏掉了几个文件没有添加，或者提交信息写错了，此时，可以运行带有 `--amend` 选项的提交命令来重新提交：

    git commit -m "initial commit"
    git add forgotten_file
    git commit --amend

#### 取消暂存的文件

    git reset HEAD <file> ...

#### 撤消对文件的修改

    git checkout -- <file>

请务必记得这是一个危险的命令，你对那个文件在本地的任何修改都会消失—— Git 会用最近提交的版本覆盖掉它。除非你确实清楚不想要对那个文件的本地修改了，否则请不要使用这个命令。

### 远程仓库的使用

#### 查看远程仓库

    git remote -v

#### 添加远程仓库

    git remote add <shortname> <url>

#### 从远程仓库中抓取

    git fetch [<remote>]

这个命令会访问远程仓库，从中拉取所有你还没有的数据。执行完成后，你将会拥有那个远程仓库中所有分支的引用，可以随时合并或查看。
必须注意该命令只会将数据下载到你的本地仓库——它并不会自动合并或修改你当前的工作。当准备好时你必须手动将其合并入你的工作。

#### 从远程仓库中拉取

    git pull [<remote>]

如果你的当前分支设置了跟踪远程分支，那么可以用 `git pull` 命令来自动抓取后合并该远程分支到当前分支。
默认情况下，`git clone` 命令会自动设置本地 master 分支跟踪克隆的远程仓库的 master 分支（或其它名字的默认分支）。运行 `git pull` 通常会从最初克隆的服务器上抓取数据并自动尝试合并到当前所在的分支。

#### 推送到远程仓库

    git push <remote> <branch>

#### 查看某个远程仓库

    git remote show <remote>

#### 远程仓库的重命名

    git remote rename <old> <new>

#### 远程仓库的移除

    git remote remove <remote>

### 标签

轻量标签很像一个不会改变的分支——它只是某个特定提交的引用。
附注标签是存储在 Git 数据库中的一个完整对象，它们是可以被校验的，其中包含打标签者的名字、电子邮件地址、日期时间，此外还有一个标签信息，并且可以使用 GNU Privacy Guard (GPG) 签名并验证。通常会建议创建附注标签，这样你可以拥有以上所有信息。但是如果你只是想用一个临时的标签，或者因为某些原因不想要保存这些信息，那么也可以用轻量标签。

#### 列出标签

    git tag

#### 创建标签

创建附注标签：

    git tag -a <tagname> -m "<message>"

创建轻量标签：

    git tag <tagname>

轻量标签本质上是将提交校验和存储到一个文件中——没有保存任何其他信息。创建轻量标签，不需要使用 -a、-s 或 -m 选项，只需要提供标签名字。

#### 显示标签信息

    git show <tagname>

在附注标签上运行 `git show`，输出会显示打标签者的信息、打标签的日期时间、附注信息，然后显示具体的提交信息。
在轻量标签上运行 `git show`，你不会看到额外的标签信息，命令只会显示出提交信息。

#### 后期打标签

你也可以对过去的提交打标签，只需要在命令的末尾指定提交的校验和 (或部分校验和)。

示例：

    $ git log --pretty=oneline
    15027957951b64cf874c3557a0f3547bd83b3ff6 Merge branch 'experiment'
    a6b4c97498bd301d84096da251c98a07c7723e65 beginning write support
    0d52aaab4479697da7686c15f77a3d64d9165190 one more thing
    6d52a271eda8725415634dd79daabbc4d9b6008e Merge branch 'experiment'
    0b7434d86859cc7b8c3d5e1dddfed66ff742fcbc added a commit function
    4682c3261057305bdd616e23b64b0857d832627b added a todo file
    166ae0c4d3f420721acbb115cc33848dfcc2121a started write support
    9fceb02d0ae598e95dc970b74767f19372d61af8 updated rakefile
    964f16d36dfccde844893cac5b347e7b3d44abbc commit the todo
    8a5cbc430f1a9c3d00faaeffd07798508422908a updated readme
    $ git tag -a v1.2 9fceb02
    $ git tag
    v0.1
    v1.2
    v1.3
    v1.4
    v1.4-lw
    v1.5
    $ git show v1.2
    tag v1.2
    Tagger: Scott Chacon <schacon@gee-mail.com>
    Date: Mon Feb 9 15:32:16 2009 -0800
    version 1.2
    commit 9fceb02d0ae598e95dc970b74767f19372d61af8
    Author: Magnus Chacon <mchacon@gee-mail.com>
    Date: Sun Apr 27 20:43:35 2008 -0700
    updated rakefile
    ...

#### 共享标签

默认情况下，git push 命令并不会传送标签到远程仓库服务器上。在创建完标签后你必须显式地推送标签到共享服务器上。这个过程就像共享远程分支一样——你可以运行 `git push origin <tagname>`。
如果想要一次性推送很多标签，也可以使用带有 `--tags` 选项的 `git push` 命令。这将会把所有不在远程仓库服务器上的标签全部传送到那里。

#### 删除标签

要删除掉你本地仓库上的标签，可以使用命令 `git tag -d <tagname>`。
一种直观的删除远程标签的方式是使用命令 `git push origin --delete <tagname>`。

#### 检出标签

    git checkout <tagname>

### Git 别名

    git config --global alias.<alias> <commond>

例如，为了解决取消暂存文件的易用性问题，可以向 Git 中添加你自己的取消暂存别名：

    git config --global alias.unstage 'reset HEAD --'

这会使下面的两个命令等价：

    git unstage fileA
    git reset HEAD -- fileA

这样看起来更清楚一些。通常也会添加一个 last 命令，像这样：

    git config --global alias.last 'log -1 HEAD'

这样，可以轻松地看到最后一次提交。

## Git 分支

TODO

## Github

### 生成 SSH 公钥

    ssh-keygen -t rsa -C "fyang.168.hi@163.com"

### 添加 SSH 公钥

    cat ~/.ssh/id_rsa.pub

将内容添加到 Github [相应页面](https://github.com/settings/ssh/new)添加公钥。

### 验证

    ssh -T git@github.com

首次使用需要确认并添加主机到本机SSH可信列表。若返回 `Hi FreeFlyingSheep! You've successfully authenticated, but GitHub does not provide shell access.` 内容，则证明添加成功。

## Git 工具

### 贮藏与清理

TODO

### 子模块

TODO
