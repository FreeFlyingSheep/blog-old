---
title: "25. Reverse Nodes in k-Group"
date: 2021-05-20
lastmod: 2021-05-20
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 25 题](https://leetcode-cn.com/problems/reverse-nodes-in-k-group)的题解。

<!--more-->

## 题目

Given a linked list, reverse the nodes of a linked list _k_ at a time and return its modified list.

_k_ is a positive integer and is less than or equal to the length of the linked list. If the number of nodes is not a multiple of _k_ then left-out nodes, in the end, should remain as it is.

You may not alter the values in the list's nodes, only nodes themselves may be changed.

**Example 1:**

![Example 1](/images/leetcode/daily/25-reverse-nodes-in-k-group/reverse_ex1.jpg)

```text
Input: head = [1,2,3,4,5], k = 2
Output: [2,1,4,3,5]
```

**Example 2:**

![Example 2](/images/leetcode/daily/25-reverse-nodes-in-k-group/reverse_ex2.jpg)

```text
Input: head = [1,2,3,4,5], k = 3
Output: [3,2,1,4,5]
```

**Example 3:**

```text
Input: head = [1,2,3,4,5], k = 1
Output: [1,2,3,4,5]
```

**Example 4:**

```text
Input: head = [1], k = 1
Output: [1]
```

**Constraints:**

- The number of nodes in the list is in the range `sz`.
- `1 <= sz <= 5000`
- `0 <= Node.val <= 1000`
- `1 <= k <= sz`

**Follow-up:** Can you solve the problem in O(1) extra memory space?

## 题解

思路很简单，就地翻转即可，但写起来非常容易错。结果还是看了题解，总是接错，太菜了……

最后用 Golang 的实现如下：

```go
func reverse(head, tail *ListNode) (*ListNode, *ListNode) {
    curr, prev := head, tail.Next
    for prev != tail {
        next := curr.Next
        curr.Next = prev
        prev = curr
        curr = next
    }
    return tail, head
}

func reverseKGroup(head *ListNode, k int) *ListNode {
    hair := &ListNode{Next: head}
    prev := hair
    for head != nil {
        tail := prev
        for i := 0; i < k; i++ {
            tail = tail.Next
            if tail == nil {
                return hair.Next
            }
        }
        next := tail.Next
        head, tail = reverse(head, tail)
        prev.Next = head
        tail.Next = next
        prev = tail
        head = tail.Next
    }
    return hair.Next
}
```
