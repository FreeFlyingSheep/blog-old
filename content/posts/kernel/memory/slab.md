---
title: "Linux 内存管理 (slab 分配器)"
date: 2020-07-23
lastmod: 2020-07-23
tags: [Linux 内核, 内存管理, slab 分配器]
categories: [Kernel]
draft: true
---

根据《深入理解 Linux 内核》(第三版) 和《Linux 内核设计与实现》(原书第 3 版) 内存管理部分的整理和补充，具体介绍 slab 分配器。代码部分基于 Linux kernel release 2.6.11.12，我只关心关键代码，涉及的诸多其他函数、宏等，只要不影响阅读，就不再进行展开 (真全部展开就没法阅读了)。

<!--more-->

TODO
