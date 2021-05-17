---
title: "53. Maximum Subarray"
date: 2021-05-02
lastmod: 2021-05-02
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 53 题](https://leetcode-cn.com/problems/maximum-subarray)的题解。

<!--more-->

## 题目

Given an integer array `nums`, find the contiguous subarray (containing at least one number) which has the largest sum and return _its sum_.

**Example 1:**

```text
Input: nums = [-2,1,-3,4,-1,2,1,-5,4]
Output: 6
Explanation: [4,-1,2,1] has the largest sum = 6.
```

**Example 2:**

```text
Input: nums = [1]
Output: 1
```

**Example 3:**

```text
Input: nums = [5,4,-1,7,8]
Output: 23
```

**Constraints:**

- `1 <= nums.length <= 3 * 104`
- `-105 <= nums[i] <= 105`

**Follow up:** If you have figured out the `O(n)` solution, try coding another solution using the **divide and conquer** approach, which is more subtle.

## 解法一（贪心）

暂时无视进阶要求的分治算法。

想求最大的子序列和，那我们遍历数组时尽可能多地加上元素，直到和为负数时舍弃这个子序列，然后从下一项开始重新求和。

我们把初始和定为 `0`，每次都先加当前元素，再判断大小，这样当整个数组全是负数时，也能返回最大的负数。

最后用 Golang 的实现如下：

```go
func maxSubArray(nums []int) int {
    max := -100001
    sum := 0
    i := 0
    for i < len(nums) {
        j := i
        for j < len(nums) {
            sum += nums[j]
            if sum > max {
                max = sum
            }
            if sum < 0 {
                sum = 0
                break
            }
            j++
        }
        i = j + 1
    }
    return max
}
```

## 解法二（动态规划）

考虑以第 `i` 个元素结尾的最大子序列和，记为 `f(i)`。

因为规定了以 `nums[i]` 结尾，所以 `f(i)` 的值取决于 `f(i - 1)` 是否为正数。当 `f(i - 1)` 为正数时，`f(i) = f(i - 1) + nums[i]`；反之 `f(i) = nums[i]`。又因为递推关系式只和 `f(i - 1)` 有关（把它记为 `sum`），所以可以不用开辟额外的数组空间。

在求解 `f(i)` 的过程中，也顺便求解了题目所要求的最大子序列和（所要求的最大子序列一定是以数组中某个元素结尾的）。

最后用 Golang 的实现如下：

```go
func maxSubArray(nums []int) int {
    max := nums[0]
    sum := nums[0]
    for i := 1; i < len(nums); i++ {
        if sum > 0 {
            sum += nums[i]
        } else {
            sum = nums[i]
        }
        if sum > max {
            max = sum
        }
    }
    return max
}
```
