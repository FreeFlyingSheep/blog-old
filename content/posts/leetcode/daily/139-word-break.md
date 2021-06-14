---
title: "139. Word Break"
date: 2021-06-02
lastmod: 2021-06-02
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 139 题](https://leetcode-cn.com/problems/word-break)的题解。

<!--more-->

## 题目

Given a string `s` and a dictionary of strings `wordDict`, return `true` if `s` can be segmented into a space-separated sequence of one or more dictionary words.

**Note** that the same word in the dictionary may be reused multiple times in the segmentation.

**Example 1:**

```text
Input: s = "leetcode", wordDict = ["leet","code"]
Output: true
Explanation: Return true because "leetcode" can be segmented as "leet code".
```

**Example 2:**

```text
Input: s = "applepenapple", wordDict = ["apple","pen"]
Output: true
Explanation: Return true because "applepenapple" can be segmented as "apple pen apple".
Note that you are allowed to reuse a dictionary word.
```

**Example 3:**

```text
Input: s = "catsandog", wordDict = ["cats","dog","sand","and","cat"]
Output: false
```

**Constraints:**

- `1 <= s.length <= 300`
- `1 <= wordDict.length <= 1000`
- `1 <= wordDict[i].length <= 20`
- `s` and `wordDict[i]` consist of only lowercase English letters.
- All the strings of `wordDict` are **unique**.

## 最初解法（超时）

暴力递归，以字符串中间的某个点作为分隔，只有当左半部分在字典中，且右半部分也合法时，字符串才是合法的。

为方便查找，用把字典里的单词放 map 里，当然想更优化的话可以考虑前缀树。

最后用 Golang 的实现如下：

```go
func find(s string, dict map[string]bool) bool {
    if s == "" {
        return true
    }
    for end := 1; end <= len(s); end++ {
        if dict[s[:end]] && find(s[end:], dict) {
            return true
        }
    }
    return false
}

func wordBreak(s string, wordDict []string) bool {
    dict := make(map[string]bool)
    for _, word := range wordDict {
        dict[word] = true
    }
    return find(s, dict)
}
```

## 优化解法（动态规划）

思考上面的暴力解法，显然拆分后的单词是否合法被重复计算多次。

用 `valid[i]` 来表示由前 `i` 个字符组成的字符串是否合法。

一个字符串合法意味着从某个点拆分，前半部分和后半部分都合法。假设这个分隔点是 `j`，`valid[i]` 只在 `valid[j]`（前半部分）合法且 `s[j:i]`（后半部分）在字典中时合法。因为时从头开始遍历，我所以们在计算 `valid[i]` 的时候肯定计算过了 `valid[j]`。

最后用 Golang 的实现如下（抄的题解）：

```go
func wordBreak(s string, wordDict []string) bool {
    dict := make(map[string]bool)
    for _, word := range wordDict {
        dict[word] = true
    }
    valid := make([]bool, len(s)+1)
    valid[0] = true
    for i := 1; i <= len(s); i++ {
        for j := 0; j < i; j++ {
            if valid[j] && dict[s[j:i]] {
                valid[i] = true
                break
            }
        }
    }
    return valid[len(s)]
}
```
