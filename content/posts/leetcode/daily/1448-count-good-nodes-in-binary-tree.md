---
title: "1448. Count Good Nodes in Binary Tree"
date: 2021-04-27
lastmod: 2021-04-27
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 1448 题](https://leetcode-cn.com/problems/count-good-nodes-in-binary-tree)的题解。

<!--more-->

## 题目

Given a binary tree `root`, a node _X_ in the tree is named **good** if in the path from root to _X_ there are no nodes with a value _greater than_ X.

Return the number of **good** nodes in the binary tree.

**Example 1:**

![Example 1](/images/leetcode/daily/1448-count-good-nodes-in-binary-tree/test_sample_1.png)

```text
Input: root = [3,1,4,3,null,1,5]
Output: 4
Explanation: Nodes in blue are **good**.
Root Node (3) is always a good node.
Node 4 -> (3,4) is the maximum value in the path starting from the root.
Node 5 -> (3,4,5) is the maximum value in the path
Node 3 -> (3,1,3) is the maximum value in the path.
```

**Example 2:**

![Example 2](/images/leetcode/daily/1448-count-good-nodes-in-binary-tree/test_sample_2.png)

```text
Input: root = [3,3,null,4,2]
Output: 3
Explanation: Node 2 -> (3, 3, 2) is not good, because "3" is higher than it.
```

**Example 3:**

```text
Input: root = [1]
Output: 1
Explanation: Root is considered as **good**.
```

**Constraints:**

- The number of nodes in the binary tree is in the range `[1, 10^5]`.
- Each node's value is between `[-10^4, 10^4]`.

## 题解

这题挺简单的，就是单纯的深度优先搜索（DFS），用 Golang 的实现如下：

```go
func search(node *TreeNode, max int) int {
    count := 0
    if node == nil {
        return count
    }
    if node.Val >= max {
        count++
        max = node.Val
    }
    count += search(node.Left, max)
    count += search(node.Right, max)
    return count
}

func goodNodes(root *TreeNode) int {
    return search(root, -10000)
}
```
