---
title: "151. Reverse Words in a String"
date: 2021-04-16
lastmod: 2021-04-16
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 151 题](https://leetcode-cn.com/problems/reverse-words-in-a-string)的题解。

<!--more-->

## 题目

Given an input string `s`, reverse the order of the **words**.

A **word** is defined as a sequence of non-space characters. The **words** in `s` will be separated by at least one space.

Return _a string of the words in reverse order concatenated by a single space._

**Note** that `s` may contain leading or trailing spaces or multiple spaces between two words. The returned string should only have a single space separating the words. Do not include any extra spaces.

**Example 1:**

```text
Input: s = "the sky is blue"
Output: "blue is sky the"
```

**Example 2:**

```text
Input: s = "  hello world  "
Output: "world hello"
Explanation: Your reversed string should not contain leading or trailing spaces.
```

**Example 3:**

```text
Input: s = "a good   example"
Output: "example good a"
Explanation: You need to reduce multiple spaces between two words to a single space in the reversed string.
```

**Example 4:**

```text
Input: s = "  Bob    Loves  Alice   "
Output: "Alice Loves Bob"
```

**Example 5:**

```text
Input: s = "Alice does not even like bob"
Output: "bob like even not does Alice"
```

**Constraints:**

- `1 <= s.length <= 104`
- `s` contains English letters (upper-case and lower-case), digits, and spaces `' '`.
- There is **at least one** word in `s`.

**Follow up:** Could you solve it **in-place** with `O(1)` extra space?

## 解法一（自己实现）

代码比较好理解，不做过多解释， Golang 的实现如下：

```go
func reverseWords(s string) string {
    var words []string
    l := len(s)
    for i := 0; i < l; i++ {
        if s[i] != ' ' {
            var word string
            for ; i < l && s[i] != ' '; i++ {
                word += string(s[i])
            }
            words = append(words, string(word))
        }
    }

    var res string
    for i := len(words) - 1; i >= 0; i-- {
        res += " " + words[i]
    }
    return res[1:]
}
```

## 解法二（调用 API）

偷懒解法，利用正则表达式筛选出单词，再把单词的切片倒置即可，Golang 的实现如下

```go
func reverseWords(s string) string {
    re := regexp.MustCompile(`\w+`)
    words := re.FindAllString(s, -1)
    for i, j := 0, len(words)-1; i < j; i, j = i+1, j-1 {
        words[i], words[j] = words[j], words[i]
    }
    return strings.Join(words, " ")
}
```

### 进阶思路

题目最后要求使用 `O(1)` 额外空间复杂度的原地解法。

对于 Golang，`string` 无法直接修改，所以无论如何都会分配至少 `s` 大小的空间。

参考别人的题解，假设用的是 C 语言之类的编程语言，传入的是字符数组 `s`，大致思路如下：

1. 去除多余的空格：遍历字符数组，发现多余空格将后面的内容左移。
2. 将字符串整体倒置：编写一个 `void reverse(char *s, int len)` 函数就地反转字符串，调用 `reverse(s, strlen(s))`。
3. 将每个单词再次倒置：再次遍历 `s`，对于每个单词（记为 `t`，因为以空格分隔，所以遍历时遇到空格或者 `\0` 说明一个单词结束，计算出每个单词的长度 `l`），对每个单词应用 `reverse(t, l)`。

由于所有操作能直接作用在字符数组 `s` 上，所以除了循环变量不需要分配额外的空间，代码就懒得写了（逃）。
