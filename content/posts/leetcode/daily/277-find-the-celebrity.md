---
title: "277. Find the Celebrity"
date: 2021-05-18
lastmod: 2021-05-18
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 277 题](https://leetcode-cn.com/problems/find-the-celebrity)的题解。

<!--more-->

## 题目

Suppose you are at a party with `n` people (labeled from `0` to `n - 1`), and among them, there may exist one celebrity. The definition of a celebrity is that all the other `n - 1` people know him/her, but he/she does not know any of them.

Now you want to find out who the celebrity is or verify that there is not one. The only thing you are allowed to do is to ask questions like: "Hi, A. Do you know B?" to get information about whether A knows B. You need to find out the celebrity (or verify there is not one) by asking as few questions as possible (in the asymptotic sense).

You are given a helper function `bool knows(a, b)` which tells you whether A knows B. Implement a function `int findCelebrity(n)`. There will be exactly one celebrity if he/she is in the party. Return the celebrity's label if there is a celebrity in the party. If there is no celebrity, return `-1`.

**Example 1:**

![Example 1](/images/leetcode/daily/277-find-the-celebrity/277_example_1_bold.png)

```text
Input: graph = [[1,1,0],[0,1,0],[1,1,1]]
Output: 1
Explanation: There are three persons labeled with 0, 1 and 2. graph[i][j] = 1 means person i knows person j, otherwise graph[i][j] = 0 means person i does not know person j. The celebrity is the person labeled as 1 because both 0 and 2 know him but 1 does not know anybody.
```

**Example 2:**

![Example 2](/images/leetcode/daily/277-find-the-celebrity/277_example_2.png)

```text
Input: graph = [[1,0,1],[1,1,0],[0,1,1]]
Output: -1
Explanation: There is no celebrity.
```

**Constraints:**

- `n == graph.length`
- `n == graph[i].length`
- `2 <= n <= 100`
- `graph[i][j]` is `0` or `1`.
- `graph[i][i] == 1`

**Follow up:** If the maximum number of allowed calls to the API `knows` is `3 * n`, could you find a solution without exceeding the maximum number of calls?

## 最初解法

把题目理解成在一个有向图的关联矩阵中，找一个特殊的结点，从任何结点出发能到达该结点，而从该结点出发不能到达其他结点。

遍历这个关联矩阵，寻找这么一个结点。先找到其他结点都不能到达的结点，如果找到的话，再对该结点进行验证，确保它能到达所有其他结点。

最后用 Golang 的实现如下：

```go
/**
 * The knows API is already defined for you.
 *     knows := func(a int, b int) bool
 */
func solution(knows func(a int, b int) bool) func(n int) int {
    return func(n int) int {
        for i := 0; i < n; i++ {
            j := 0
            for ; j < n; j++ {
                if i != j && knows(i, j) {
                    break
                }
            }
            if j == n {
                for j = 0; j < n; j++ {
                    if !knows(j, i) {
                        break
                    }
                }
                if j == n {
                    return i
                }
            }
        }
        return -1
    }
}
```

## 优化解法

显然上面的解法无法满足进阶要求，下面参考其他人的题解。

对于 `a` 和 `b`，如果 `a` 认识 `b`，那么 `a` 必然不可能是名人，每次调用 `knows(a, b)` 都能排除一个非名人。

按顺序遍历，首先假设 `0` 号是名人，如果 `i` 号认识他，那么 `0` 号比如不是名人，之后假定 `i` 号是名人，继续遍历。特殊情况是 `i == 0`，但这时候我们判定 `0` 号不是名人，然后继续假定 `i` 是名人，不会出现问题。

那么遍历一次，就能排除 `n - 1` 个人，之后只要对剩下的那个人进行校验，就能确定名人了。

最后用 Golang 的实现如下：

```go
/**
 * The knows API is already defined for you.
 *     knows := func(a int, b int) bool
 */
func solution(knows func(a int, b int) bool) func(n int) int {
    return func(n int) int {
        res := 0
        for i := 0; i < n; i++ {
            if knows(res, i) {
                res = i
            }
        }
        for i := 0; i < n; i++ {
            if i != res && !knows(i, res) {
                return -1
            }
        }
        return res
    }
}
```
