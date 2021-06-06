---
title: "7. Reverse Integer"
date: 2021-06-06
lastmod: 2021-06-06
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 7 题](https://leetcode-cn.com/problems/reverse-integer)的题解。

<!--more-->

## 题目

Given a signed 32-bit integer `x`, return `x` _with its digits reversed_. If reversing `x` causes the value to go outside the signed 32-bit integer range `[-231, 231 - 1]`, then return `0`.

**Assume the environment does not allow you to store 64-bit integers (signed or unsigned).**

**Example 1:**

```text
Input: x = 123
Output: 321
```

**Example 2:**

```text
Input: x = -123
Output: -321
```

**Example 3:**

```text
Input: x = 120
Output: 21
```

**Example 4:**

```text
Input: x = 0
Output: 0
```

**Constraints:**

- `-231 <= x <= 231 - 1`

## 题解

题目本身比较简单，难点在怎么判断溢出，直接记结论即可，用 Golang 的实现如下：

```go
func reverse(x int) int {
    res := 0
    for x != 0 {
        if res < math.MinInt32/10 || res > math.MaxInt32/10 {
            res = 0
            break
        }
        res = res*10 + x%10
        x /= 10
    }
    return res
}
```
