---
title: "273. Integer to English Words"
date: 2021-04-23
lastmod: 2021-04-23
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

力扣（LeetCode）[第 273 题](https://leetcode-cn.com/problems/integer-to-english-words)的题解。

<!--more-->

## 题目

Convert a non-negative integer `num` to its English words representation.

**Example 1:**

```text
Input: num = 123
Output: "One Hundred Twenty Three"
```

**Example 2:**

```text
Input: num = 12345
Output: "Twelve Thousand Three Hundred Forty Five"
```

**Example 3:**

```text
Input: num = 1234567
Output: "One Million Two Hundred Thirty Four Thousand Five Hundred Sixty Seven"
```

**Example 4:**

```text
Input: num = 1234567891
Output: "One Billion Two Hundred Thirty Four Million Five Hundred Sixty Seven Thousand Eight Hundred Ninety One"
```

**Constraints:**

- `0 <= num <= 231 - 1`

## 题解

这题本身不难，就是有点“恶心”。思路也比较简单，英文中的数字把 `3` 个数作为一个整体，对于每个整体，考虑它的百位、十位、个位，如果是 `20` 以内的数字，记得要特殊处理。

用字符串数组记录所有的英文单词，注意单词拼写，还有注意对 `0` 进行特殊处理即可。

最后用 Golang 的实现如下：

```go
package main

import "strings"

func numberToWords(num int) string {
    small := []string{"Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven",
        "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen",
        "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"}
    middle := []string{"Twenty", "Thirty", "Forty", "Fifty", "Sixty",
        "Seventy", "Eighty", "Ninety"}
    large := []string{"Hundred", "Thousand", "Million", "Billion"}

    if num == 0 {
        return small[0]
    }

    var res []string
    count := 0
    for num > 0 {
        var nums []string
        tmp := num % 1000
        num /= 1000
        count++
        if tmp == 0 {
            continue
        }

        if tmp >= 100 {
            up := tmp / 100
            nums = append(nums, small[up], large[0])
        }

        mid := tmp % 100
        if mid >= 20 {
            low := mid % 10
            mid = mid / 10
            nums = append(nums, middle[mid-2])
            if low > 0 {
                nums = append(nums, small[low])
            }
        } else if mid > 0 {
            nums = append(nums, small[mid])
        }

        if count >= 2 {
            nums = append(nums, large[count-1])
        }
        res = append(nums, res...)
    }
    return strings.Join(res, " ")
}
```
