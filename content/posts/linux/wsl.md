---
title: "安装 WSL"
date: 2020-09-21
lastmod: 2020-09-21
tags: [WSL]
categories: [Linux]
draft: false
---

根据微软官方文档[适用于 Linux 的 Windows 子系统安装指南 (Windows 10)](https://docs.microsoft.com/zh-cn/windows/wsl/install-win10) 整理。

<!--more-->

## WSL 1 和 WSL 2 的选择

两者的比较可以参考微软官方文档[比较 WSL 1 和 WSL 2](https://docs.microsoft.com/zh-cn/windows/wsl/compare-versions)。

个人推荐优先选择 WSL 2，若发现 WSL 2 和其他软件冲突，再回退到 WSL 1。

## 启用 WSL 1

以管理员身份打开 PowerShell 并运行：

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

重启计算机即可。

## 启用 WSL 2

在[启用 WSL 1](#启用-wsl-1)的基础上，不要重启，而是以管理员身份打开 PowerShell 并运行：

```powershell
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

现在重启计算机。

## 将 WSL 2 设置为默认版本

以管理员的身份打开 PowerShell 并运行：

```powershell
wsl --set-default-version 2
```

## 从 WSL 2 回到 WSL 1

当 WSL 2 和其他软件冲突，需要关闭相关功能时，以管理员的身份打开 PowerShell 并运行：

```powershell
wsl --set-default-version 1
dism.exe /online /disable-feature /featurename:VirtualMachinePlatform
```

重启计算机。

## 关闭 WSL 1

若开启了 WSL 2，先[从 WSL 2 回到 WSL 1](#从-wsl-2-回到-wsl-1)，跳过重启。

以管理员的身份打开 PowerShell 并运行：

```powershell
dism.exe /online /disable-feature /featurename:Microsoft-Windows-Subsystem-Linux
```

现在重启计算机。

## 安装 Linux 发行版

在应用商店选择想要安装的发行版即可。个人推荐在 WSL 1 下使用 Debian，在 WSL 2 下使用 Ubuntu 或者 Debian。

## 安装 Windows Terminal

在应用商店选择安装 Windows Terminal。

若想把 WSL 设为默认启动的终端，将 `defaultProfile` 设置为 WSL 的 `guid`，默认为 PowerShell。

在 `profiles` 的 `defaults` 中加入通用的配置，如：

```json
"fontFace": "Jetbrains Mono",
"fontSize": 14,
"colorScheme": "idleToes"
```

若使用自定义主题，需要在 `schemes` 中加入与 `colorScheme` 对应的颜色主题配置：

```json
{
    "name": "idleToes",
    "black": "#323232",
    "red": "#d25252",
    "green": "#7fe173",
    "yellow": "#ffc66d",
    "blue": "#4099ff",
    "purple": "#f680ff",
    "cyan": "#bed6ff",
    "white": "#eeeeec",
    "brightBlack": "#535353",
    "brightRed": "#f07070",
    "brightGreen": "#9dff91",
    "brightYellow": "#ffe48b",
    "brightBlue": "#5eb7f7",
    "brightPurple": "#ff9dff",
    "brightCyan": "#dcf4ff",
    "brightWhite": "#ffffff",
    "background": "#323232",
    "foreground": "#ffffff"
}
```

更多颜色主题可以参考 <https://windowsterminalthemes.dev/>。

如果希望打开终端时路径是家目录，将 WSL 对应的 `source` 改为 `commandline`，并添加 `startingDirectory`，以 Ubuntu 20.04 为例，本人的家目录是 `/home/fyang`，修改配置如下：

```json
// "source": "Windows.Terminal.Wsl"
"commandline": "ubuntu2004",
"startingDirectory": "/home/fyang"
```
