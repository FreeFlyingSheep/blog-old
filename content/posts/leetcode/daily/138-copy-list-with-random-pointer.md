---
title: "138. Copy List with Random Pointer"
date: 2021-04-13
lastmod: 2021-04-14
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 138 题](https://leetcode-cn.com/problems/copy-list-with-random-pointer)的题解。

<!--more-->

## 题目

A linked list of length `n` is given such that each node contains an additional random pointer, which could point to any node in the list, or `null`.

Construct a [**deep copy**](https://en.wikipedia.org/wiki/Object_copying#Deep_copy) of the list. The deep copy should consist of exactly `n` **brand new** nodes, where each new node has its value set to the value of its corresponding original node. Both the `next` and `random` pointer of the new nodes should point to new nodes in the copied list such that the pointers in the original list and copied list represent the same list state. **None of the pointers in the new list should point to nodes in the original list**.

For example, if there are two nodes `X` and `Y` in the original list, where `X.random --> Y`, then for the corresponding two nodes `x` and `y` in the copied list, `x.random --> y`.

Return _the head of the copied linked list_.

The linked list is represented in the input/output as a list of `n` nodes. Each node is represented as a pair of `[val, random_index]` where:

- `val`: an integer representing `Node.val`
- `random_index`: the index of the node (range from `0` to `n-1`) that the `random` pointer points to, or `null` if it does not point to any node.

Your code will **only** be given the `head` of the original linked list.

**Example 1:**

![Example 1](/images/leetcode/daily/138-copy-list-with-random-pointer/e1.png)

```text
Input: head = [[7,null],[13,0],[11,4],[10,2],[1,0]]
Output: [[7,null],[13,0],[11,4],[10,2],[1,0]]
```

**Example 2:**

![Example 2](/images/leetcode/daily/138-copy-list-with-random-pointer/e2.png)

```text
Input: head = [[1,1],[2,1]]
Output: [[1,1],[2,1]]
```

**Example 3:**

![Example 3](/images/leetcode/daily/138-copy-list-with-random-pointer/e3.png)

```text
Input: head = [[3,null],[3,0],[3,null]]
Output: [[3,null],[3,0],[3,null]]
```

**Example 4:**

```text
Input: head = []
Output: []
Explanation: The given linked list is empty (null pointer), so return null.
```

**Constraints:**

- `0 <= n <= 1000`
- `-10000 <= Node.val <= 10000`
- `Node.random` is `null` or is pointing to some node in the linked list.

## 题解

### 最初解法

遍历链表时需要确定 `Next` 和 `Random` 指针的指向，即需要知道指向的是第几个结点。

于是可以用一个哈希表 `src` 来存储源链表中每个结点对应的位置，用另一个哈希表 `dst` 来存储目标链表中每个位置对应的结点。

现在只需要遍历两次，第一次复制结点的 `Val`， 同时生成 `src` 和 `dst`，第二次根据这两个哈希表来填充 `Next` 和 `Random`。

最后用 Golang 的实现如下：

```go
func copyRandomList(head *Node) *Node {
    var curr *Node
    src := make(map[*Node]int)
    dst := make(map[int]*Node)

    n := 0
    for pos := head; pos != nil; pos = pos.Next {
        src[pos] = n
        curr := new(Node)
        curr.Val = pos.Val
        dst[n] = curr
        n++
    }

    n, curr = 0, dst[0]
    for pos := head; pos != nil; pos = pos.Next {
        n++
        if pos.Random != nil {
            curr.Random = dst[src[pos.Random]]
        }
        curr.Next = dst[n]
        curr = curr.Next
    }
    return dst[0]
}
```

### 优化解法

再次思考这个问题，发现自己傻逼了。 `src` 从 `Node *` 映射到 `int`，然后 `dst` 再从 `int` 映射到 `Node *`，直接从 `src` 的 `Node *` 映射到 `dst` 的 `Node *` 不就完事了嘛！

这时候只需要一个哈希表，把 `Next` 指针的处理放到第一次遍历，注意此时需要单独考虑 `head` 结点为空的情况。

优化后的解法如下：

```go
func copyRandomList(head *Node) *Node {
    if head == nil {
        return nil
    }

    table := make(map[*Node]*Node)
    res := new(Node)
    res.Val = head.Val
    table[head] = res
    prev := res
    for pos := head.Next; pos != nil; pos = pos.Next {
        curr := new(Node)
        curr.Val = pos.Val
        table[pos] = curr
        prev.Next = curr
        prev = curr
    }

    curr := res
    for pos := head; pos != nil; pos = pos.Next {
        if pos.Random != nil {
            curr.Random = table[pos.Random]
        }
        curr = curr.Next
    }
    return res
}
```
