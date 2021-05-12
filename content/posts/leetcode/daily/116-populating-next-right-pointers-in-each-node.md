---
title: "116. Populating Next Right Pointers in Each Node"
date: 2021-05-12
lastmod: 2021-05-12
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

力扣（LeetCode）[第 116 题](https://leetcode-cn.com/problems/populating-next-right-pointers-in-each-node)的题解。

<!--more-->

## 题目

You are given a **perfect binary tree** where all leaves are on the same level, and every parent has two children. The binary tree has the following definition:

```text
struct Node {
  int val;
  Node *left;
  Node *right;
  Node *next;
}
```

Populate each next pointer to point to its next right node. If there is no next right node, the next pointer should be set to `NULL`.

Initially, all next pointers are set to `NULL`.

**Follow up:**

- You may only use constant extra space.
- Recursive approach is fine, you may assume implicit stack space does not count as extra space for this problem.

**Example 1:**

![Example 1](/images/leetcode/daily/116-populating-next-right-pointers-in-each-node/116_sample.png)

```text
Input: root = [1,2,3,4,5,6,7]
Output: [1,#,2,3,#,4,5,6,7,#]
Explanation: Given the above perfect binary tree (Figure A), your function should populate each next pointer to point to its next right node, just like in Figure B. The serialized output is in level order as connected by the next pointers, with '#' signifying the end of each level.
```

**Constraints:**

- The number of nodes in the given tree is less than `4096`.
- `-1000 <= node.val <= 1000`

## 题解

如果不考虑进阶要求，那么直接层序遍历即可。但如果考虑进阶要求，空间复杂度必须 `O(1)`，那又是看题解的一天。

这题的难点在于怎么添加示例中 `5 -> 6` 的指针。解题的关键在于想到，当我们在某一层时，可以利用该层的 `Next` 来横向遍历，方便地添加下一层的 `Next` 指针。

外循环遍历层数，内循环遍历当前层的结点，用 Golang 的实现如下（抄的题解）：

```go
func connect(root *Node) *Node {
    if root == nil {
        return root
    }

    for left := root; left.Left != nil; left = left.Left {
        for node := left; node != nil; node = node.Next {
            node.Left.Next = node.Right
            if node.Next != nil {
                node.Right.Next = node.Next.Left
            }
        }
    }
    return root
}
```
