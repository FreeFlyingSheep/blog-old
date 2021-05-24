---
title: "445. Add Two Numbers II"
date: 2021-05-24
lastmod: 2021-05-24
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 445 题](https://leetcode-cn.com/problems/add-two-numbers-ii)的题解。

<!--more-->

## 题目

You are given two **non-empty** linked lists representing two non-negative integers. The most significant digit comes first and each of their nodes contains a single digit. Add the two numbers and return the sum as a linked list.

You may assume the two numbers do not contain any leading zero, except the number 0 itself.

**Example 1:**

![Example 1](/images/leetcode/daily/445-add-two-numbers-ii/sumii-linked-list.jpg)

```text
Input: l1 = [7,2,4,3], l2 = [5,6,4]
Output: [7,8,0,7]
```

**Example 2:**

```text
Input: l1 = [2,4,3], l2 = [5,6,4]
Output: [8,0,7]
```

**Example 3:**

```text
Input: l1 = [0], l2 = [0]
Output: [0]
```

**Constraints:**

- The number of nodes in each linked list is in the range `[1, 100]`.
- `0 <= Node.val <= 9`
- It is guaranteed that the list represents a number that does not have leading zeros.

**Follow up:** Could you solve it without reversing the input lists?

## 解法一（倒置链表）

因为已经做过两数相加，所以最容易想到的就是先倒置两个链表，求出和，再把结果链表倒置。

最后用 Golang 的实现如下：

```go
func reverse(head *ListNode) *ListNode {
    var prev *ListNode
    curr := head
    for curr != nil {
        next := curr.Next
        curr.Next = prev
        prev = curr
        curr = next
    }
    return prev
}

func addTwoNumbers(l1 *ListNode, l2 *ListNode) *ListNode {
    l1 = reverse(l1)
    l2 = reverse(l2)
    hair := &ListNode{0, nil}
    l3 := hair
    count := 0
    for l1 != nil || l2 != nil {
        value := 0
        if l1 != nil {
            value += l1.Val
            l1 = l1.Next
        }
        if l2 != nil {
            value += l2.Val
            l2 = l2.Next
        }
        value += count
        count = value / 10
        value = value % 10
        l3.Next = &ListNode{value, nil}
        l3 = l3.Next
    }
    if count > 0 {
        l3.Next = &ListNode{count, nil}
    }
    return reverse(hair.Next)
}
```

## 解法二（栈）

由于是倒着求和，所以能联想到用栈来存储两个链表。

再思考一下，解法一中倒置结果链表是多余的，我们直接倒着生成结果链表就行了。

最后用 Golang 的实现如下：

```go
func addTwoNumbers(l1 *ListNode, l2 *ListNode) *ListNode {
    s1, s2 := []int{}, []int{}
    for l1 != nil {
        s1 = append(s1, l1.Val)
        l1 = l1.Next
    }
    for l2 != nil {
        s2 = append(s2, l2.Val)
        l2 = l2.Next
    }
    var prev *ListNode
    count := 0
    i1, i2 := len(s1)-1, len(s2)-1
    for i1 >= 0 || i2 >= 0 || count > 0 {
        value := 0
        if i1 >= 0 {
            value += s1[i1]
            i1--
        }
        if i2 >= 0 {
            value += s2[i2]
            i2--
        }
        value += count
        count = value / 10
        value = value % 10
        prev = &ListNode{value, prev}
    }
    return prev
}
```
