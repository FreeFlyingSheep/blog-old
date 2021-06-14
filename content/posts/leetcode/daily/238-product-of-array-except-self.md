---
title: "238. Product of Array Except Self"
date: 2021-05-25
lastmod: 2021-05-25
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 238 题](https://leetcode-cn.com/problems/product-of-array-except-self)的题解。

<!--more-->

## 题目

Given an integer array `nums`, return _an array_ `answer` _such that_ `answer[i]` _is equal to the product of all the elements of_ `nums` _except_ `nums[i]`.

The product of any prefix or suffix of `nums` is **guaranteed** to fit in a **32-bit** integer.

You must write an algorithm that runs in `O(n)` time and without using the division operation.

**Example 1:**

```text
Input: nums = [1,2,3,4]
Output: [24,12,8,6]
```

**Example 2:**

```text
Input: nums = [-1,1,0,-3,3]
Output: [0,0,9,0,0]
```

**Constraints:**

- `2 <= nums.length <= 105`
- `-30 <= nums[i] <= 30`
- The product of any prefix or suffix of `nums` is **guaranteed** to fit in a **32-bit** integer.

**Follow up:** Can you solve the problem in `O(1)` extra space complexity? (The output array **does not** count as extra space for space complexity analysis.)

## 题解

既要 `O(n)` 时间复杂度，又不让用除法，毫无思路，又是抄题解的一天。

计算除去第 `i` 个元素的其他元素的乘积，就是要求 `i` 左侧元素的乘积和 `i` 右侧元素的乘积。

对于左侧元素的乘积，用一个数组来存储，该数组的第 `i` 个元素的值为 `nums[i]` 左侧所有元素（不包括 `nums[i]`）的乘积。当然，对于右侧元素的乘积，也可以用一个数组来存储，该数组的第 `i` 个元素的值为 `nums[i]` 右侧所有元素（不包括 `nums[i]`）的乘积。这时候，所要求的答案即这两个数组对应元素的乘积。

如果考虑题目的进阶要求，除了最终答案外不允许再开辟其他数组，那么我们只要先把左侧元素乘积的数组作为答案，然后在此基础上遍历，直接计算右侧元素的乘积。

最后用 Golang 的实现如下：

```go
func productExceptSelf(nums []int) []int {
    l := len(nums)
    res := make([]int, l)

    res[0] = 1
    for i := 1; i < l; i++ {
        res[i] = nums[i-1] * res[i-1]
    }

    val := 1
    for i := l - 1; i >= 0; i-- {
        res[i] *= val
        val *= nums[i]
    }
    return res
}
```
