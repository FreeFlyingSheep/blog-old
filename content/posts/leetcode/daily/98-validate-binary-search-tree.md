---
title: "98. Validate Binary Search Tree"
date: 2021-05-14
lastmod: 2021-05-14
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 98 题](https://leetcode-cn.com/problems/validate-binary-search-tree)的题解。

<!--more-->

## 题目

Given the `root` of a binary tree, _determine if it is a valid binary search tree (BST)_.

A **valid BST** is defined as follows:

- The left subtree of a node contains only nodes with keys **less than** the node's key.
- The right subtree of a node contains only nodes with keys **greater than** the node's key.
- Both the left and right subtrees must also be binary search trees.

**Example 1:**

![Example 1](/images/leetcode/daily/98-validate-binary-search-tree/tree1.jpg)

```text
Input: root = [2,1,3]
Output: true
```

**Example 2:**

![Example 2](/images/leetcode/daily/98-validate-binary-search-tree/tree2.jpg)

```text
Input: root = [5,1,4,null,null,3,6]
Output: false
Explanation: The root node's value is 5 but its right child's value is 4.
```

**Constraints:**

- The number of nodes in the tree is in the range `[1, 104]`.
- `-231 <= Node.val <= 231 - 1`

## 题解

二叉搜索树有一个重要的特性：中序遍历一棵二叉搜索树，得到的是一个有序的数列。

那这题就简单了，先中序遍历，再判断得到的数组是否严格升序。

最后用 Golang 的实现如下：

```go
func search(node *TreeNode, nums *[]int) {
    if node != nil {
        search(node.Left, nums)
        *nums = append(*nums, node.Val)
        search(node.Right, nums)
    }
}

func isValidBST(root *TreeNode) bool {
    nums := []int{}
    search(root, &nums)
    for i := 1; i < len(nums); i++ {
        if nums[i] <= nums[i-1] {
            return false
        }
    }
    return true
}
```
