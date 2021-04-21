---
title: "5. Longest Palindromic Substring"
date: 2021-04-21
lastmod: 2021-04-21
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

力扣（LeetCode）[第 5 题](https://leetcode-cn.com/problems/longest-palindromic-substring)的题解。

<!--more-->

## 题目

Given a string `s`, return _the longest palindromic substring_ in `s`.

**Example 1:**

```text
Input: s = "babad"
Output: "bab"
Note: "aba" is also a valid answer.
```

**Example 2:**

```text
Input: s = "cbbd"
Output: "bb"
```

**Example 3:**

```text
Input: s = "a"
Output: "a"
```

**Example 4:**

```text
Input: s = "ac"
Output: "a"
```

**Constraints:**

- `1 <= s.length <= 1000`
- `s` consist of only digits and English letters (lower-case and/or upper-case)

## 题解

遍历字符串的时候，以每个字符为中心，同时向左右扩展，查找以该字符为中心的最长回文串。

`func longerPalindrome(s, t string, i, j int) string` 函数负责从 `i` 和 `j` 开始向左向右扩展，查找最长的回文串，返回该回文串与 `t` 的长度较大者。

`func longestPalindrome(s string) string` 函数负责遍历字符串 `s`，依次调用 `longerPalindrome(s, res, i-1, i)` 和 `longerPalindrome(s, res, i-1, i+1)` 来查找奇数和偶数长度的最大回文串。

注意判断边界情况：对于左边界，如果 `s` 的长度为 `0` 或 `1`，最长回文串为 `s` 本身；对于右边界，因为当 `i == len(s)` 时（循环并没有包括这种情况），还需要调用一次 `longerPalindrome(s, res, i-1, i)`。

最后用 Golang 的实现如下：

```go
func longerPalindrome(s, t string, i, j int) string {
    res := ""
    if s[i] == s[j] {
        for ; i >= 0 && j < len(s) && s[i] == s[j]; i, j = i-1, j+1 {
        }
        res = s[i+1 : j]
    }
    if len(res) < len(t) {
        res = t
    }
    return res
}

func longestPalindrome(s string) string {
    if len(s) == 0 || len(s) == 1 {
        return s
    }
    res := s[:1]
    i := 1
    for ; i < len(s)-1; i++ {
        res = longerPalindrome(s, res, i-1, i)
        res = longerPalindrome(s, res, i-1, i+1)
    }
    res = longerPalindrome(s, res, i-1, i)
    return res
}
```
