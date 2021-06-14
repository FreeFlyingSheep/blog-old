---
title: "103. Binary Tree Zigzag Level Order Traversal"
date: 2021-05-08
lastmod: 2021-05-08
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 103 题](https://leetcode-cn.com/problems/binary-tree-zigzag-level-order-traversal)的题解。

<!--more-->

## 题目

Given the `root` of a binary tree, return _the zigzag level order traversal of its nodes' values_. (i.e., from left to right, then right to left for the next level and alternate between).

**Example 1:**

![Example 1](/images/leetcode/daily/103-binary-tree-zigzag-level-order-traversal/tree1.jpg)

```text
Input: root = [3,9,20,null,null,15,7]
Output: [[3],[20,9],[15,7]]
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
- `-100 <= Node.val <= 100`

## 题解

两个思路，都是广度优先搜索，遍历时用临时数组存储每一层的内容。

一个思路是完成遍历后，倒置需要逆序的数组；另一个思路是遍历时就根据一个标志来顺序或者倒叙添加元素。

这里采用后者，用 Golang 的实现如下：

```go
func zigzagLevelOrder(root *TreeNode) [][]int {
    reverse := false
    res := [][]int{}
    queue := []*TreeNode{root}
    for len(queue) > 0 {
        nodes := []*TreeNode{}
        for len(queue) > 0 {
            node := queue[0]
            queue = queue[1:]
            if node != nil {
                nodes = append(nodes, node)
            }
        }
        for _, node := range nodes {
            queue = append(queue, node.Left)
            queue = append(queue, node.Right)
        }

        level := []int{}
        if reverse {
            for i := len(nodes) - 1; i >= 0; i-- {
                level = append(level, nodes[i].Val)
            }
        } else {
            for i := 0; i < len(nodes); i++ {
                level = append(level, nodes[i].Val)
            }
        }
        reverse = !reverse
        if len(level) > 0 {
            res = append(res, level)
        }
    }
    return res
}
```
