---
title: "105. Construct Binary Tree from Preorder and Inorder Traversal"
date: 2021-05-17
lastmod: 2021-05-17
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 105 题](https://leetcode-cn.com/problems/construct-binary-tree-from-preorder-and-inorder-traversal)的题解。

<!--more-->

## 题目

Given two integer arrays `preorder` and `inorder` where `preorder` is the preorder traversal of a binary tree and `inorder` is the inorder traversal of the same tree, construct and return _the binary tree_.

**Example 1:**

![Example 1](/images/leetcode/daily/105-construct-binary-tree-from-preorder-and-inorder-traversal/tree.jpg)

```text
Input: preorder = [3,9,20,15,7], inorder = [9,3,15,20,7]
Output: [3,9,20,null,null,15,7]
```

**Example 2:**

```text
Input: preorder = [-1], inorder = [-1]
Output: [-1]
```

**Constraints:**

- `1 <= preorder.length <= 3000`
- `inorder.length == preorder.length`
- `-3000 <= preorder[i], inorder[i] <= 3000`
- `preorder` and `inorder` consist of **unique** values.
- Each value of `inorder` also appears in `preorder`.
- `preorder` is **guaranteed** to be the preorder traversal of the tree.
- `inorder` is **guaranteed** to be the inorder traversal of the tree.

## 题解

先序遍历的第一个元素确定根结点。以该元素在中序遍历中的位置为界，左半部分是左子树的中序遍历，右半部分是右子树的中序遍历。再看左半部分的长度，它和左子树的先序遍历的长度一致，右半部分同理。

为了避免查找该元素在中序遍历中的位置时，反复遍历中序数组，可以使用哈希表优化。我这里偷懒了，直接抄的题解，题解中 Golang 的实现没用哈希表。如果要使用哈希表，那可以仿照 C++ 版本的实现，传入 `preorder` 和 `inorder` 的开始和结束位置。

最后用 Golang 的实现如下：

```go
func buildTree(preorder []int, inorder []int) *TreeNode {
    if len(preorder) == 0 {
        return nil
    }

    i := 0
    for ; i < len(inorder); i++ {
        if inorder[i] == preorder[0] {
            break
        }
    }

    return &TreeNode{
        Val:   preorder[0],
        Left:  buildTree(preorder[1:len(inorder[:i])+1], inorder[:i]),
        Right: buildTree(preorder[len(inorder[:i])+1:], inorder[i+1:]),
    }
}
```
