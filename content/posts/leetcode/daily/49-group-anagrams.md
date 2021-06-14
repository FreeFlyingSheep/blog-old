---
title: "49. Group Anagrams"
date: 2021-05-13
lastmod: 2021-05-13
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 49 题](https://leetcode-cn.com/problems/group-anagrams)的题解。

<!--more-->

## 题目

Given an array of strings `strs`, group **the anagrams** together. You can return the answer in **any order**.

An **Anagram** is a word or phrase formed by rearranging the letters of a different word or phrase, typically using all the original letters exactly once.

**Example 1:**

```text
Input: strs = ["eat","tea","tan","ate","nat","bat"]
Output: [["bat"],["nat","tan"],["ate","eat","tea"]]
```

**Example 2:**

```text
Input: strs = [""]
Output: [[""]]
```

**Example 3:**

```text
Input: strs = ["a"]
Output: [["a"]]
```

**Constraints:**

- `1 <= strs.length <= 104`
- `0 <= strs[i].length <= 100`
- `strs[i]` consists of lower-case English letters.

## 最初解法

这题的关键在于理解题目意思，之后很容易想到排序，然后用哈希表。

注意不一定要按照题目示例的顺序来输出，任何一种排序的输出都算对。

最后用 Golang 的实现如下：

```go
type word []byte

func (w word) Len() int {
    return len(w)
}

func (w word) Less(i, j int) bool {
    return w[i] < w[j]
}

func (w word) Swap(i, j int) {
    w[i], w[j] = w[j], w[i]
}

func groupAnagrams(strs []string) [][]string {
    anagrams := make(map[string][]string)
    for _, str := range strs {
        w := word(str)
        sort.Sort(w)
        s := string(w)
        if _, ok := anagrams[s]; !ok {
            anagrams[s] = []string{str}
        } else {
            anagrams[s] = append(anagrams[s], str)
        }
    }

    res := [][]string{}
    for _, words := range anagrams {
        res = append(res, words)
    }
    return res
}
```

其实看了题解后发现，`sort` 还提供了 `Slice()` 函数，对于切片排序，可以简单地写成 `sort.Slice(w, func(i, j int) bool { return s[i] < s[j] })`，这样就不需要额外定义类型并实现那三个函数了。

## 优化解法

仔细思考一下，不需要对每个单词都排序，我们只要统计每个单词里字母出现的字数即可。

注意 Golang 的数组是可以用等号比较的，所以能作为 `map` 的 `Key`。

最后用 Golang 的实现如下（抄的题解）：

```go
func groupAnagrams(strs []string) [][]string {
    mp := map[[26]int][]string{}
    for _, str := range strs {
        cnt := [26]int{}
        for _, b := range str {
            cnt[b-'a']++
        }
        mp[cnt] = append(mp[cnt], str)
    }
    ans := make([][]string, 0, len(mp))
    for _, v := range mp {
        ans = append(ans, v)
    }
    return ans
}
```
