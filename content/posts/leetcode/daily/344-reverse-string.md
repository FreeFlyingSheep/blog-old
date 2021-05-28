---
title: "344. Reverse String"
date: 2021-05-27
lastmod: 2021-05-27
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 344 题](https://leetcode-cn.com/problems/reverse-string)的题解。

<!--more-->

## 题目

Write a function that reverses a string. The input string is given as an array of characters `s`.

**Example 1:**

```text
Input: s = ["h","e","l","l","o"]
Output: ["o","l","l","e","h"]
```

**Example 2:**

```text
Input: s = ["H","a","n","n","a","h"]
Output: ["h","a","n","n","a","H"]
```

**Constraints:**

- `1 <= s.length <= 105`
- `s[i]` is a [printable ascii character](https://en.wikipedia.org/wiki/ASCII#Printable_characters).

**Follow up:** Do not allocate extra space for another array. You must do this by modifying the input array [in-place](https://en.wikipedia.org/wiki/In-place_algorithm) with `O(1)` extra memory.

## 题解

这不比”两数相加“简单多了！用 Golang 的实现如下：

```go
func reverseString(s []byte) {
    for i := 0; i < len(s)/2; i++ {
        s[i], s[len(s)-i-1] = s[len(s)-i-1], s[i]
    }
}
```
