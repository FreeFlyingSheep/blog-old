---
title: "宏定义中的 `do ... while(0)`"
date: 2020-09-28
lastmod: 2020-09-28
tags: [Linux]
categories: [Tips]
draft: false
---

<!--more-->

## 实例

在内核中经常包括以下种类的宏：

```c
#define ELF_PLAT_INIT(_r, load_addr)    \
    do {                                \
    _r->bx = 0; _r->cx = 0; _r->dx = 0; \
    _r->si = 0; _r->di = 0; _r->bp = 0; \
    _r->ax = 0;                         \
} while (0)
```

## 作用

如果把上面的宏用于 `if` 语句或类似的语言要素，比如：

```c
if (...)
    ELF_PLAT_INIT(...);
```

此时如果不使用 `do ... while(0)` 来封装，就会出现问题，只有宏的第一行是归入 `if` 语句体的，这显然不是我们期望的结果。

使用 `do ... while(0)` 封装，就可以避免这种问题，保证宏的所有内容都被归于 `if` 语句体，而多余的循环语句也会被编译器自动优化掉。
