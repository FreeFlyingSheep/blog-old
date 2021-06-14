---
title: "557. Reverse Words in a String III"
date: 2021-06-14
lastmod: 2021-06-14
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 557 题](https://leetcode-cn.com/problems/reverse-words-in-a-string-iii)的题解。

<!--more-->

## 题目

Given a string `s`, reverse the order of characters in each word within a sentence while still preserving whitespace and initial word order.

**Example 1:**

```text
Input: s = "Let's take LeetCode contest"
Output: "s'teL ekat edoCteeL tsetnoc"
```

**Example 2:**

```text
Input: s = "God Ding"
Output: "doG gniD"
```

**Constraints:**

- `1 <= s.length <= 5 * 104`
- `s` contains printable **ASCII** characters.
- `s` does not contain any leading or trailing spaces.
- There is **at least one** word in `s`.
- All the words in `s` are separated by a single space.

## 题解

偷个懒，直接调用库函数分割字符串（逃，用 Golang 的实现如下：

```go
func reverseWords(s string) string {
    res := []string{}
    words := strings.Split(s, " ")
    for _, word := range words {
        w := []byte(word)
        for i := 0; i < len(w)/2; i++ {
            w[i], w[len(w)-i-1] = w[len(w)-i-1], w[i]
        }
        res = append(res, string(w))
    }
    return strings.Join(res, " ")
}
```
