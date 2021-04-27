---
title: "1. Two Sum"
date: 2021-04-18
lastmod: 2021-04-18
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

力扣（LeetCode）[第 1 题](https://leetcode-cn.com/problems/two-sum)的题解。

<!--more-->

## 题目

Given an array of integers `nums` and an integer `target`, return _indices of the two numbers such that they add up to `target`_.

You may assume that each input would have **_exactly_ one solution**, and you may not use the _same_ element twice.

You can return the answer in any order.

**Example 1:**

```text
Input: nums = [2,7,11,15], target = 9
Output: [0,1]
Explanation: Because nums[0] + nums[1] == 9, we return [0, 1].
```

**Example 2:**

```text
Input: nums = [3,2,4], target = 6
Output: [1,2]
```

**Example 3:**

```text
Input: nums = [3,3], target = 6
Output: [0,1]
```

**Constraints:**

- `2 <= nums.length <= 103`
- `-109 <= nums[i] <= 109`
- `-109 <= target <= 109`
- **Only one valid answer exists.**

## 解法一（暴力）

暴力解法，双重循环，时间复杂度 `O(n^2)`，用 Golang 的实现如下：

```go
func twoSum(nums []int, target int) []int {
    l := len(nums)
    for i := 0; i < l; i++ {
        for j := i + 1; j < l; j++ {
            if nums[i]+nums[j] == target {
                return []int{i, j}
            }
        }
    }
    return []int{}
}
```

## 解法二（哈希表）

遍历的同时把元素添加到哈希表，这样在遍历第 `n` 个元素（值为 `num`） 时，可以判断哈希表中 `target - num` 是否存在，若存在，则直接返回，时间和空间复杂度都是 `O(n)`。

注意必须先判断，再把 `num` 添加到哈希里，否则可能会出现 `num == target - num` 的情况，比如示例 2：遍历第一个元素时，如果先添加 `num`（`3`），那么 `target - num`（`6 - 3`） 存在，直接返回了 `[0, 0]`。

还有一个要注意的是返回时，`table[target-num]`（记为 `m`）的值肯定小于 `n`，所以是 `[]int{m, n}`，而不是 `[]int{n, m}`，我一开始竟然搞反了……

最后用 Golang 的实现如下：

```go
func twoSum(nums []int, target int) []int {
    table := make(map[int]int)
    for n, num := range nums {
        if m, ok := table[target-num]; ok {
            return []int{m, n}
        }
        table[num] = n
    }
    return []int{}
}
```
