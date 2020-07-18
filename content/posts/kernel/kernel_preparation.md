---
title: "阅读 Linux 内核源码的准备工作"
date: 2020-07-17
lastmod: 2020-07-17
tags: [Linux 内核, 准备工作]
categories: [Kernel]
draft: true
--- 

针对 Linux kernel release 2.6.11.12。

<!--more-->

## 伪指令

引用部分来自 *[Using as](https://sourceware.org/binutils/docs-2.34/as/index.html)*。

### `.set push` 和 `.set pop`

> The directives .set push and .set pop may be used to save and restore the current settings for all the options which are controlled by .set. The .set push directive saves the current settings on a stack. The .set pop directive pops the stack and restores the settings.
> These directives can be useful inside an macro which must change an option such as the ISA level or instruction reordering but does not want to change the state of the code which invoked the macro.
> Traditional MIPS assemblers do not support these directives.

大概意思先用 `.set push` 保存汇编器配置，然后执行一些修改 (比如配置 `.set noreorder`)，最后用 `.set pop` 恢复之前的汇编器配置。

### `.comm symbol , length`

> .comm declares a common symbol named symbol. When linking, a common symbol in one object file may be merged with a defined or common symbol of the same name in another object file. If ld does not see a definition for the symbol–just one or more common symbols–then it will allocate length bytes of uninitialized memory. length must be an absolute expression. If ld sees multiple common symbols with the same name, and they do not all have the same size, it will allocate space using the largest size.

在大部分情况下，可以简单理解为定义一个变量，变量名为 `symbol` ，占 `length` 字节。

## 宏定义

### `EXPORT`

include/asm-mips/asm.h:

    /*
    * EXPORT - export definition of symbol
    */
    #define EXPORT(symbol)                  \
            .globl  symbol;                         \
    symbol:

### `NESTED` 和 `END`

include/asm-mips/asm.h:

    /*
    * NESTED - declare nested routine entry point
    */
    #define NESTED(symbol, framesize, rpc)                  \
            .globl  symbol;                         \
            .align  2;                              \
            .type   symbol,@function;               \
            .ent    symbol,0;                       \
    symbol:     .frame  sp, framesize, rpc

    /*
    * END - mark end of function
    */
    #define END(function)                                   \
            .end    function;               \
            .size   function,.-function

### `asmlinkage`

include/linux/linkage.h:

    #include <asm/linkage.h>

    #ifdef __cplusplus
    #define CPP_ASMLINKAGE extern "C"
    #else
    #define CPP_ASMLINKAGE
    #endif

    #ifndef asmlinkage
    #define asmlinkage CPP_ASMLINKAGE
    #endif

include/asm-mips/linkage.h:

    /* Nothing to see here... */

在 MIPS 下，`asmlinkage` 只是为了兼容 `C++`。

### `__init`

include/linux/init.h:

    #define __init __attribute__ ((__section__ (".init.text")))

把函数放到 `.init.text` 段。

### `__acquires` 和 `__releases`

include/linux/compiler.h:

    # define __acquires(x) __attribute__((context(0,1)))
    # define __releases(x) __attribute__((context(1,0)))

给 Sparse 做代码静态检查，用于保证 `__acquires` 和 `__releases` 成对使用。

### `__lockfunc`

include/linux/spinlock.h:

    #define __lockfunc fastcall __attribute__((section(".spinlock.text")))

include/linux/linkage.h:

    #ifndef FASTCALL
    #define FASTCALL(x) x
    #define fastcall
    #endif

include/asm-mips/linkage.h:

    /* Nothing to see here... */

在 MIPS 下，`fastcall` 为空，`__lockfunc` 只是为了把函数放到 `.spinlock.text` 段。
