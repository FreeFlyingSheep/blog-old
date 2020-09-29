---
title: "内核链表"
date: 2020-09-28
lastmod: 2020-09-29
tags: [Linux 内核, 内核数据结构, 链表]
categories: [Kernel]
draft: false
---

[Linux 内核学习笔记系列](/posts/kernel/kernel)，GCC 扩展语法和内核数据结构部分，简单介绍 Linux 内核链表。

<!--more-->

## 传统的链表与内核链表

在通常情况下，假设我们需要一个描述狐狸信息的双向链表：

```c
struct fox {
    unsigned long tail_length; /* 尾巴长度，以厘米为单位 */
    unsigned long weight;      /* 重量，以千克为单位 */
    bool is_fantastic;         /* 这只狐狸奇妙吗? */
    struct fox *next;          /* 指向下一只狐狸 */
    struct fox *prev;          /* 指向前一只狐狸 */
};
```

我们会在 `fox` 结构体添加该结构体的指针，这样 `fox` 数据结构 (即链表的节点) 就能被塞入链表。

然后我们针对 `fox` 结构体实现相关的链表操作，比如添加狐狸：

```c
void add_fox(struct fox *list, struct fox *f)
{
    ...
}
```

现在我们又需要一个描述兔子信息的双向链表，自然我们需要定义一个新的结构体：

```c
struct rabbit {
    unsigned long weight;      /* 重量，以千克为单位 */
    bool is_fantastic;         /* 这只兔子奇妙吗? */
    struct rabbit *next;       /* 指向下一只兔子 */
    struct rabbit *prev;       /* 指向前一只兔子 */
};
```

然后我们需要针对 `rabbit` 结构体实现相关的链表操作，比如添加狐狸：

```c
void add_rabbit(struct rabbit *list, struct rabbit *r)
{
    ...
}
```

这时候就有人提出了，我们已经为 `fox` 结构体定义过了相关的操作，但为了 `rabbit` 结构体我们需要再次实现几乎完全一样的功能，这是重复劳动。

我们希望实现一个更加通用的方案，针对链表的操作应该对所有情况都适用 (比如上面的 `fox` 和 `rabbit`)。显然传统的链表是无法解决这一问题的，因而与传统的方式相反，内核把链表节点塞入其他数据结构，实现了一种独特解法。

内核链表是一个“独特”的双向循环链表，下面我们先展示内核链表的用法，再探讨其具体实现。

## 内核链表的用法

内核链表实现了通用的链表操作，仍然以 `fox` 结构体为例，下面展示内核链表的常见用法。

### 定义链表

```c
struct fox {
    unsigned long tail_length; /* 尾巴长度，以厘米为单位 */
    unsigned long weight;      /* 重量，以千克为单位 */
    bool is_fantastic;         /* 这只狐狸奇妙吗? */
    struct list_head list;     /* 所有 fox 结构体形成链表 */
};
```

### 初始化链表

#### 动态初始化

```c
struct fox *f;
f = kmalloc(sizeof(*f), GFP_KERNEL);
f->tail_length = 40;
f->weight = 6;
f->is_fantastic = false;
INIT_LIST_HEAD(&f->list);
```

#### 静态初始化

```c
struct fox f = {
    .tail_length = 40,
    .weight = 6,
    .list = LIST_HEAD_INIT(f.list),
};
```

#### 定义链表头

```c
static LIST_HEAD(fox_list);
```

### 添加节点

#### 在头部添加节点

```c
list_add(&f->list, &fox_list);
```

#### 在尾部添加节点

```c
list_add_tail(&f->list, &fox_list);
```

### 删除节点

```c
list_del(&f->list);
```

### 遍历链表

#### 在遍历时不会改变链表项

```c
struct fox *f;
list_for_each_entry(f, &fox_list, list) {
    ...
}
```

#### 在遍历时会改变链表项 (如遍历时删除节点)

```c
struct fox *f, *next;
list_for_each_entry_safe(f, next, &fox_list, list) {
    ...
}
```

## 内核链表的实现

所有内核链表的实现均位于 `include/linux/list.h`。

### 链表结构体的实现

```c
struct list_head {
    struct list_head *next, *prev;
};
```

### 初始化链表的实现

```c
#define LIST_HEAD_INIT(name) { &(name), &(name) }

#define LIST_HEAD(name) \
    struct list_head name = LIST_HEAD_INIT(name)

static inline void INIT_LIST_HEAD(struct list_head *list)
{
    list->next = list;
    list->prev = list;
}
```

### 添加节点的实现

TODO
