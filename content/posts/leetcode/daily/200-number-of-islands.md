---
title: "200. Number of Islands"
date: 2021-04-15
lastmod: 2021-04-15
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

力扣（LeetCode）[第 200 题](https://leetcode-cn.com/problems/number-of-islands)的题解。

<!--more-->

## 题目

Given an `m x n` 2D binary grid `grid` which represents a map of `'1'`s (land) and `'0'`s (water), return _the number of islands_.

An **island** is surrounded by water and is formed by connecting adjacent lands horizontally or vertically. You may assume all four edges of the grid are all surrounded by water.

**Example 1:**

```text
Input: grid = [
  ["1","1","1","1","0"],
  ["1","1","0","1","0"],
  ["1","1","0","0","0"],
  ["0","0","0","0","0"]
]
Output: 1
```

**Example 2:**

```text
Input: grid = [
  ["1","1","0","0","0"],
  ["1","1","0","0","0"],
  ["0","0","1","0","0"],
  ["0","0","0","1","1"]
]
Output: 3
```

**Constraints:**

- `m == grid.length`
- `n == grid[i].length`
- `1 <= m, n <= 300`
- `grid[i][j]` is `'0'` or `'1'`.

## 题解

这题比较简单，对于网格中的每一个未标记过的岛屿节点（值为 `'1'`），都往上下左右四个方向进行搜索，如果发现其也是岛屿，标记一下（值为 `'2'`），然后继续搜索下去。

唯一比较坑的是传入的是字符 `'0'` 和 `'1'`，不是数字 `0` 和 `1`.

最后用 Golang 的实现如下：

```go
func setGrid(i, j int, grid [][]byte) {
    grid[i][j] = '2'
    if i-1 >= 0 && grid[i-1][j] == '1' {
        setGrid(i-1, j, grid)
    }
    if i+1 < len(grid) && grid[i+1][j] == '1' {
        setGrid(i+1, j, grid)
    }
    if j-1 >= 0 && grid[i][j-1] == '1' {
        setGrid(i, j-1, grid)
    }
    if j+1 < len(grid[i]) && grid[i][j+1] == '1' {
        setGrid(i, j+1, grid)
    }
}

func numIslands(grid [][]byte) int {
    n := 0
    for i := range grid {
        for j := range grid[i] {
            if grid[i][j] == '1' {
                setGrid(i, j, grid)
                n++
            }
        }
    }
    return n
}
```
