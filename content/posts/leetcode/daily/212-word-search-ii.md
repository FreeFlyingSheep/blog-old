---
title: "212. Word Search II"
date: 2021-05-28
lastmod: 2021-05-28
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 212 题](https://leetcode-cn.com/problems/word-search-ii)的题解。

<!--more-->

## 题目

Given an `m x n` `board` of characters and a list of strings `words`, return _all words on the board_.

Each word must be constructed from letters of sequentially adjacent cells, where **adjacent cells** are horizontally or vertically neighboring. The same letter cell may not be used more than once in a word.

**Example 1:**

![Example 1](/images/leetcode/daily/212-word-search-ii/search1.jpg)

```text
Input: board = [["o","a","a","n"],["e","t","a","e"],["i","h","k","r"],["i","f","l","v"]], words = ["oath","pea","eat","rain"]
Output: ["eat","oath"]
```

**Example 2:**

![Example 2](/images/leetcode/daily/212-word-search-ii/search2.jpg)

```text
Input: board = [["a","b"],["c","d"]], words = ["abcb"]
Output: []
```

**Constraints:**

- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 12`
- `board[i][j]` is a lowercase English letter.
- `1 <= words.length <= 3 * 104`
- `1 <= words[i].length <= 10`
- `words[i]` consists of lowercase English letters.
- All the strings of `words` are unique.

## 最初解法

暴力大法好，直接套用[第 79 题](https://leetcode-cn.com/problems/word-search)的答案，用 Golang 的实现如下：

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

func findWords(board [][]byte, words []string) []string {
    res := []string{}
    for _, word := range words {
        if exist(board, word) {
            res = append(res, word)
        }
    }
    return res
}
```

## 优化思路

考虑实现一个前缀树来大大减小搜索的成本。

遍历“板子”上的字母，每个字母开始向四个方向搜索，用回溯法查找前缀树中是否有以该字母序列开头的单词。

甚至对于已经查找过的叶子结点的字母，可以直接删除，即剪枝，进一步缩小搜索成本。

由于手写前缀树的难度较大，现成的实现也非常多，我感觉意义不大，知道思路即可，就偷懒不写了。
