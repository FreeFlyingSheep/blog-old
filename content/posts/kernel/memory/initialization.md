---
title: "内存管理初始化"
date: 2021-04-26
lastmod: 2021-05-14
tags: [Linux 内核, 内存管理, 内存管理初始化]
categories: [Kernel]
draft: false
---

[Linux 内核学习笔记系列](/posts/kernel/kernel)，内存管理部分，简单介绍内存管理初始化。

<!--more-->

## 内存管理初始化简介

体系结构相关的部分只考虑 x86-32 架构。

初始化相关的操作总是从 `start_kernel()` 开始看起，与内存管理初始化相关的流程如下（图片来源于 PLKA）：

![`start_kernel()`](images/kernel/memory/start_kernel.png)

`start_kernel()` 函数位于 `init/main.c`。

## 体系结构相关部分的初始化

体系结构相关部分的初始化的流程如下（图片来源于 PLKA）：

![`setup_arch()`](images/kernel/memory/setup_arch.png)

`setup_arch()` 函数位于 `arch/x86/kernel/setup.c`。

### `machine_specific_memory_setup()`

或许是内核版本不同，这部分代码可能相差比较大，以至于直接搜索都找不到 `machine_specific_memory_setup()` 函数。

x86-32 架构使用 BIOS 的 e820 功能来探测物理内存。

在 `arch/x86/kernel/e820.c` 中，定义了 `char *__init default_machine_specific_memory_setup(void)` 函数，这个函数在 `arch/x86/kernel/x86_init.c` 中被赋值给了 `resources.memory_setup`：

```c
/*
 * The platform setup functions are preset with the default functions
 * for standard PC hardware.
 */
struct x86_init_ops x86_init __initdata = {

    .resources = {
        .probe_roms         = x86_init_noop,
        .reserve_resources  = reserve_standard_io_resources,
        .memory_setup       = default_machine_specific_memory_setup,
    },
    ...
```

之后在 `setup_memory_map()` 函数中被调用，而 `setup_memory_map()` 函数在 `setup_arch()` 中被调用。

`arch/x86/kernel/e820.c`：

```c
void __init setup_memory_map(void)
{
    char *who;

    who = x86_init.resources.memory_setup();
    memcpy(&e820_saved, &e820, sizeof(struct e820map));
    printk(KERN_INFO "BIOS-provided physical RAM map:\n");
e820_print_map(who);
}
```

## 体系结构无关部分的初始化

TODO

## 启动期间的内存管理

TODO
