---
title: "102. Binary Tree Level Order Traversal"
date: 2021-06-18
lastmod: 2021-06-18
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 102 题](https://leetcode-cn.com/problems/binary-tree-level-order-traversal)的题解。

<!--more-->

## 题目

Given the `root` of a binary tree, return _the level order traversal of its nodes' values_. (i.e., from left to right, level by level).

**Example 1:**

![Example 1](/images/leetcode/daily/102-binary-tree-level-order-traversal/tree1.jpg)

```text
Input: root = [3,9,20,null,null,15,7]
Output: [[3],[9,20],[15,7]]
```

**Example 2:**

```text
Input: root = [1]
Output: [[1]]
```

**Example 3:**

```text
Input: root = []
Output: []
```

**Constraints:**

- The number of nodes in the tree is in the range `[0, 2000]`.
- `-1000 <= Node.val <= 1000`

## 题解

这题没啥好说的，用 Golang 的实现如下：

```go
func levelOrder(root *TreeNode) [][]int {
    res := [][]int{}
    if root == nil {
        return res
    }

    queue := []*TreeNode{root}
    for len(queue) > 0 {
        nodes := []int{}
        l := len(queue)
        for i := 0; i < l; i++ {
            node := queue[i]
            nodes = append(nodes, node.Val)
            if node.Left != nil {
                queue = append(queue, node.Left)
            }
            if node.Right != nil {
                queue = append(queue, node.Right)
            }
        }
        queue = queue[l:]
        res = append(res, nodes)
    }
    return res
}
```
