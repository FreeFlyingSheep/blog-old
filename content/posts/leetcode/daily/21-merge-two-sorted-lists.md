---
title: "21. Merge Two Sorted Lists"
date: 2021-04-29
lastmod: 2021-04-29
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

力扣（LeetCode）[第 21 题](https://leetcode-cn.com/problems/merge-two-sorted-lists)的题解。

<!--more-->

## 题目

Merge two sorted linked lists and return it as a **sorted** list. The list should be made by splicing together the nodes of the first two lists.

**Example 1:**

![Example 1](/images/leetcode/daily/21-merge-two-sorted-lists/merge_ex1.jpg)

```text
Input: l1 = [1,2,4], l2 = [1,3,4]
Output: [1,1,2,3,4,4]
```

**Example 2:**

```text
Input: l1 = [], l2 = []
Output: []
```

**Example 3:**

```text
Input: l1 = [], l2 = [0]
Output: [0]
```

**Constraints:**

- The number of nodes in both lists is in the range `[0, 50]`.
- `-100 <= Node.val <= 100`
- Both `l1` and `l2` are sorted in **non-decreasing** order.

## 题解

用 Golang 的实现如下：

```go
func mergeTwoLists(l1 *ListNode, l2 *ListNode) *ListNode {
    prev := &ListNode{}
    head := prev
    for l1 != nil || l2 != nil {
        var min int
        if l1 == nil {
            min = l2.Val
            l2 = l2.Next
        } else if l2 == nil {
            min = l1.Val
            l1 = l1.Next
        } else {
            if l1.Val < l2.Val {
                min = l1.Val
                l1 = l1.Next
            } else {
                min = l2.Val
                l2 = l2.Next
            }
        }
        node := &ListNode{min, nil}
        prev.Next = node
        prev = node
    }
    return head.Next
}
```
