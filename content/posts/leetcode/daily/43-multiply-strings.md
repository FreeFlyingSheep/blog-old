---
title: "43. Multiply Strings"
date: 2021-05-30
lastmod: 2021-05-30
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 43 题](https://leetcode-cn.com/problems/multiply-strings)的题解。

<!--more-->

## 题目

Given two non-negative integers `num1` and `num2` represented as strings, return the product of `num1` and `num2`, also represented as a string.

**Note:** You must not use any built-in BigInteger library or convert the inputs to integer directly.

**Example 1:**

```text
Input: num1 = "2", num2 = "3"
Output: "6"
```

**Example 2:**

```text
Input: num1 = "123", num2 = "456"
Output: "56088"
```

**Constraints:**

- `1 <= num1.length, num2.length <= 200`
- `num1` and `num2` consist of digits only.
- Both `num1` and `num2` do not contain any leading zero, except the number `0` itself.

## 最初解法

用字符串模拟两数相加相乘，写的比较烂，用 Golang 的实现如下：

```go
func mul(num1 string, num2, count int) string {
    res := ""
    carry := 0
    for n := len(num1) - 1; n >= 0; n-- {
        val := int(num1[n]-'0')*num2 + carry
        carry = val / 10
        res = string(byte(val%10)) + res
    }
    if carry != 0 {
        res = string(byte(carry+'0')) + res
    }
    for count > 0 {
        res += "0"
        count--
    }
    return res
}

func add(num1, num2 string) string {
    res := ""
    n1, n2 := len(num1)-1, len(num2)-1
    carry := 0
    for n1 >= 0 || n2 >= 0 {
        val := 0
        if n1 >= 0 {
            val += int(num1[n1] - '0')
            n1--
        }
        if n2 >= 0 {
            val += int(num2[n2] - '0')
            n2--
        }
        val += carry
        carry = val / 10
        res = string(byte(val%10)) + res
    }
    if carry != 0 {
        res = string(byte(carry+'0')) + res
    }
    return res
}

func multiply(num1 string, num2 string) string {
    res := ""
    count := 0
    for n := len(num2) - 1; n >= 0; n-- {
        num := mul(num1, int(num2[n]-'0'), count)
        res = add(res, num)
        count++
    }
    pos := 0
    for pos < len(res) {
        if res[pos] != '0' {
            break
        }
        pos++
    }
    res = res[pos:]
    if res == "" {
        res = "0"
    }
    return res
}
```

## 优化解法

参考题解，把题目理解为多项式乘法。

把 `num1` 记为 $A(x)=\sum\limits_{i=0}^{n-1}{a_{i}x^{i}}$，其中 $x$ 为 $10$，$n$ 为 `num1` 的长度；同理，把 `num2` 记为 $B(x)=\sum\limits_{i=0}^{m-1}{b_{i}x^{i}}$，其中 $x$ 为 $10$，$m$ 为 `num2` 的长度。

推导后可以得出要求的解为 $C(x)=A(x)B(x)=\sum\limits_{i=0}^{n+m-2}{c_{i}x^{i}}$，其中 $x$、$m$ 和 $n$ 同上，$c_{i}=\sum\limits_{j=0}^{i}{a_{k}b_{i-k}}$。

只有在 `num1` 或者 `num2` 中的一个为零时，结果可能会包含多个前导零，所以单独处理这种情况，直接返回 `"0"` 即可。

最后用 Golang 的实现如下：

```go
func multiply(num1 string, num2 string) string {
    if num1 == "0" || num2 == "0" {
        return "0"
    }

    sum := []int{}
    for i := 0; i <= len(num1)+len(num2)-2; i++ {
        val := 0
        for j := 0; j <= i; j++ {
            if j < len(num1) && i-j < len(num2) {
                val += int(num1[j]-'0') * int(num2[i-j]-'0')
            }
        }
        sum = append(sum, val)
    }

    carry := 0
    for i := len(sum) - 1; i >= 0; i-- {
        sum[i] = sum[i] + carry
        carry = sum[i] / 10
        sum[i] %= 10
    }

    res := ""
    if carry != 0 {
        res += strconv.Itoa(carry)
    }
    for i := 0; i < len(sum); i++ {
        res = res + strconv.Itoa(sum[i])
    }
    return res
}
```
