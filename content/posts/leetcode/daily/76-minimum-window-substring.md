---
title: "76. Minimum Window Substring"
date: 2021-06-07
lastmod: 2021-06-07
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 76 题](https://leetcode-cn.com/problems/minimum-window-substring)的题解。

<!--more-->

## 题目

Given two strings `s` and `t` of lengths `m` and `n` respectively, return _the **minimum window substring** of_ `s` _such that every character in_ `t` _(**including duplicates**) is included in the window. If there is no such substring__, return the empty string_ `""`_._

The testcases will be generated such that the answer is **unique**.

A **substring** is a contiguous sequence of characters within the string.

**Example 1:**

```text
Input: s = "ADOBECODEBANC", t = "ABC"
Output: "BANC"
Explanation: The minimum window substring "BANC" includes 'A', 'B', and 'C' from string t.
```

**Example 2:**

```text
Input: s = "a", t = "a"
Output: "a"
Explanation: The entire string s is the minimum window.
```

**Example 3:**

```text
Input: s = "a", t = "aa"
Output: ""
Explanation: Both 'a's from t must be included in the window.
Since the largest window of s only has one 'a', return empty string.
```

**Constraints:**

- `m == s.length`
- `n == t.length`
- `1 <= m, n <= 105`
- `s` and `t` consist of uppercase and lowercase English letters.

**Follow up:** Could you find an algorithm that runs in `O(m + n)` time?

## 最初解法（超时）

首先，遍历 `s`，找到所有包含 `t` 中字母的位置，把它们存入数组。

然后，遍历 `t`，统计出现的字母的次数，存入 map。

其次，依次以数组中的元素作为开始位置，寻找满足条件的最小窗口（窗口中出现的字母的次数应该大于等于 map 中相应元素的值）。

最后用 Golang 的实现如下：

```go
func minWindow(s string, t string) string {
    begins := []int{0}
    for begin := 0; begin < len(s); begin++ {
        if strings.Contains(t, s[begin:begin+1]) {
            begins = append(begins, begin)
        }
    }

    counts := make(map[byte]int)
    for _, c := range []byte(t) {
        counts[c]++
    }

    min := ""
    for _, begin := range begins {
        count := make(map[byte]int)
        for end := begin; end < len(s); end++ {
            if strings.Contains(t, s[end:end+1]) {
                count[s[end]]++
            }

            equal := true
            for k, v := range counts {
                if count[k] < v {
                    equal = false
                    break
                }
            }

            if equal {
                r := s[begin : end+1]
                if len(min) == 0 || len(r) < len(min) {
                    min = r
                }
                break
            }
        }
    }
    return min
}
```

## 优化解法

参考题解，我已经想到了判断窗口是否满足条件的比较好的思路，但窗口本身重复计算了多次。

实际上，以第一个字母开始，如果窗口不满足条件，那么右边继续扩展；如果满足条件，那么左边开始收缩。窗口就在字符串上“滑动”过去，这就是滑动窗口的思想，避免了重复的计算。

最后用 Golang 的实现如下（抄的题解）：

```go
func minWindow(s string, t string) string {
    ori, cnt := map[byte]int{}, map[byte]int{}
    for i := 0; i < len(t); i++ {
        ori[t[i]]++
    }

    sLen := len(s)
    len := math.MaxInt32
    ansL, ansR := -1, -1

    check := func() bool {
        for k, v := range ori {
            if cnt[k] < v {
                return false
            }
        }
        return true
    }
    for l, r := 0, 0; r < sLen; r++ {
        if r < sLen && ori[s[r]] > 0 {
            cnt[s[r]]++
        }
        for check() && l <= r {
            if r-l+1 < len {
                len = r - l + 1
                ansL, ansR = l, l+len
            }
            if _, ok := ori[s[l]]; ok {
                cnt[s[l]] -= 1
            }
            l++
        }
    }
    if ansL == -1 {
        return ""
    }
    return s[ansL:ansR]
}
```
