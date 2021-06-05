---
title: "22. Generate Parentheses"
date: 2021-06-03
lastmod: 2021-06-03
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 22 题](https://leetcode-cn.com/problems/generate-parentheses)的题解。

<!--more-->

## 题目

Given `n` pairs of parentheses, write a function to _generate all combinations of well-formed parentheses_.

**Example 1:**

```text
Input: n = 3
Output: ["((()))","(()())","(())()","()(())","()()()"]
```

**Example 2:**

```text
Input: n = 1
Output: ["()"]
```

**Constraints:**

- `1 <= n <= 8`

## 题解

回溯即可，用 `n` 和 `m` 分别记录还缺的左括号和已经有的右括号的数量。

当两者都为 `0` 时，说明生成了一个合法字符串；当 `n` 不为 `0` 时，添加左括号，这时需要的右括号也应该加一；当 `m` 不为 `0` 时，添加右括号。

最后用 Golang 的实现如下：

```go
func generate(n, m int, s string) []string {
    if n == 0 && m == 0 {
        return []string{s}
    }

    res := []string{}
    if n > 0 {
        strs := generate(n-1, m+1, s+"(")
        res = append(res, strs...)
    }
    if m > 0 {
        strs := generate(n, m-1, s+")")
        res = append(res, strs...)
    }
    return res
}

func generateParenthesis(n int) []string {
    return generate(n, 0, "")
}
```
