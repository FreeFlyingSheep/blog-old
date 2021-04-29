---
title: "内核基数树"
date: 2021-04-28
lastmod: 2021-04-29
tags: [Linux 内核, 内核数据结构, 链表]
categories: [Kernel]
draft: false
---

[Linux 内核学习笔记系列](/posts/kernel/kernel)，GCC 扩展语法和内核数据结构部分，简单介绍 Linux 内核基数树。

<!--more-->

## 基数树简介

### 前缀树（字典树）

该部分内容来源于[维基百科](https://zh.wikipedia.org/wiki/Trie)。

>在计算机科学中，trie，又称前缀树或字典树，是一种有序树，用于保存关联数组，其中的键通常是字符串。与二叉查找树不同，键不是直接保存在节点中，而是由节点在树中的位置决定。一个节点的所有子孙都有相同的前缀，也就是这个节点对应的字符串，而根节点对应空字符串。一般情况下，不是所有的节点都有对应的值，只有叶子节点和部分内部节点所对应的键才有相关的值。
>
>在图示中，键标注在节点中，值标注在节点之下。每一个完整的英文单词对应一个特定的整数。Trie可以看作是一个确定有限状态自动机，尽管边上的符号一般是隐含在分支的顺序中的。
>
>键不需要被显式地保存在节点中。图示中标注出完整的单词，只是为了演示trie的原理。
>
>trie中的键通常是字符串，但也可以是其它的结构。trie的算法可以很容易地修改为处理其它结构的有序序列，比如一串数字或者形状的排列。比如，bitwise trie中的键是一串比特，可以用于表示整数或者内存地址。

![前缀树（字典树）](/images/kernel/data-structure/trie.png)

### 基数树

该部分内容来源于[维基百科](https://zh.wikipedia.org/wiki/%E5%9F%BA%E6%95%B0%E6%A0%91)。

>在计算机科学中，基数树（也叫基数特里树或压缩前缀树）是一种数据结构，是一种更节省空间的Trie（前缀树），其中作为唯一子节点的每个节点都与其父节点合并，边既可以表示为元素序列又可以表示为单个元素。因此每个内部节点的子节点数最多为基数树的基数r ，其中r为正整数，x为2的幂，x≥1，这使得基数树更适用于对于较小的集合（尤其是字符串很长的情况下）和有很长相同前缀的字符串集合。

![基数树](/images/kernel/data-structure/patricia_trie.png)

>基数树支持插入、删除、查找操作。查找包括完全匹配、前缀匹配、前驱查找、后继查找。所有这些操作都是O(k)复杂度，其中k是所有字符串中最大的长度。

## 内核基数树的使用

内核红黑树的实现称为 `radix_tree`，头文件为 `include/linux/radix-tree.h`。下面只介绍几个基本的 API 和相关实现。

### 基数树的创建

最简单的方式，直接使用宏创建：

```c
RADIX_TREE(name, gfp_mask);
```

或者，也可以手工创建：

```c
struct radix_tree_root tree;
INIT_RADIX_TREE(&tree, gfp_mask);
```

### 基数树的搜索

```c
void *radix_tree_lookup(struct radix_tree_root *root, unsigned long index);
```

该函数在以 `root` 为根的基数树中查找索引为 `index` 的内容，返回查找的内容的地址（没找到要查找的内容则返回 `NULL`）。

```c
unsigned int radix_tree_gang_lookup(struct radix_tree_root *root, void **results, unsigned long first_index, unsigned int max_items);
```

该函数在以 `root` 为根的基数树中查找非空内容，从索引为 `first_index` 的结点开始，最多查找 `max_items` 个非空内容，查找结果放 `results` 中，返回找到的个数。

### 基数树的插入

```c
int radix_tree_insert(struct radix_tree_root *root, unsigned long index, void *item);
```

该函数将内容 `item` 插入到以 `root` 为根的基数树中索引为 `index` 的地方，插入成功返回 `0`，失败返回错误值。

### 基数树的删除

```c
void *radix_tree_delete(struct radix_tree_root *root, unsigned long index);
```

该函数将索引为 `index` 的内容从以 `root` 为根的基数树中删除，返回删除的内容的地址（要删除的内容不存在则返回 `NULL`）。

## 内核基数树的的实现

TODO

![内核基数树示例](/images/kernel/data-structure/radix-tree.png)
