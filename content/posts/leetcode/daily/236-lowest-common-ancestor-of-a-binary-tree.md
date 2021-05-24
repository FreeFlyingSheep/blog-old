---
title: "236. Lowest Common Ancestor of a Binary Tree"
date: 2021-05-22
lastmod: 2021-05-22
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 236 题](https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-tree)的题解。

<!--more-->

## 题目

Given a binary tree, find the lowest common ancestor (LCA) of two given nodes in the tree.

According to the [definition of LCA on Wikipedia](https://en.wikipedia.org/wiki/Lowest_common_ancestor): “The lowest common ancestor is defined between two nodes `p` and `q` as the lowest node in `T` that has both `p` and `q` as descendants (where we allow **a node to be a descendant of itself**).”

**Example 1:**

![Example 1](/images/leetcode/daily/236-lowest-common-ancestor-of-a-binary-tree/binarytree.png)

```text
Input: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 1
Output: 3
Explanation: The LCA of nodes 5 and 1 is 3.
```

**Example 2:**

![Example 2](/images/leetcode/daily/236-lowest-common-ancestor-of-a-binary-tree/binarytree.png)

```text
Input: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 4
Output: 5
Explanation: The LCA of nodes 5 and 4 is 5, since a node can be a descendant of itself according to the LCA definition.
```

**Example 3:**

```text
Input: root = [1,2], p = 1, q = 2
Output: 1
```

**Constraints:**

- The number of nodes in the tree is in the range `[2, 105]`.
- `-109 <= Node.val <= 109`
- All `Node.val` are **unique**.
- `p != q`
- `p` and `q` will exist in the tree.

## 解法一（map）

遍历所有结点，把当前结点和父节点的关系存储在 map 中。

从 p 结点开始，从 map 中依次寻找父节点，标记它们。

从 q 结点开始，从 map 中依次寻找父节点，若某个结点已经被标记，那它就是所要求的最近公共祖先；若没有结点被标记，那根结点是所要求的最近公共祖先。

最后用 Golang 的实现如下：

```go
func search(node, parent *TreeNode, nodes *map[*TreeNode]*TreeNode) {
    if node != nil {
        (*nodes)[node] = parent
        search(node.Left, node, nodes)
        search(node.Right, node, nodes)
    }
}

func lowestCommonAncestor(root, p, q *TreeNode) *TreeNode {
    nodes := make(map[*TreeNode]*TreeNode)
    search(root, root, &nodes)
    exist := make(map[*TreeNode]bool)
    for node := p; node != root; node = nodes[node] {
        exist[node] = true
    }
    for node := q; node != root; node = nodes[node] {
        if exist[node] {
            return node
        }
    }
    return root
}
```

## 解法二（递归）

如果当前结点时空，直接返回空。

如果当前结点是 `p` 或 `q`，因为题目保证存在 `p` 和 `q`，所以当前结点就是所要求的最近公共祖先。

不满足上述两个条件时，递归遍历当前结点的左子树和右子树，存储返回值 `left` 和 `right`。如果 `left` 和 `right` 同时返回了非空值，说明一个子树包含 `p`，另一个子树包含 `q`，那么说明当前结点就是所要求的最近公共祖先。反之，如果一个为空，那么另一个要么也为空，要么同时包含 `p` 和 `q`，返回另一个结点。

如何确保最终返回的结点是“最近”公共祖先呢？因为本质是先序遍历，是从下往上开始判断的，所以最终返回的一定是第一个满足公共祖先要求的结点。

最后用 Golang 的实现如下（抄的题解）：

```go
func lowestCommonAncestor(root, p, q *TreeNode) *TreeNode {
    if root == nil {
        return nil
    }
    if root.Val == p.Val || root.Val == q.Val {
        return root
    }
    left := lowestCommonAncestor(root.Left, p, q)
    right := lowestCommonAncestor(root.Right, p, q)
    if left != nil && right != nil {
        return root
    }
    if left == nil {
        return right
    }
    return left
}
```
