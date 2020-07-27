---
title: "Linux 内存管理 (补充内容)"
date: 2020-07-27
lastmod: 2020-07-27
tags: [Linux 内核, 内存管理]
categories: [Kernel]
draft: false
---

根据《深入理解 Linux 内核》(第三版) 和《Linux 内核设计与实现》(原书第 3 版) 内存管理部分的整理和补充，补充介绍前面笔记未涉及的内容。代码部分基于 Linux kernel release 2.6.11.12。“TODO” 部分等后续工作中遇到再填坑 (鸽了)。

<!--more-->

## 高端内存页框的内存映射

TODO

## 内存池

TODO

## slub 分配器

slub 分配器逐渐取代了 slab 分配器，成为默认的内存分配器。

TODO

## 非连续内存区管理

TODO

## 分配函数的选择

## 内存管理相关函数调用关系

分配连续内存的函数调用关系大致如下：

![分配连续内存的函数调用关系](/images/kernel/memory/alloc_memory.png)

释放连续内存的函数调用关系大致如下：

![释放连续内存的函数调用关系](/images/kernel/memory/free_memory.png)
