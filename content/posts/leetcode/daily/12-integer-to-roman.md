---
title: "12. Integer to Roman"
date: 2021-06-15
lastmod: 2021-06-15
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 12 题](https://leetcode-cn.com/problems/integer-to-roman)的题解。

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

Given an integer, convert it to a roman numeral.

**Example 1:**

```text
Input: num = 3
Output: "III"
```

**Example 2:**

```text
Input: num = 4
Output: "IV"
```

**Example 3:**

```text
Input: num = 9
Output: "IX"
```

**Example 4:**

```text
Input: num = 58
Output: "LVIII"
Explanation: L = 50, V = 5, III = 3.
```

**Example 5:**

```text
Input: num = 1994
Output: "MCMXCIV"
Explanation: M = 1000, CM = 900, XC = 90 and IV = 4.
```

**Constraints:**

- `1 <= num <= 3999`

## 题解

依次从大到小减去相应的数值，直到零，代码写复杂了，可以直接用一个循环来完成。

最后用 Golang 的实现如下：

```go
func intToRoman(num int) string {
    res := ""
    for num != 0 {
        switch {
        case num >= 1000:
            res += "M"
            num -= 1000
        case num >= 900:
            res += "CM"
            num -= 900
        case num >= 500:
            res += "D"
            num -= 500
        case num >= 400:
            res += "CD"
            num -= 400
        case num >= 100:
            res += "C"
            num -= 100
        case num >= 90:
            res += "XC"
            num -= 90
        case num >= 50:
            res += "L"
            num -= 50
        case num >= 40:
            res += "XL"
            num -= 40
        case num >= 10:
            res += "X"
            num -= 10
        case num >= 9:
            res += "IX"
            num -= 9
        case num >= 5:
            res += "V"
            num -= 5
        case num >= 4:
            res += "IV"
            num -= 4
        case num >= 1:
            res += "I"
            num -= 1
        }
    }
    return res
}
```
