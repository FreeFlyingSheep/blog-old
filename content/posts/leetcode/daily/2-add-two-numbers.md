---
title: "2. Add Two Numbers"
date: 2021-04-14
lastmod: 2021-04-14
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 2 题](https://leetcode-cn.com/problems/add-two-numbers)的题解。

<!--more-->

## 题目

You are given two **non-empty** linked lists representing two non-negative integers. The digits are stored in **reverse order**, and each of their nodes contains a single digit. Add the two numbers and return the sum as a linked list.

You may assume the two numbers do not contain any leading zero, except the number 0 itself.

**Example 1:**

![Example 1](/images/leetcode/daily/2-add-two-numbers/addtwonumber1.jpg)

```text
Input: l1 = [2,4,3], l2 = [5,6,4]
Output: [7,0,8]
Explanation: 342 + 465 = 807.
```

**Example 2:**

```text
Input: l1 = [0], l2 = [0]
Output: [0]
```

**Example 3:**

```text
Input: l1 = [9,9,9,9,9,9,9], l2 = [9,9,9,9]
Output: [8,9,9,9,0,0,0,1]
```

**Constraints:**

- The number of nodes in each linked list is in the range `[1, 100]`.
- `0 <= Node.val <= 9`
- It is guaranteed that the list represents a number that does not have leading zeros.

## 题解

这题比较简单，一次循环同时遍历两个链表即可。如果 `l1` 不为空，那么加上 `l1.Val`；如果 `l2` 不为空，那么加上 `l2.Val`。如果需要进位 `carry`，那么再加 `1`。直到两个链表都为空，最后检查一下还有没有进位。

`prev` 为空意味着这是头节点，需要给 `res` 赋值，反之要让 `prev.Next` 指向当前结点 `curr`。官方题解和该解法基本一致，官方题解相当于通过 `res` 是否为空来判断是不是头节点。

最后用 Golang 的实现如下：

```go
func addTwoNumbers(l1 *ListNode, l2 *ListNode) *ListNode {
    var res, prev *ListNode
    carry := false
    for l1 != nil || l2 != nil {
        curr := new(ListNode)
        if l1 != nil {
            curr.Val += l1.Val
            l1 = l1.Next
        }
        if l2 != nil {
            curr.Val += l2.Val
            l2 = l2.Next
        }
        if carry {
            curr.Val += 1
            carry = false
        }
        if curr.Val >= 10 {
            carry = true
            curr.Val -= 10
        }
        if prev != nil {
            prev.Next = curr
        } else {
            res = curr
        }
        prev = curr
    }
    if carry {
        curr := new(ListNode)
        curr.Val = 1
        prev.Next = curr
    }
    return res
}
```
