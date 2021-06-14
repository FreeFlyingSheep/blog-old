---
title: "73. Set Matrix Zeroes"
date: 2021-05-26
lastmod: 2021-05-26
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 73 题](https://leetcode-cn.com/problems/set-matrix-zeroes)的题解。

<!--more-->

## 题目

Given an `_m_ x _n_` matrix. If an element is **0**, set its entire row and column to **0**. Do it [**in-place**](https://en.wikipedia.org/wiki/In-place_algorithm).

**Follow up:**

- A straight forward solution using O(_m__n_) space is probably a bad idea.
- A simple improvement uses O(_m_ + _n_) space, but still not the best solution.
- Could you devise a constant space solution?

**Example 1:**

![Example 1](/images/leetcode/daily/73-set-matrix-zeroes/mat1.jpg)

```text
Input: matrix = [[1,1,1],[1,0,1],[1,1,1]]
Output: [[1,0,1],[0,0,0],[1,0,1]]
```

**Example 2:**

![Example 2](/images/leetcode/daily/73-set-matrix-zeroes/mat2.jpg)

```text
Input: matrix = [[0,1,2,0],[3,4,5,2],[1,3,1,5]]
Output: [[0,0,0,0],[0,4,5,0],[0,3,1,0]]
```

**Constraints:**

- `m == matrix.length`
- `n == matrix[0].length`
- `1 <= m, n <= 200`
- `-231 <= matrix[i][j] <= 231 - 1`

## 最初解法

用两个集合存储需要置零的行和列，然后依次置零即可，用 Golang 的实现如下：

```go
func setZeroes(matrix [][]int) {
    rows, cols := make(map[int]bool), make(map[int]bool)
    for row := 0; row < len(matrix); row++ {
        for col := 0; col < len(matrix[0]); col++ {
            if matrix[row][col] == 0 {
                rows[row] = true
                cols[col] = true
            }
        }
    }
    for row := range rows {
        for col := 0; col < len(matrix[0]); col++ {
            matrix[row][col] = 0
        }
    }
    for col := range cols {
        for row := 0; row < len(matrix); row++ {
            matrix[row][col] = 0
        }
    }
}
```

看了题解后发现置零部分写复杂了，可以直接这么写：

```go
    for row := 0; row < len(matrix); row++ {
        for col := 0; col < len(matrix[0]); col++ {
            if rows[row] || cols[col] {
                matrix[row][col] = 0
            }
        }
    }
```

这样的空间复杂度是 `O(m+n)`，达到了进阶要求的第二条。

## 优化解法

参考题解给出 `O(1)` 空间复杂度的解法。

用矩阵中的某一行和某一列来标记是否需要对其所在的列和行置零，就可以达到 `O(1)` 空间复杂度。

为了方便后续遍历，这里规定用矩阵的最后一列元素用于标记其所在行是否需要置零，用矩阵的最后一行元素用于标记其所在列是否需要置零。如果某行或者某列的最后一个元素为零，代表该行或列所在的列或者行需要置零，反之不需要。

这么做有一个问题，最后一行和列可能本身就存在零，因此我们需要用额外的标记来记录最后一行和列是否需要置零。

最后用 Golang 的实现如下：

```go
func setZeroes(matrix [][]int) {
    lastRow, lastCol := len(matrix)-1, len(matrix[0])-1
    setRow, setCol := false, false
    for row := 0; row < len(matrix); row++ {
        if matrix[row][lastCol] == 0 {
            setCol = true
            break
        }
    }
    for col := 0; col < len(matrix[0]); col++ {
        if matrix[lastRow][col] == 0 {
            setRow = true
            break
        }
    }
    for row := 0; row < lastRow; row++ {
        for col := 0; col < lastCol; col++ {
            if matrix[row][col] == 0 {
                matrix[lastRow][col] = 0
                matrix[row][lastCol] = 0
            }
        }
    }
    for row := 0; row < lastRow; row++ {
        for col := 0; col < lastCol; col++ {
            if matrix[row][lastCol] == 0 || matrix[lastRow][col] == 0 {
                matrix[row][col] = 0
            }
        }
    }
    if setCol {
        for row := 0; row < len(matrix); row++ {
            matrix[row][lastCol] = 0
        }
    }
    if setRow {
        for col := 0; col < len(matrix[0]); col++ {
            matrix[lastRow][col] = 0
        }
    }
}
```
