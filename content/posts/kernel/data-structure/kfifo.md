---
title: "内核队列"
date: 2020-10-10
lastmod: 2020-10-10
tags: [Linux 内核, 内核数据结构, 链表]
categories: [Kernel]
draft: false
---

[Linux 内核学习笔记系列](/posts/kernel/kernel)，GCC 扩展语法和内核数据结构部分，简单介绍 Linux 内核队列。

<!--more-->

## 内核队列的使用

内核通用队列的实现称为 `kfifo`。

### 创建队列

创建并初始化一个大小为 `size` 的 `kfifo` (成功则返回 `0`，反之返回一个负数错误码)：

```c
int kfifo_alloc(struct kfifo *fifo, unsigned int size, gfp_t gfp_mask);
```

创建并初始化一个 `kfifo` 对象：

```c
void kfifo_init(struct kfifo *fifo, void *buffer, unsigned int size);
```

静态声明 `kfifo` (不常用)：

```c
DECLARE_KFIFO(name, size);
INIT_KFIFO(name);
```

**以上所有的 `size` 必须为 `2` 的幂。**

### 插入队列数据

```c
unsigned int kfifo_in(struct kfifo *fifo, const void *from, unsigned int len);
```

该函数把 `from` 指针所指的 `len` 字节数据拷贝到 `fifo` 所指的队列中。如果成功，返回推入数据的字节大小。如果队列中的空闲字节小于 `len`，返回值可能小于 `len`，甚至会返回 `0`，这时意味着没有任何数据被推入。

### 摘取队列数据

```c
unsigned int kfifo_out(struct kfifo *fifo, void *to, unsigned int len);
```

该函数从 `fifo` 所指向的队列中拷贝出长度为 `len` 字节的数据到 `to` 所指的缓冲中。如果成功，返回拷贝的数据长度。如果队列中数据大小小于 `len`，则该函数拷贝出的数据必然小于需要的数据大小。

当数据被摘取后，数据就不再存在于队列之中。这是队列操作的常用方式。不过如果仅仅想“偷窥”队列中的数据，而不真想删除它，可以使用下面的方法:

```c
unsigned int kfifo_out_peek(struct kfifo *fifo, void *to, unsigned int len, unsigned offset);
```

该函数和 `kffo_out()` 类似，但出口偏移不增加，而且摘取的数据仍然可被下次 `kfifo_out()` 获得。参数 `offset` 指向队列中的索引位置，如果该参数为 `0`，则读队列头。

### 获取队列长度

获得用于存储 `kfifo` 队列的空间的总体大小：

```c
unsigned int kfifo_size(struct kfifo *fifo);
```

获得 `kfifo` 队列中已推入的数据大小：

```c
unsigned int kfifo_len(struct kfifo *fifo);
```

获得 `kfifo` 队列中还有多少可用空间：

```c
unsigned int kfifo_avail(struct kfifo *fifo);
```

**以上所有函数的返回值以字节为单位。**

判断给定的 `kfifo` 是否为空的，若是则返回非 `0` 值，反之返回 `0`：

```c
int kfifo_is_empty(struct kfifo *fifo);
```

判断给定的 `kfifo` 是否为空的，若是则返回非 `0` 值，反之返回 `0`：

```c
int kfifo_is_full(struct kfifo *fifo);
```

### 重置队列

```c
void kfifo_reset(struct kfifo *fifo);
```

### 撤销队列

若通过 `kfifo_alloc()` 创建的队列，用下面的函数撤销：

```c
void kfifo_free(struct kfifo *fifo);
```

若通过 `kfifo_init()` 创建的队列，需要手动释放相应的内存。

### 队列使用实例

```c
struct kfifo fifo;
int ret;
unsigned int i;
unsigned int val;

// 创建一个大小为 PAGE_SIZE 的队列 fifo
ret = kfifo_alloc(&kifo, PAGE_SIZE, GFP_KERNEL);
if (ret)
    return ret;

// 将 [0,32) 压入到名为 fifo 的 kfifo 中
for(i = 0; i < 32; i++)
    kfifo_in(fifo, &i, sizeof(i));

// 查看队列的第一个元素
ret = kfifo_out_peek(fifo, &val, sizeof(val), 0);
if (ret != sizeof(val))
    return -EINVAL;
printk(KERN_INFO "%u\n", val); // 应该输出 0

// 摘取并打印 kfifo 中的所有元素
while (kfifo_avail(fifo)) {
    ret = kfifo_out(fifo, &val, sizeof(val));
    if (ret != sizeof(val))
        return -EINVAL;
    printk(KERN_INFO "%u\n", val); // 应该按序输出 0 到 31
}
```

## 内核队列的实现

内核队列的实现均位于 `kernel/kfifo.c` 和 `include/linux/kfifo.h`，下面列出常用函数/宏的实现。

### 帮助函数的实现


