---
title: "1239. Maximum Length of a Concatenated String with Unique Characters"
date: 2021-06-13
lastmod: 2021-06-13
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 1239 题](https://leetcode-cn.com/problems/maximum-length-of-a-concatenated-string-with-unique-characters)的题解。

<!--more-->

## 题目

Given an array of strings `arr`. String `s` is a concatenation of a sub-sequence of `arr` which have **unique characters**.

Return _the maximum possible length_ of `s`.

**Example 1:**

```text
Input: arr = ["un","iq","ue"]
Output: 4
Explanation: All possible concatenations are "","un","iq","ue","uniq" and "ique".
Maximum length is 4.
```

**Example 2:**

```text
Input: arr = ["cha","r","act","ers"]
Output: 6
Explanation: Possible solutions are "chaers" and "acters".
```

**Example 3:**

```text
Input: arr = ["abcdefghijklmnopqrstuvwxyz"]
Output: 26
```

**Constraints:**

- `1 <= arr.length <= 16`
- `1 <= arr[i].length <= 26`
- `arr[i]` contains only lower case English letters.

## 题解

暴力大法，每个字符串可选可不选，穷举所有情况。

最后用 Golang 的实现如下：

```go
func length(arr []string, s string, i int) int {
    if i == len(arr) {
        letters := map[byte]bool{}
        for _, letter := range []byte(s) {
            if _, ok := letters[letter]; ok {
                return 0
            }
            letters[letter] = true
        }
        return len(s)
    }
    max := length(arr, s+arr[i], i+1)
    l := length(arr, s, i+1)
    if l > max {
        max = l
    }
    return max
}

func maxLength(arr []string) int {
    return length(arr, "", 0)
}
```
