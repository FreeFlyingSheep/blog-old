---
title: "33. Search in Rotated Sorted Array"
date: 2021-05-07
lastmod: 2021-05-07
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 33 题](https://leetcode-cn.com/problems/search-in-rotated-sorted-array)的题解。

<!--more-->

## 题目

There is an integer array `nums` sorted in ascending order (with **distinct** values).

Prior to being passed to your function, `nums` is **rotated** at an unknown pivot index `k` (`0 <= k < nums.length`) such that the resulting array is `[nums[k], nums[k+1], ..., nums[n-1], nums[0], nums[1], ..., nums[k-1]]` (**0-indexed**). For example, `[0,1,2,4,5,6,7]` might be rotated at pivot index `3` and become `[4,5,6,7,0,1,2]`.

Given the array `nums` **after** the rotation and an integer `target`, return _the index of_ `target` _if it is in_ `nums`_, or_ `-1` _if it is not in_ `nums`.

**Example 1:**

```text
Input: nums = [4,5,6,7,0,1,2], target = 0
Output: 4
```

**Example 2:**

```text
Input: nums = [4,5,6,7,0,1,2], target = 3
Output: -1
```

**Example 3:**

```text
Input: nums = [1], target = 0
Output: -1
```

**Constraints:**

- `1 <= nums.length <= 5000`
- `-104 <= nums[i] <= 104`
- All values of `nums` are **unique**.
- `nums` is guaranteed to be rotated at some pivot.
- `-104 <= target <= 104`

**Follow up:** Can you achieve this in `O(log n)` time complexity?

## 题解

想要在 `O(log n)` 时间复杂度内完成，只能想到二分查找了。

数组原本是有序的，但因为旋转了，所以不能直接二分查找，要稍作修改。

旋转点的位置很重要，如果中间的数小于左边的数，那说明右边一定是严格升序的；反之左边一定是严格升序的。这时候需要比较边界的数和目标数的关系，来决定往哪个方向继续二分。

最后用 Golang 的实现如下：

```go
func search(nums []int, target int) int {
    left, right := 0, len(nums)-1
    for left <= right {
        mid := (left + right) / 2
        if nums[mid] == target {
            return mid
        } else if nums[mid] < target {
            if nums[mid] < nums[left] && nums[right] < target {
                right = mid - 1
            } else {
                left = mid + 1
            }
        } else {
            if nums[mid] > nums[right] && nums[left] > target {
                left = mid + 1
            } else {
                right = mid - 1
            }
        }
    }
    return -1
}
```
