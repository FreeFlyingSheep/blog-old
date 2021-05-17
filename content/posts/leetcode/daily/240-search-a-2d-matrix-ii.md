---
title: "240. Search a 2D Matrix II"
date: 2021-05-05
lastmod: 2021-05-05
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 240 题](https://leetcode-cn.com/problems/search-a-2d-matrix-ii)的题解。

<!--more-->

## 题目

Write an efficient algorithm that searches for a `target` value in an `m x n` integer `matrix`. The `matrix` has the following properties:

- Integers in each row are sorted in ascending from left to right.
- Integers in each column are sorted in ascending from top to bottom.

**Example 1:**

![Example 1](/images/leetcode/daily/240-search-a-2d-matrix-ii/searchgrid2.jpg)

```text
Input: matrix = [[1,4,7,11,15],[2,5,8,12,19],[3,6,9,16,22],[10,13,14,17,24],[18,21,23,26,30]], target = 5
Output: true
```

**Example 2:**

![Example 2](/images/leetcode/daily/240-search-a-2d-matrix-ii/searchgrid.jpg)

```text
Input: matrix = [[1,4,7,11,15],[2,5,8,12,19],[3,6,9,16,22],[10,13,14,17,24],[18,21,23,26,30]], target = 20
Output: false
```

**Constraints:**

- `m == matrix.length`
- `n == matrix[i].length`
- `1 <= n, m <= 300`
- `-109 <= matix[i][j] <= 109`
- All the integers in each row are **sorted** in ascending order.
- All the integers in each column are **sorted** in ascending order.
- `-109 <= target <= 109`

## 题解

参考官方题解，因为行列已经分别排过序，所以从左下角开始找，如果当前元素比目标小，那么向右找，如果当前元素比目标大，那么向上找。

```go
func searchMatrix(matrix [][]int, target int) bool {
    row, col := len(matrix)-1, 0
    for row >= 0 && col < len(matrix[0]) {
        if matrix[row][col] < target {
            col++
        } else if matrix[row][col] > target {
            row--
        } else {
            return true
        }
    }
    return false
}
```
