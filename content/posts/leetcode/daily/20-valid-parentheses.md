---
title: "20. Valid Parentheses"
date: 2021-05-16
lastmod: 2021-05-16
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 20 题](https://leetcode-cn.com/problems/valid-parentheses)的题解。

<!--more-->

## 题目

Given a string `s` containing just the characters `'('`, `')'`, `'{'`, `'}'`, `'['` and `']'`, determine if the input string is valid.

An input string is valid if:

1. Open brackets must be closed by the same type of brackets.
2. Open brackets must be closed in the correct order.

**Example 1:**

```text
Input: s = "()"
Output: true
```

**Example 2:**

```text
Input: s = "()[]{}"
Output: true
```

**Example 3:**

```text
Input: s = "(]"
Output: false
```

**Example 4:**

```text
Input: s = "([)]"
Output: false
```

**Example 5:**

```text
Input: s = "{[]}"
Output: true
```

**Constraints:**

- `1 <= s.length <= 104`
- `s` consists of parentheses only `'()[]{}'`.

## 题解

用栈即可，用 Golang 的实现如下：

```go
func isValid(s string) bool {
    var stack []byte
    for i := range s {
        if s[i] == '(' || s[i] == '[' || s[i] == '{' {
            stack = append(stack, s[i])
        } else {
            if len(stack) == 0 {
                return false
            }
            last := len(stack) - 1
            if s[i] == ')' && stack[last] != '(' {
                return false
            } else if s[i] == ']' && stack[last] != '[' {
                return false
            } else if s[i] == '}' && stack[last] != '{' {
                return false
            }
            stack = stack[:last]
        }
    }
    return len(stack) == 0
}
```
