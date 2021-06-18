---
title: "44. Wildcard Matching"
date: 2021-06-17
lastmod: 2021-06-17
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 44 题](https://leetcode-cn.com/problems/wildcard-matching)的题解。

<!--more-->

## 题目

Given an input string (`s`) and a pattern (`p`), implement wildcard pattern matching with support for `'?'` and `'*'` where:

- `'?'` Matches any single character.
- `'*'` Matches any sequence of characters (including the empty sequence).

The matching should cover the **entire** input string (not partial).

**Example 1:**

```text
Input: s = "aa", p = "a"
Output: false
Explanation: "a" does not match the entire string "aa".
```

**Example 2:**

```text
Input: s = "aa", p = "\*"
Output: true
Explanation: '\*' matches any sequence.
```

**Example 3:**

```text
Input: s = "cb", p = "?a"
Output: false
Explanation: '?' matches 'c', but the second letter is 'a', which does not match 'b'.
```

**Example 4:**

```text
Input: s = "adceb", p = "\*a\*b"
Output: true
Explanation: The first '\*' matches the empty sequence, while the second '\*' matches the substring "dce".
```

**Example 5:**

```text
Input: s = "acdcb", p = "a\*c?b"
Output: false
```

**Constraints:**

- `0 <= s.length, p.length <= 2000`
- `s` contains only lowercase English letters.
- `p` contains only lowercase English letters, `'?'` or `'*'`.

## 题解

和第 10 题非常相似，但我还是不会，怎么感觉毫无进步啊……

抄的题解，用 Golang 的实现如下：

```go
func isMatch(s string, p string) bool {
    m, n := len(s), len(p)
    dp := make([][]bool, m+1)
    for i := 0; i <= m; i++ {
        dp[i] = make([]bool, n+1)
    }
    dp[0][0] = true
    for i := 1; i <= n; i++ {
        if p[i-1] == '*' {
            dp[0][i] = true
        } else {
            break
        }
    }
    for i := 1; i <= m; i++ {
        for j := 1; j <= n; j++ {
            if p[j-1] == '*' {
                dp[i][j] = dp[i][j-1] || dp[i-1][j]
            } else if p[j-1] == '?' || s[i-1] == p[j-1] {
                dp[i][j] = dp[i-1][j-1]
            }
        }
    }
    return dp[m][n]
}
```
