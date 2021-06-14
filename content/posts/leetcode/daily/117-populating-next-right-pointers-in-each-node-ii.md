---
title: "117. Populating Next Right Pointers in Each Node II"
date: 2021-06-12
lastmod: 2021-06-12
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 117 题](https://leetcode-cn.com/problems/populating-next-right-pointers-in-each-node-ii)的题解。

<!--more-->

## 题目

Given a binary tree

```text
struct Node {
  int val;
  Node *left;
  Node *right;
  Node *next;
}
```

Populate each next pointer to point to its next right node. If there is no next right node, the next pointer should be set to `NULL`.

Initially, all next pointers are set to `NULL`.

**Follow up:**

- You may only use constant extra space.
- Recursive approach is fine, you may assume implicit stack space does not count as extra space for this problem.

**Example 1:**

![Example 1](/images/leetcode/daily/117-populating-next-right-pointers-in-each-node-ii/117_sample.png)

```text
Input: root = [1,2,3,4,5,null,7]
Output: [1,#,2,3,#,4,5,7,#]
Explanation: Given the above binary tree (Figure A), your function should populate each next pointer to point to its next right node, just like in Figure B. The serialized output is in level order as connected by the next pointers, with '#' signifying the end of each level.
```

**Constraints:**

- The number of nodes in the given tree is less than `6000`.
- `-100 <= node.val <= 100`

## 题解

这题是 116 的强化版，思路基本一致，但我这个菜逼还是不会做。

最后用 Golang 的实现如下（抄的题解）：

```go
func connect(root *Node) *Node {
    start := root
    for start != nil {
        var nextStart, last *Node
        handle := func(cur *Node) {
            if cur == nil {
                return
            }
            if nextStart == nil {
                nextStart = cur
            }
            if last != nil {
                last.Next = cur
            }
            last = cur
        }
        for p := start; p != nil; p = p.Next {
            handle(p.Left)
            handle(p.Right)
        }
        start = nextStart
    }
    return root
}
```
