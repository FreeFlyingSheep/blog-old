---
title: "173. Binary Search Tree Iterator"
date: 2021-06-10
lastmod: 2021-06-10
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 173 题](https://leetcode-cn.com/problems/binary-search-tree-iterator)的题解。

<!--more-->

## 题目

Implement the `BSTIterator` class that represents an iterator over the **[in-order traversal](https://en.wikipedia.org/wiki/Tree_traversal#In-order_(LNR))** of a binary search tree (BST):

- `BSTIterator(TreeNode root)` Initializes an object of the `BSTIterator` class. The `root` of the BST is given as part of the constructor. The pointer should be initialized to a non-existent number smaller than any element in the BST.
- `boolean hasNext()` Returns `true` if there exists a number in the traversal to the right of the pointer, otherwise returns `false`.
- `int next()` Moves the pointer to the right, then returns the number at the pointer.

Notice that by initializing the pointer to a non-existent smallest number, the first call to `next()` will return the smallest element in the BST.

You may assume that `next()` calls will always be valid. That is, there will be at least a next number in the in-order traversal when `next()` is called.

**Example 1:**

![Example 1](/images/leetcode/daily/173-binary-search-tree-iterator/bst-tree.png)

```text
Input
["BSTIterator", "next", "next", "hasNext", "next", "hasNext", "next", "hasNext", "next", "hasNext"]
[[[7, 3, 15, null, null, 9, 20]], [], [], [], [], [], [], [], [], []]
Output
[null, 3, 7, true, 9, true, 15, true, 20, false]

Explanation
BSTIterator bSTIterator = new BSTIterator([7, 3, 15, null, null, 9, 20]);
bSTIterator.next();    // return 3
bSTIterator.next();    // return 7
bSTIterator.hasNext(); // return True
bSTIterator.next();    // return 9
bSTIterator.hasNext(); // return True
bSTIterator.next();    // return 15
bSTIterator.hasNext(); // return True
bSTIterator.next();    // return 20
bSTIterator.hasNext(); // return False
```

**Constraints:**

- The number of nodes in the tree is in the range `[1, 105]`.
- `0 <= Node.val <= 106`
- At most `105` calls will be made to `hasNext`, and `next`.

**Follow up:**

- Could you implement `next()` and `hasNext()` to run in average `O(1)` time and use `O(h)` memory, where `h` is the height of the tree?

## 题解

事实证明，不要搞骚操作，直接中序遍历把结果存数组就完事了，还不容易出错。

最后用 Golang 的实现如下：

```go
type BSTIterator struct {
    index int
    vals  []int
}

func bfs(iter *BSTIterator, node *TreeNode) {
    if node != nil {
        bfs(iter, node.Left)
        iter.vals = append(iter.vals, node.Val)
        bfs(iter, node.Right)
    }
}

func Constructor(root *TreeNode) BSTIterator {
    iter := BSTIterator{-1, []int{}}
    bfs(&iter, root)
    if iter.HasNext() {
        iter.index++
    }
    return iter
}

func (this *BSTIterator) Next() int {
    val := -1
    if this.HasNext() {
        val = this.vals[this.index]
        this.index++
    }
    return val
}

func (this *BSTIterator) HasNext() bool {
    return this.index < len(this.vals)
}
```
