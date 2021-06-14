---
title: "297. Serialize and Deserialize Binary Tree"
date: 2021-04-28
lastmod: 2021-04-28
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 297 题](https://leetcode-cn.com/problems/serialize-and-deserialize-binary-tree)的题解。

<!--more-->

## 题目

Serialization is the process of converting a data structure or object into a sequence of bits so that it can be stored in a file or memory buffer, or transmitted across a network connection link to be reconstructed later in the same or another computer environment.

Design an algorithm to serialize and deserialize a binary tree. There is no restriction on how your serialization/deserialization algorithm should work. You just need to ensure that a binary tree can be serialized to a string and this string can be deserialized to the original tree structure.

**Clarification:** The input/output format is the same as how LeetCode serializes a binary tree. You do not necessarily need to follow this format, so please be creative and come up with different approaches yourself.

**Example 1:**

![Example 1](/images/leetcode/daily/297-serialize-and-deserialize-binary-tree/serdeser.jpg)

```text
Input: root = [1,2,3,null,null,4,5]
Output: [1,2,3,null,null,4,5]
```

**Example 2:**

```text
Input: root = []
Output: []
```

**Example 3:**

```text
Input: root = [1]
Output: [1]
```

**Example 4:**

```text
Input: root = [1,2]
Output: [1,2]
```

**Constraints:**

- The number of nodes in the tree is in the range `[0, 104]`.
- `-1000 <= Node.val <= 1000`

## 题解

我一开始以为要按照题目示例的顺序来序列化结点，看了题解，再看 Clarification，发现自己是个傻逼。

因为我是按题目示例的顺序来序列化结点的，所以用了广度优先搜索，这题显然不需要这么复杂，普通的深度优先搜索就够了。

因为 Golang 没有提供队列，所以借助切片实现了简单的队列，注意切片只有一个元素时，不能 `queue = queue[1:]`。

对于序列化，广度优先搜索，先把根结点入队。之后当队列不为空时，出队一个元素，同时把该元素的左右结点入队，实现按树的层次遍历。

对于反序列化，先反序化根结点，将其入队。之后遍历字符串数组，每次出队一个元素，该元素的左右结点分别对应字符串数组的后两个元素。因为序列化过程保证了字符串数组的元素个数，所以不用担心边界问题。

最后用 Golang 的实现如下：

```go
type Codec struct {
    nodes []string
}

func Constructor() Codec {
    return Codec{[]string{}}
}

func (this *Codec) serialize(root *TreeNode) string {
    queue := []*TreeNode{root}
    for len(queue) > 0 {
        node := queue[0]
        queue = queue[1:]
        if node != nil {
            queue = append(queue, node.Left)
            queue = append(queue, node.Right)
            val := strconv.Itoa(node.Val)
            this.nodes = append(this.nodes, val)
        } else {
            this.nodes = append(this.nodes, "null")
        }
    }
    return strings.Join(this.nodes, " ")
}

func (this *Codec) deserialize(data string) *TreeNode {
    this.nodes = strings.Split(data, " ")
    var root *TreeNode
    n := 0
    if this.nodes[n] != "null" {
        val, _ := strconv.Atoi(this.nodes[n])
        root = &TreeNode{val, nil, nil}
    }
    n++
    queue := []*TreeNode{root}
    for n < len(this.nodes) {
        node := queue[0]
        queue = queue[1:]
        if this.nodes[n] != "null" {
            val, _ := strconv.Atoi(this.nodes[n])
            left := &TreeNode{val, nil, nil}
            node.Left = left
            queue = append(queue, left)
        } else {
            node.Left = nil
        }
        n++
        if this.nodes[n] != "null" {
            val, _ := strconv.Atoi(this.nodes[n])
            right := &TreeNode{val, nil, nil}
            node.Right = right
            queue = append(queue, right)
        } else {
            node.Right = nil
        }
        n++
    }
    return root
}
```
