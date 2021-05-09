---
title: "206. Reverse Linked List"
date: 2021-05-09
lastmod: 2021-05-09
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

力扣（LeetCode）[第 206 题](https://leetcode-cn.com/problems/reverse-linked-lists)的题解。

<!--more-->

## 题目

Given the `head` of a singly linked list, reverse the list, and return _the reversed list_.

**Example 1:**

![Example 1](/images/leetcode/daily/206-reverse-linked-list/rev1ex1.jpg)

```text
Input: head = [1,2,3,4,5]
Output: [5,4,3,2,1]
```

**Example 2:**

![Example 2](/images/leetcode/daily/206-reverse-linked-list/rev1ex2.jpg)

```text
Input: head = [1,2]
Output: [2,1]
```

**Example 3:**

```text
Input: head = []
Output: []
```

**Constraints:**

- The number of nodes in the list is the range `[0, 5000]`.
- `-5000 <= Node.val <= 5000`

**Follow up:** A linked list can be reversed either iteratively or recursively. Could you implement both?

## 解法一（迭代）

迭代法比较简单，用 Golang 的实现如下：

```go
func reverseList(head *ListNode) *ListNode {
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
```

## 解法二（递归）

递归结束条件应该是只剩下一个结点或者没有结点，此时直接返回链表头部（`head`）。

当有多于一个结点时，把除头结点外的链表倒转（`head.Next` 开始的链表），然后再把头结点拼接到逆序的链表后面。

因为原本的链表头结点（`head.Next`）在倒转后是链表尾部，所以此时正好把头结点拼接到这之后（`head.Next.Next = head`）。

注意拼接完成后 `head.Next` 是链表尾部，要赋值空值（`head.Next = nil`）；而链表头部通过递归返回值来记录。

最后用 Golang 的实现如下：

```go
func reverseList(head *ListNode) *ListNode {
    if head != nil && head.Next != nil {
        node := reverseList(head.Next)
        head.Next.Next = head
        head.Next = nil
        head = node
    }
    return head
}
```
