---
title: "54. Spiral Matrix"
date: 2021-04-17
lastmod: 2021-04-17
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 54 题](https://leetcode-cn.com/problems/spiral-matrix)的题解。

<!--more-->

## 题目

Given an `m x n` `matrix`, return _all elements of the_ `matrix` _in spiral order_.

**Example 1:**

![Example 1](/images/leetcode/daily/54-spiral-matrix/spiral1.jpg)

```text
Input: matrix = [[1,2,3],[4,5,6],[7,8,9]]
Output: [1,2,3,6,9,8,7,4,5]
```

**Example 2:**

![Example 2](/images/leetcode/daily/54-spiral-matrix/spiral.jpg)

```text
Input: matrix = [[1,2,3,4],[5,6,7,8],[9,10,11,12]]
Output: [1,2,3,4,8,12,11,10,9,5,6,7]
```

**Constraints:**

- `m == matrix.length`
- `n == matrix[i].length`
- `1 <= m, n <= 10`
- `-100 <= matrix[i][j] <= 100`

## 题解

螺旋遍历矩阵，最终要输出的元素个数 `num` 应该等于矩阵的行和列的乘积（`lenRow * lenCol`）。

遍历矩阵的方向，依次是`右 -> 下 -> 左 -> 上 -> 右 -> ……`，每个方向定义如下：

- 右：`dirRow, dirCol = 0, 1`
- 下：`dirRow, dirCol = 1, 0`
- 左：`dirRow, dirCol = 0, -1`
- 上：`dirRow, dirCol = -1, 0`

当前元素的行列下标记为 `row, col`，下一个元素的下标即 `row + dirRow, col + dirCol`。

每个方向走到底，边界都应该缩小 `1` 格，此处把上边界记为 `minRow`， 左边界记为 `minCol`，下边界记为 `maxRow`，右边界记为 `maxCol`。

走到底的判断也比较简单，以往右走（`dirCol == 1`）为例，当前列下标 `col` 触碰到右边界（`col == maxCol`）即代表走到底了。

约束中已经明确不会出现数组长度为 `0` 的情况，因此不用做特殊处理。

最后用 Golang 的实现如下：

```go
func spiralOrder(matrix [][]int) []int {
    var res []int
    lenRow, lenCol := len(matrix), len(matrix[0])
    row, col := 0, 0
    dirRow, dirCol := 0, 1
    minRow, minCol := 1, 0
    maxRow, maxCol := lenRow-1, lenCol-1
    num := lenRow * lenCol
    for n := 0; n < num; n++ {
        res = append(res, matrix[row][col])
        if dirCol == 1 && col == maxCol {
            dirRow, dirCol = 1, 0
            maxCol--
        } else if dirRow == 1 && row == maxRow {
            dirRow, dirCol = 0, -1
            maxRow--
        } else if dirCol == -1 && col == minCol {
            dirRow, dirCol = -1, 0
            minCol++
        } else if dirRow == -1 && row == minRow {
            dirRow, dirCol = 0, 1
            minRow++
        }
        row, col = row+dirRow, col+dirCol
    }
    return res
}
```
