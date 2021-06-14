---
title: "48. Rotate Image"
date: 2021-04-30
lastmod: 2021-04-30
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 48 题](https://leetcode-cn.com/problems/rotate-image)的题解。

<!--more-->

## 题目

You are given an _n_ x _n_ 2D `matrix` representing an image, rotate the image by 90 degrees (clockwise).

You have to rotate the image [**in-place**](https://en.wikipedia.org/wiki/In-place_algorithm), which means you have to modify the input 2D matrix directly. **DO NOT** allocate another 2D matrix and do the rotation.

**Example 1:**

![Example 1](/images/leetcode/daily/48-rotate-image/mat1.jpg)

```text
Input: matrix = [[1,2,3],[4,5,6],[7,8,9]]
Output: [[7,4,1],[8,5,2],[9,6,3]]
```

**Example 2:**

![Example 2](/images/leetcode/daily/48-rotate-image/mat2.jpg)

```text
Input: matrix = [[5,1,9,11],[2,4,8,10],[13,3,6,7],[15,14,12,16]]
Output: [[15,13,2,5],[14,3,4,1],[12,6,8,9],[16,7,10,11]]
```

**Example 3:**

```text
Input: matrix = [[1]]
Output: [[1]]
```

**Example 4:**

```text
Input: matrix = [[1,2],[3,4]]
Output: [[3,1],[4,2]]
```

**Constraints:**

- `matrix.length == n`
- `matrix[i].length == n`
- `1 <= n <= 20`
- `-1000 <= matrix[i][j] <= 1000`

## 最初思路

根据矩阵的相关数学知识，顺时针翻转后再平移，可以得出变化关系式是 `matrix_new[j][n - i - 1] = matrix[i][j]`。

但这样必须用到新数组，不符合题意。之后的解法是参考题解的。

## 解法一

必须用到新数组的原因是四个角的元素都发生了交换，而不是两两交换。但反过来利用这点，把四个元素作为一个整体，一起交换，就不需要新数组了。

需要注意的是边界，对于 `n` 阶矩阵，如果 `n` 是偶数，那么行和列只要遍历到 `n / 2` 即可；但如是 `n` 是奇数，那么行和列必须有且仅有一个遍历到 `(n + 1) / 2`，剩下的一个遍历到 `n / 2`，这样刚好剩最中间的元素，它不需要交换。

最后用 Golang 的实现如下：

```go
func rotate(matrix [][]int) {
    n := len(matrix)
    for i := 0; i < n/2; i++ {
        for j := 0; j < (n+1)/2; j++ {
            matrix[i][j], matrix[n-j-1][i], matrix[n-i-1][n-j-1], matrix[j][n-i-1] =
                matrix[n-j-1][i], matrix[n-i-1][n-j-1], matrix[j][n-i-1], matrix[i][j]
        }
    }
}
```

## 解法二

顺时针旋转等价于先水平翻转再沿主对角线翻转。

最后用 Golang 的实现如下：

```go
func rotate(matrix [][]int) {
    n := len(matrix)
    for i := 0; i < n/2; i++ {
        matrix[i], matrix[n-1-i] = matrix[n-1-i], matrix[i]
    }
    for i := 0; i < n; i++ {
        for j := 0; j < i; j++ {
            matrix[i][j], matrix[j][i] = matrix[j][i], matrix[i][j]
        }
    }
}
```
