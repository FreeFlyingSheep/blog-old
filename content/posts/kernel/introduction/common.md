---
title: "Linux 内核常见函数/宏"
date: 2020-10-14
lastmod: 2020-10-14
tags: [Linux 内核, 内核简介]
categories: [Kernel]
draft: false
---

[Linux 内核学习笔记系列](/posts/kernel/kernel)，内核简介部分，简单介绍 Linux 内核常见的函数及其作用，具体实现将在后续笔记记录。

<!--more-->

## 内核函数库

显然，在编写内核时，不能使用 C 标准库。内核实现了自己的函数库，位于名为 `lib` 的目录下 (对于 `x86` 平台，内核函数库包括 `lib` 和 `arch/x86/lib` 目录)。

内核函数库和 C 标准库中不少函数的功能是一致的，对于这部分函数，我就不介绍了。

## 常见函数/宏

### 比较大小

`include/linux/kernel.h`：

```c
/*
 * min()/max()/clamp() macros that also do
 * strict type-checking.. See the
 * "unnecessary" pointer comparison.
 */
#define min(x, y) ({                      \
    typeof(x) _min1 = (x);                \
    typeof(y) _min2 = (y);                \
    (void) (&_min1 == &_min2);            \
    _min1 < _min2 ? _min1 : _min2; })

#define max(x, y) ({                      \
    typeof(x) _max1 = (x);                \
    typeof(y) _max2 = (y);                \
    (void) (&_max1 == &_max2);            \
    _max1 > _max2 ? _max1 : _max2; })

/*
 * ..and if you can't take the strict
 * types, you can specify one yourself.
 *
 * Or not use min/max/clamp at all, of course.
 */
#define min_t(type, x, y) ({              \
    type __min1 = (x);                    \
    type __min2 = (y);                    \
    __min1 < __min2 ? __min1: __min2; })

#define max_t(type, x, y) ({              \
    type __max1 = (x);                    \
    type __max2 = (y);                    \
    __max1 > __max2 ? __max1: __max2; })
```

### 内存分配

```c
void *kmalloc(size_t size, gfp_t flags);
void kfree(const void *)
```

这两个函数类似于标准库函数 `malloc()` 和 `free()`，其中 `flags` 表示分配标志，在 [Linux 内存管理 (基础部分)](/posts/kernel/memory/basis.md)中介绍。

### 输出信息

```c
int printk(const char *fmt, ...);
```

该函数类似于标准库函数的 `printf()`，但使用时可以在字符串前面加上日志级别，如 `printk(KERN_ERR "bad value %d\n", value);`。如果不指定日志级别，默认是 `KERN_WARNING`，但可能受其他因素影响，最好手动指定。

日志级别定义于 `include/linux/kernel.h`：

```c
#define KERN_EMERG   "<0>" /* system is unusable               */
#define KERN_ALERT   "<1>" /* action must be taken immediately */
#define KERN_CRIT    "<2>" /* critical conditions              */
#define KERN_ERR     "<3>" /* error conditions                 */
#define KERN_WARNING "<4>" /* warning conditions               */
#define KERN_NOTICE  "<5>" /* normal but significant condition */
#define KERN_INFO    "<6>" /* informational                    */
#define KERN_DEBUG   "<7>" /* debug-level messages             */
```
