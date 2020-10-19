---
title: "安装 Arch Linux"
date: 2020-10-19
lastmod: 2020-10-19
tags: [WSL]
categories: [Linux]
draft: false
---

根据 [Arch Linux Wiki](https://wiki.archlinux.org/) 整理 Arch Linux 的安装。

<!--more-->

## 安装基本系统

参考 [Installation guide](https://wiki.archlinux.org/index.php/Installation_guide)。

### 安装前准备

#### 准备安装介质

下载镜像，并从安装介质启动。

#### 设置键盘布局

我采用默认布局 (美式键盘)。

#### 验证引导模式

```bash
ls /sys/firmware/efi/efivars
```

如果该命令没有报错，说明系统是 UEFI 模式引导的，反之是传统方式引导的。

我的系统是 UEFI 模式引导的。

#### 连接到网络

我是用的有线连接，使用 `ip link` 命令可以查看到对应的网卡 `eth0`。

发现默认没启用这块网卡，用命令 `ip link set eth0 up` 启用它。

测试 `ping archlinux.org` 成功。

#### TODO
