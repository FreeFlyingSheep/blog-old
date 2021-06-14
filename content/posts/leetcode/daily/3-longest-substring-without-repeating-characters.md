---
title: "3. Longest Substring Without Repeating Characters"
date: 2021-05-10
lastmod: 2021-05-10
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 3 题](https://leetcode-cn.com/problems/longest-substring-without-repeating-characters)的题解。

<!--more-->

## 题目

Given a string `s`, find the length of the **longest substring** without repeating characters.

**Example 1:**

```text
Input: s = "abcabcbb"
Output: 3
Explanation: The answer is "abc", with the length of 3.
```

**Example 2:**

```text
Input: s = "bbbbb"
Output: 1
Explanation: The answer is "b", with the length of 1.
```

**Example 3:**

```text
Input: s = "pwwkew"
Output: 3
Explanation: The answer is "wke", with the length of 3.
Notice that the answer must be a substring, "pwke" is a subsequence and not a substring.
```

**Example 4:**

```text
Input: s = ""
Output: 0
```

**Constraints:**

- `0 <= s.length <= 5 * 104`
- `s` consists of English letters, digits, symbols and spaces.

## 题解

原本想着用动态规划的，考虑以第 `i` 个元素结尾的最大子字符串，记为 `f(i)`。但这么做，就需要记录每个子字符串包含哪些字符，否则即使知道 `f(i-1)` 也无法计算 `f(i)`。全部子字符串用哈希表记录显然成本太高，不合理。

看了题解，发现自己果然又傻逼了，用滑动窗口就行了。用一个哈希表（`exist`）来记录字符是否在子字符串中存在。以下标 `i` 开始（包含），寻找最长的子字符串，该字符串以下标 `j` 终止（不包含）。当发现字符 `s[j]` 重复时，向右滑动 `i`，删除哈希表中的 `s[i]`。

最后用 Golang 的实现如下：

```go
func lengthOfLongestSubstring(s string) int {
    exist := make(map[byte]bool)
    max := 0
    for i, j := 0, 0; j < len(s); i++ {
        for j < len(s) && !exist[s[j]] {
            exist[s[j]] = true
            j++
        }
        delete(exist, s[i])
        length := j - i
        if length > max {
            max = length
        }
    }
    return max
}
```
