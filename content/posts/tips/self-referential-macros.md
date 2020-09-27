---
title: "自引用的宏 (Self-Referential Macros)"
date: 2020-09-10
lastmod: 2020-09-10
tags: [C 语言]
categories: [Tips]
draft: false
---

根据 GCC 在线文档的 [Self-Referential Macros](https://gcc.gnu.org/onlinedocs/cpp/Self-Referential-Macros.html#Self-Referential-Macros) 章节整理。

<!--more-->

## 定义

> A self-referential macro is one whose name appears in its definition.

一个自引用的宏是名字出现在其定义中的宏。

## 实例

在代码中，经常看到在枚举类型中穿插自引用的宏定义，比如 `/usr/include/dirent.h` 头文件：

```c
/* File types for `d_type'.  */
enum
  {
    DT_UNKNOWN = 0,
# define DT_UNKNOWN DT_UNKNOWN
    DT_FIFO = 1,
# define DT_FIFO    DT_FIFO
    DT_CHR = 2,
# define DT_CHR     DT_CHR
    DT_DIR = 4,
# define DT_DIR     DT_DIR
    DT_BLK = 6,
# define DT_BLK     DT_BLK
    DT_REG = 8,
# define DT_REG     DT_REG
    DT_LNK = 10,
# define DT_LNK     DT_LNK
    DT_SOCK = 12,
# define DT_SOCK    DT_SOCK
    DT_WHT = 14
# define DT_WHT     DT_WHT
  };
```

## 作用

根据官方文档，此处自引用的作用是对于用 `enum` 定义的数字常量，也可以使用 `#ifdef` 进行预处理。

根据 Stack Overflow 上[相关提问](https://stackoverflow.com/questions/8588649/what-is-the-purpose-of-a-these-define-within-an-enum)的回答，这可能是一个历史遗漏问题，原本的代码采用 `#define` 定义常量，而后续改用 `enum` 定义，为了与先前的代码兼容，额外使用自引用的宏，我倾向于这种观点。
