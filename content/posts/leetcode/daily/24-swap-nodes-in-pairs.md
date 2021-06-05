---
title: "24. Swap Nodes in Pairs"
date: 2021-06-04
lastmod: 2021-06-05
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 15 题](https://leetcode-cn.com/problems/swap-nodes-in-pairs)的题解。

<!--more-->

## 题目

Given a linked list, swap every two adjacent nodes and return its head. You must solve the problem without modifying the values in the list's nodes (i.e., only nodes themselves may be changed.)

**Example 1:**

![Example 1](/images/leetcode/daily/24-swap-nodes-in-pairs/swap_ex1.jpg)

```text
Input: head = [1,2,3,4]
Output: [2,1,4,3]
```

**Example 2:**

```text
Input: head = []
Output: []
```

**Example 3:**

```text
Input: head = [1]
Output: [1]
```

**Constraints:**

- The number of nodes in the list is in the range `[0, 100]`.
- `0 <= Node.val <= 100`

## 题解

用 `swap` 函数交换两个结点，迭代链表所有结点即可，用 Golang 的实现如下：

```go
func swap(head, tail *ListNode) *ListNode {
    head.Next = tail.Next
    tail.Next = head
    return tail
}

func swapPairs(head *ListNode) *ListNode {
    hair := &ListNode{0, head}
    prev, curr := hair, head
    for curr != nil && curr.Next != nil {
        prev.Next = swap(curr, curr.Next)
        prev = curr
        curr = curr.Next
    }
    return hair.Next
}
```
