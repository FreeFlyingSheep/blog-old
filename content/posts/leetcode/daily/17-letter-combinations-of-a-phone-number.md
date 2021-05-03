---
title: "17. Letter Combinations of a Phone Number"
date: 2021-05-03
lastmod: 2021-05-03
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

力扣（LeetCode）[第 17 题](https://leetcode-cn.com/problems/letter-combinations-of-a-phone-number)的题解。

<!--more-->

## 题目

Given a string containing digits from `2-9` inclusive, return all possible letter combinations that the number could represent. Return the answer in **any order**.

A mapping of digit to letters (just like on the telephone buttons) is given below. Note that 1 does not map to any letters.

![Telephone keypad2](/images/leetcode/daily/17-letter-combinations-of-a-phone-number\Telephone-keypad2.png)

**Example 1:**

```text
Input: digits = "23"
Output: ["ad","ae","af","bd","be","bf","cd","ce","cf"]
```

**Example 2:**

```text
Input: digits = ""
Output: []
```

**Example 3:**

```text
Input: digits = "2"
Output: ["a","b","c"]
```

**Constraints:**

- `0 <= digits.length <= 4`
- `digits[i]` is a digit in the range `['2', '9']`.

## 题解

用函数 `combinations(letters []string, s string, res *[]string)` 来枚举所有情况，该函数的参数为字符串切片 `letters`，当前枚举的字符串 `s`，以及枚举的结果切片 `res`。

`combinations()` 函数每次递归时往 `s` 中加入一个 `letters[0]` 中的字母，然后扔掉 `letters[0]`，直到 `letters` 切片为空，把结果加入 `res` 切片。

注意如果传入空字符串，希望的结果是空切片（`[]`），而不是包含空字符串的切片（`[""]`）。

最后用 Golang 的实现如下：

```go
func combinations(letters []string, s string, res *[]string) {
    if len(letters) == 0 {
        *res = append(*res, string(s))
        return
    }
    for _, letter := range letters[0] {
        combinations(letters[1:], s+string(letter), res)
    }
}

func letterCombinations(digits string) []string {
    res := []string{}
    if len(digits) == 0 {
        return res
    }

    maps := []string{"abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"}
    letters := []string{}
    for _, digit := range digits {
        index := digit - '0' - 2
        letters = append(letters, maps[index])
    }
    combinations(letters, "", &res)
    return res
}
```
