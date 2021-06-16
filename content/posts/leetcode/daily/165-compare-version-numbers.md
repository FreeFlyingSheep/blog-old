---
title: "165. Compare Version Numbers"
date: 2021-06-11
lastmod: 2021-06-11
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 165 题](https://leetcode-cn.com/problems/compare-version-numbers)的题解。

<!--more-->

## 题目

Given two version numbers, `version1` and `version2`, compare them.

Version numbers consist of **one or more revisions** joined by a dot `'.'`. Each revision consists of **digits** and may contain leading **zeros**. Every revision contains **at least one character**. Revisions are **0-indexed from left to right**, with the leftmost revision being revision 0, the next revision being revision 1, and so on. For example `2.5.33` and `0.1` are valid version numbers.

To compare version numbers, compare their revisions in **left-to-right order**. Revisions are compared using their **integer value ignoring any leading zeros**. This means that revisions `1` and `001` are considered **equal**. If a version number does not specify a revision at an index, then **treat the revision as `0`**. For example, version `1.0` is less than version `1.1` because their revision 0s are the same, but their revision 1s are `0` and `1` respectively, and `0 < 1`.

_Return the following:_

- If `version1 < version2`, return `-1`.
- If `version1 > version2`, return `1`.
- Otherwise, return `0`.

**Example 1:**

```text
Input: version1 = "1.01", version2 = "1.001"
Output: 0
Explanation: Ignoring leading zeroes, both "01" and "001" represent the same integer "1".
```

**Example 2:**

```text
Input: version1 = "1.0", version2 = "1.0.0"
Output: 0
Explanation: version1 does not specify revision 2, which means it is treated as "0".
```

**Example 3:**

```text
Input: version1 = "0.1", version2 = "1.1"
Output: -1
Explanation: version1's revision 0 is "0", while version2's revision 0 is "1". 0 < 1, so version1 < version2.
```

**Example 4:**

```text
Input: version1 = "1.0.1", version2 = "1"
Output: 1
```

**Example 5:**

```text
Input: version1 = "7.5.2.4", version2 = "7.5.3"
Output: -1
```

**Constraints:**

- `1 <= version1.length, version2.length <= 500`
- `version1` and `version2` only contain digits and `'.'`.
- `version1` and `version2` **are valid version numbers**.
- All the given revisions in `version1` and `version2` can be stored in a **32-bit integer**.

## 题解

分割字符串，转换成整型数组，然后依次比较。

判断条件比较复杂，特别是当一个数组遍历到底时，如果另一个数组后续部分全是零，它们还是一样大的。

最后用 Golang 的实现如下：

```go
func compareVersion(version1 string, version2 string) int {
    v1, v2 := []int{}, []int{}
    for _, v := range strings.Split(version1, ".") {
        n, _ := strconv.Atoi(v)
        v1 = append(v1, n)
    }
    for _, v := range strings.Split(version2, ".") {
        n, _ := strconv.Atoi(v)
        v2 = append(v2, n)
    }

    i := 0
    for i < len(v1) && i < len(v2) && v1[i] == v2[i] {
        i++
    }

    if i == len(v1) {
        for i < len(v2) && v2[i] == 0 {
            i++
        }
        if i == len(v2) {
            return 0
        }
        return -1
    }
    if i == len(v2) {
        for i < len(v1) && v1[i] == 0 {
            i++
        }
        if i == len(v1) {
            return 0
        }
        return 1
    }

    if v1[i] > v2[i] {
        return 1
    }
    if v1[i] < v2[i] {
        return -1
    }
    return 0
}
```
