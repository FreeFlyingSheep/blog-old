---
title: "79. Word Search"
date: 2021-05-23
lastmod: 2021-05-23
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 79 题](https://leetcode-cn.com/problems/word-search)的题解。

<!--more-->

## 题目

Given an `m x n` grid of characters `board` and a string `word`, return `true` _if_ `word` _exists in the grid_.

The word can be constructed from letters of sequentially adjacent cells, where adjacent cells are horizontally or vertically neighboring. The same letter cell may not be used more than once.

**Example 1:**

![Example 1](/images/leetcode/daily/79-word-search/word2.jpg)

```text
Input: board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "ABCCED"
Output: true
```

**Example 2:**

![Example 2](/images/leetcode/daily/79-word-search/word-1.jpg)

```text
Input: board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "SEE"
Output: true
```

**Example 3:**

![Example 3](/images/leetcode/daily/79-word-search/word3.jpg)

```text
Input: board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "ABCB"
Output: false
```

**Constraints:**

- `m == board.length`
- `n = board[i].length`
- `1 <= m, n <= 6`
- `1 <= word.length <= 15`
- `board` and `word` consists of only lowercase and uppercase English letters.

**Follow up:** Could you use search pruning to make your solution faster with a larger `board`?

## 题解

很容易想到回溯法，这时候往往需要一个数组来标记已经访问的元素，但这题其实不需要。

因为题目保证了数组里的是英文字母，我们可以简单地利用 byte 的第一位来标记是否已经被访问。

之后从每个元素出发，依次判断上下左右四个方向，注意边界即可。

最后用 Golang 的实现如下：

```go
func search(i, j int, board [][]byte, letters []byte) bool {
    if len(letters) == 0 {
        return true
    }
    if i < 0 || i >= len(board) ||
        j < 0 || j >= len(board[i]) ||
        board[i][j] != letters[0] {
        return false
    }
    letters = letters[1:]
    board[i][j] |= 0x80
    found := search(i-1, j, board, letters) ||
        search(i+1, j, board, letters) ||
        search(i, j-1, board, letters) ||
        search(i, j+1, board, letters)
    board[i][j] &= 0x7f
    return found
}

func exist(board [][]byte, word string) bool {
    for i := range board {
        for j := range board[i] {
            if search(i, j, board, []byte(word)) {
                return true
            }
        }
    }
    return false
}
```
