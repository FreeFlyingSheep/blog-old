---
title: "13. Roman to Integer"
date: 2021-06-16
lastmod: 2021-06-16
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 13 题](https://leetcode-cn.com/problems/roman-to-integer)的题解。

<!--more-->

## 题目

Roman numerals are represented by seven different symbols: `I`, `V`, `X`, `L`, `C`, `D` and `M`.

```text
Symbol       Value
I             1
V             5
X             10
L             50
C             100
D             500
M             1000
```

For example, `2` is written as `II` in Roman numeral, just two one's added together. `12` is written as `XII`, which is simply `X + II`. The number `27` is written as `XXVII`, which is `XX + V + II`.

Roman numerals are usually written largest to smallest from left to right. However, the numeral for four is not `IIII`. Instead, the number four is written as `IV`. Because the one is before the five we subtract it making four. The same principle applies to the number nine, which is written as `IX`. There are six instances where subtraction is used:

- `I` can be placed before `V` (5) and `X` (10) to make 4 and 9.
- `X` can be placed before `L` (50) and `C` (100) to make 40 and 90.
- `C` can be placed before `D` (500) and `M` (1000) to make 400 and 900.

Given a roman numeral, convert it to an integer.

**Example 1:**

```text
Input: s = "III"
Output: 3
```

**Example 2:**

```text
Input: s = "IV"
Output: 4
```

**Example 3:**

```text
Input: s = "IX"
Output: 9
```

**Example 4:**

```text
Input: s = "LVIII"
Output: 58
Explanation: L = 50, V= 5, III = 3.
```

**Example 5:**

```text
Input: s = "MCMXCIV"
Output: 1994
Explanation: M = 1000, CM = 900, XC = 90 and IV = 4.
```

**Constraints:**

- `1 <= s.length <= 15`
- `s` contains only the characters `('I', 'V', 'X', 'L', 'C', 'D', 'M')`.
- It is **guaranteed** that `s` is a valid roman numeral in the range `[1, 3999]`.

## 题解

其实只要判断小的数字是否在大的数字左边，是的话用减法，然后一个循环就行了。

但我写的时候用 `switch` 上瘾了，写的贼复杂。

最后用 Golang 的实现如下：

```go
func romanToInt(s string) int {
    res := 0
    for len(s) > 0 {
        sub := false
        if len(s) > 1 {
            sub = true
            switch s[:2] {
            case "CM":
                res += 900
            case "CD":
                res += 400
            case "XC":
                res += 90
            case "XL":
                res += 40
            case "IX":
                res += 9
            case "IV":
                res += 4
            default:
                sub = false
            }
        }
        if sub {
            s = s[2:]
        } else {
            switch s[:1] {
            case "M":
                res += 1000
            case "D":
                res += 500
            case "C":
                res += 100
            case "L":
                res += 50
            case "X":
                res += 10
            case "V":
                res += 5
            case "I":
                res += 1
            }
            s = s[1:]
        }
    }
    return res
}
```
