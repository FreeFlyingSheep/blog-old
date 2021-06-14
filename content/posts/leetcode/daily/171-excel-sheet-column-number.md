---
title: "171. Excel Sheet Column Number"
date: 2021-06-09
lastmod: 2021-06-09
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 171 题](https://leetcode-cn.com/problems/excel-sheet-column-number)的题解。

<!--more-->

## 题目

Given a string `columnTitle` that represents the column title as appear in an Excel sheet, return _its corresponding column number_.

For example:

```text
A -> 1
B -> 2
C -> 3
...
Z -> 26
AA -> 27
AB -> 28
...
```

**Example 1:**

```text
Input: columnTitle = "A"
Output: 1
```

**Example 2:**

```text
Input: columnTitle = "AB"
Output: 28
```

**Example 3:**

```text
Input: columnTitle = "ZY"
Output: 701
```

**Example 4:**

```text
Input: columnTitle = "FXSHRXW"
Output: 2147483647
```

**Constraints:**

- `1 <= columnTitle.length <= 7`
- `columnTitle` consists only of uppercase English letters.
- `columnTitle` is in the range `["A", "FXSHRXW"]`.

## 题解

简单的 26 进制转 10 进制，用 Golang 实现如下：

```go
package main

func titleToNumber(columnTitle string) int {
    res := 0
    for i := range columnTitle {
        n := int(columnTitle[i]-'A') + 1
        res = res*26 + n
    }
    return res
}
```
