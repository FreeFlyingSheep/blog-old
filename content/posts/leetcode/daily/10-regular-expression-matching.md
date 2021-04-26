---
title: "10. Regular Expression Matching"
date: 2021-04-26
lastmod: 2021-04-26
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

力扣（LeetCode）[第 10 题](https://leetcode-cn.com/problems/regular-expression-matching)的题解。

<!--more-->

## 题目

Given an input string (`s`) and a pattern (`p`), implement regular expression matching with support for `'.'` and `'*'` where:

- `'.'` Matches any single character.​​​​
- `'*'` Matches zero or more of the preceding element.

The matching should cover the **entire** input string (not partial).

**Example 1:**

```text
Input: s = "aa", p = "a"
Output: false
Explanation: "a" does not match the entire string "aa".
```

**Example 2:**

```text
Input: s = "aa", p = "a*"
Output: true
Explanation: '*' means zero or more of the preceding element, 'a'. Therefore, by repeating 'a' once, it becomes "aa".
```

**Example 3:**

```text
Input: s = "ab", p = ".*"
Output: true
Explanation: ".*" means "zero or more (*) of any character (.)".
```

**Example 4:**

```text
Input: s = "aab", p = "c*a*b"
Output: true
Explanation: c can be repeated 0 times, a can be repeated 1 time. Therefore, it matches "aab".
```

**Example 5:**

```text
Input: s = "mississippi", p = "mis*is*p*."
Output: false
```

**Constraints:**

- `0 <= s.length <= 20`
- `0 <= p.length <= 30`
- `s` contains only lowercase English letters.
- `p` contains only lowercase English letters, `'.'`, and `'*'`.
- It is guaranteed for each appearance of the character `'*'`, there will be a previous valid character to match.

## 题解

没有思路，看题解是动态规划，这是第一次做动态规划题，直接抄的答案，以后有机会再自己写。

下面是我对题解的理解。”动态规划“的本质似乎是递归，”转移方程“就是递归方程，求解动态规划问题即想办法建立递归方程。与平常的递归不同的是，动态规划存储了递归的中间数据，来避免重复求解。

不妨倒着考虑这题，用 `f[i][j]` 表示 `s` 的前 `i` 个字符与 `p` 中的前 `j` 个字符是否能够匹配。

对于 `p[j]`，有三种情况：

- `p[j]` 是 `.`，这时候 `p[j]` 总与 `s[i]` 匹配。
- `p[j]` 是小写字母，这时候是否匹配即判断 `p[j]` 与 `s[i]` 是否相等。
- `p[j]` 是 `*`，因为题目保证 `*` 前面必有一个字符，所以我们把那个字符和 `*` 作为一个整体来匹配。

对于前两种情况，如果 `p` 的第 `j` 个字符（`p[j]`）与 `s` 的第 `i` 个字符（`s[i]`）匹配，那么我们只需要考虑 `p` 的第 `j - 1` 个字符与 `s` 的第 `i - 1` 个在字符是否匹配（`f[i-1][j-1]`）；反之字符串 `s` 和 `p` 不匹配。

对于最后一种情况，如果整体中的字符没匹配成功，说明能直接丢掉这个整体，那么只要考虑 `p` 的前 `j - 2` 个字符与 `s` 的前 `i` 个在字符是否匹配（`f[i][j-2]`）。如果字符匹配成功，那么后续可能不会匹配成功，这时应该直接丢掉这个整体，即考虑 `f[i][j-2]`；但也有可能继续匹配成功，这时需要保留这个整体，即考虑 `p` 的前 `j` 个字符与 `s` 的前 `i - 1` 个在字符是否匹配（`f[i-1][j]`）。

初始状态肯定是 `f[0][0] = true`，因为两个空字符串能匹配成功。之后要注意的就是边界问题了，官方题解的 Golang 的实现如下：

```go
func isMatch(s string, p string) bool {
    m, n := len(s), len(p)
    matches := func(i, j int) bool {
        if i == 0 {
            return false
        }
        if p[j-1] == '.' {
            return true
        }
        return s[i-1] == p[j-1]
    }

    f := make([][]bool, m+1)
    for i := 0; i < len(f); i++ {
        f[i] = make([]bool, n+1)
    }
    f[0][0] = true
    for i := 0; i <= m; i++ {
        for j := 1; j <= n; j++ {
            if p[j-1] == '*' {
                f[i][j] = f[i][j] || f[i][j-2]
                if matches(i, j-1) {
                    f[i][j] = f[i][j] || f[i-1][j]
                }
            } else if matches(i, j) {
                f[i][j] = f[i][j] || f[i-1][j-1]
            }
        }
    }
    return f[m][n]
}
```
