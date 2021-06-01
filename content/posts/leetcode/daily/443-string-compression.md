---
title: "443. String Compression"
date: 2021-06-01
lastmod: 2021-06-01
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 443 题](https://leetcode-cn.com/problems/string-compression)的题解。

<!--more-->

## 题目

Given an array of characters `chars`, compress it using the following algorithm:

Begin with an empty string `s`. For each group of **consecutive repeating characters** in `chars`:

- If the group's length is 1, append the character to `s`.
- Otherwise, append the character followed by the group's length.

The compressed string `s` **should not be returned separately**, but instead be stored **in the input character array `chars`**. Note that group lengths that are 10 or longer will be split into multiple characters in `chars`.

After you are done **modifying the input array**, return _the new length of the array_.

You must write an algorithm that uses only constant extra space.

**Example 1:**

```text
Input: chars = ["a","a","b","b","c","c","c"]
Output: Return 6, and the first 6 characters of the input array should be: ["a","2","b","2","c","3"]
Explanation: The groups are "aa", "bb", and "ccc". This compresses to "a2b2c3".
```

**Example 2:**

```text
Input: chars = ["a"]
Output: Return 1, and the first character of the input array should be: ["a"]
Explanation: The only group is "a", which remains uncompressed since it's a single character.
```

**Example 3:**

```text
Input: chars = ["a","b","b","b","b","b","b","b","b","b","b","b","b"]
Output: Return 4, and the first 4 characters of the input array should be: ["a","b","1","2"].
Explanation: The groups are "a" and "bbbbbbbbbbbb". This compresses to "ab12".
```

**Example 4:**

```text
Input: chars = ["a","a","a","b","b","a","a"]
Output: Return 6, and the first 6 characters of the input array should be: ["a","3","b","2","a","2"].
Explanation: The groups are "aaa", "bb", and "aa". This compresses to "a3b2a2". Note that each group is independent even if two groups have the same character.
```

**Constraints:**

- `1 <= chars.length <= 2000`
- `chars[i]` is a lower-case English letter, upper-case English letter, digit, or symbol.

## 最初解法

遍历两遍字符数组。第一遍把所有超过一个的字符找到，填入出现次数，把多余的字母清空。第二遍把非空的字符往前挪动，统计实际字符数。

最后用 Golang 的实现如下：

```go
func compress(chars []byte) int {
    for i := 0; i < len(chars); {
        count, j := 1, i+1
        for j < len(chars) && chars[j] == chars[i] {
            chars[j] = 0
            count++
            j++
        }
        if count > 1 {
            s := strconv.Itoa(count)
            for _, n := range []byte(s) {
                i++
                chars[i] = n
            }
        }
        i = j
    }

    count, j := 0, 0
    for i := 0; i < len(chars); i++ {
        if chars[i] != 0 {
            chars[j] = chars[i]
            count++
            j++
        }
    }
    return count
}
```

## 优化解法

再次思考，发现自己傻逼了，一次遍历就行了。清空是多余的，直接在遍历的时候同时挪动数组就行了。

最后用 Golang 的实现如下：

```go
func compress(chars []byte) int {
    k := 0
    for i := 0; i < len(chars); {
        count, j := 1, i+1
        for j < len(chars) && chars[j] == chars[i] {
            count++
            j++
        }
        chars[k] = chars[i]
        k++
        if count > 1 {
            s := strconv.Itoa(count)
            for _, n := range []byte(s) {
                chars[k] = n
                k++
            }
        }
        i = j
    }
    return k
}
```
