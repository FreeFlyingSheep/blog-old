---
title: "146. LRU Cache"
date: 2021-04-19
lastmod: 2021-04-20
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 146 题](https://leetcode-cn.com/problems/lru-cache)的题解。

<!--more-->

## 题目

Design a data structure that follows the constraints of a **[Least Recently Used (LRU) cache](https://en.wikipedia.org/wiki/Cache_replacement_policies#LRU)**.

Implement the `LRUCache` class:

- `LRUCache(int capacity)` Initialize the LRU cache with **positive** size `capacity`.
- `int get(int key)` Return the value of the `key` if the key exists, otherwise return `-1`.
- `void put(int key, int value)` Update the value of the `key` if the `key` exists. Otherwise, add the `key-value` pair to the cache. If the number of keys exceeds the `capacity` from this operation, **evict** the least recently used key.

**Follow up:**  
Could you do `get` and `put` in `O(1)` time complexity?

**Example 1:**

```text
Input
["LRUCache", "put", "put", "get", "put", "get", "put", "get", "get", "get"]
[[2], [1, 1], [2, 2], [1], [3, 3], [2], [4, 4], [1], [3], [4]]
Output
[null, null, null, 1, null, -1, null, -1, 3, 4]

Explanation
LRUCache lRUCache = new LRUCache(2);
lRUCache.put(1, 1); // cache is {1=1}
lRUCache.put(2, 2); // cache is {1=1, 2=2}
lRUCache.get(1);    // return 1
lRUCache.put(3, 3); // LRU key was 2, evicts key 2, cache is {1=1, 3=3}
lRUCache.get(2);    // returns -1 (not found)
lRUCache.put(4, 4); // LRU key was 1, evicts key 1, cache is {4=4, 3=3}
lRUCache.get(1);    // return -1 (not found)
lRUCache.get(3);    // return 3
lRUCache.get(4);    // return 4
```

**Constraints:**

- `1 <= capacity <= 3000`
- `0 <= key <= 3000`
- `0 <= value <= 104`
- At most `3 * 104` calls will be made to `get` and `put`.

## 题解

为了做到时间复杂度 `O(1)`，要借助一个哈希表，一个双向链表。

哈希表用于查找元素，双向链表用于快速移动元素。

这里采用了双向循环链表，链表结点必须包含 `key`，因为在删除时需要 `key` 来定位。

剩下的就是要注意每次 `Get` 和 `Put` 后要更新链表，把命中的放到链表头。

最后用 Golang 的实现如下：

```go
type node struct {
    key   int
    value int
    prev  *node
    next  *node
}

type LRUCache struct {
    capacity int
    cache    map[int]*node
    head     *node
}

func Constructor(capacity int) LRUCache {
    return LRUCache{
        capacity: capacity,
        cache:    map[int]*node{},
    }
}

func (this *LRUCache) addNode(n *node) {
    tail := this.head.prev
    n.prev = tail
    n.next = this.head
    tail.next = n
    this.head.prev = n
    this.head = n
}

func (this *LRUCache) deleteNode(n *node) {
    n.prev.next = n.next
    n.next.prev = n.prev
}

func (this *LRUCache) moveNode(n *node) {
    if this.head != n {
        this.deleteNode(n)
        this.addNode(n)
    }
}

func (this *LRUCache) Get(key int) int {
    n, ok := this.cache[key]
    if !ok {
        return -1
    }

    this.moveNode(n)
    return n.value
}

func (this *LRUCache) Put(key int, value int) {
    if n, ok := this.cache[key]; ok {
        this.moveNode(n)
        n.value = value
        return
    }

    n := &node{
        key:   key,
        value: value,
    }
    if len(this.cache) == 0 {
        n.prev = n
        n.next = n
        this.head = n
    } else {
        this.addNode(n)
    }
    this.cache[key] = n

    if len(this.cache) > this.capacity {
        tail := this.head.prev
        this.deleteNode(tail)
        delete(this.cache, tail.key)
    }
}
```
