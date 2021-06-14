---
title: "23. Merge k Sorted Lists"
date: 2021-04-29
lastmod: 2021-04-29
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 23 题](https://leetcode-cn.com/problems/merge-k-sorted-lists)的题解。

<!--more-->

## 题目

You are given an array of `k` linked-lists `lists`, each linked-list is sorted in ascending order.

_Merge all the linked-lists into one sorted linked-list and return it._

**Example 1:**

```text
Input: lists = [[1,4,5],[1,3,4],[2,6]]
Output: [1,1,2,3,4,4,5,6]
Explanation: The linked-lists are:
[
  1->4->5,
  1->3->4,
  2->6
]
merging them into one sorted list:
1->1->2->3->4->4->5->6
```

**Example 2:**

```text
Input: lists = []
Output: []
```

**Example 3:**

```text
Input: lists = [[]]
Output: []
```

**Constraints:**

- `k == lists.length`
- `0 <= k <= 10^4`
- `0 <= lists[i].length <= 500`
- `-10^4 <= lists[i][j] <= 10^4`
- `lists[i]` is sorted in **ascending order**.
- The sum of `lists[i].length` won't exceed `10^4`.

## 题解

用迭代器数组来记录每个链表的遍历的位置，循环直到没有链表能继续遍历，每次循环时比较每个链表的迭代器指向的元素，将最小的那个添加到新链表。

最后用 Golang 的实现如下：

```go
func mergeKLists(lists []*ListNode) *ListNode {
    prev := &ListNode{}
    head := prev
    iterators := []*ListNode{}
    for _, list := range lists {
        iterators = append(iterators, list)
    }
    for {
        loop := false
        min := 10001
        iterator := 0
        for n := 0; n < len(lists); n++ {
            if iterators[n] != nil {
                if iterators[n].Val < min {
                    iterator = n
                    min = iterators[iterator].Val
                    loop = true
                }
            }
        }
        if !loop {
            break
        }
        iterators[iterator] = iterators[iterator].Next
        node := &ListNode{min, nil}
        prev.Next = node
        prev = prev.Next
    }
    return head.Next
}
```
