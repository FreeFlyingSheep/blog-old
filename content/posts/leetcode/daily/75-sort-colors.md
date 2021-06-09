---
title: "75. Sort Colors"
date: 2021-06-08
lastmod: 2021-06-08
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 75 题](https://leetcode-cn.com/problems/sort-colors)的题解。

<!--more-->

## 题目

Given an array `nums` with `n` objects colored red, white, or blue, sort them **[in-place](https://en.wikipedia.org/wiki/In-place_algorithm)** so that objects of the same color are adjacent, with the colors in the order red, white, and blue.

We will use the integers `0`, `1`, and `2` to represent the color red, white, and blue, respectively.

You must solve this problem without using the library's sort function.

**Example 1:**

```text
Input: nums = [2,0,2,1,1,0]
Output: [0,0,1,1,2,2]
```

**Example 2:**

```text
Input: nums = [2,0,1]
Output: [0,1,2]
```

**Example 3:**

```text
Input: nums = [0]
Output: [0]
```

**Example 4:**

```text
Input: nums = [1]
Output: [1]
```

**Constraints:**

- `n == nums.length`
- `1 <= n <= 300`
- `nums[i]` is `0`, `1`, or `2`.

**Follow up:** Could you come up with a one-pass algorithm using only constant extra space?

## 题解

因为一共就三个数：`0`、`1` 和 `2`，所以我们可以简单地把 `0` 往前面置换，把 `2` 往后面置换。

具体来说，左指针指向开头，右指针指向末尾。

现在从左指针的位置开始遍历数组。当发现 `0` 时，把它和左指针指向的元素交换，左指针右移；当发现 `2` 时，把它和右指针指向的元素交换，右指针左移。

这是我一开始的想法，但这样有一个致命的问题，如果交换后的元素仍然是 `2`，此时继续向后遍历就漏过了一个元素。参考了题解，这时候应该重复交换元素，直到交换后的元素不是 `2`。对于 `0` 则只需要交换一次，因为即使交换后还是 `0`，说明到当前元素为止前面都是 `0`，继续向后遍历也不会出问题。

这样我们就完成了进阶要求：一次遍历，且用常数的额外空间。

最后用 Golang 的实现如下（参考了题解）：

```go
func sortColors(nums []int) {
    left, right := 0, len(nums)-1
    for i := left; i <= right; i++ {
        for i <= right && nums[i] == 2 {
            nums[i], nums[right] = nums[right], nums[i]
            right--
        }
        if nums[i] == 0 {
            nums[left], nums[i] = nums[i], nums[left]
            left++
        }
    }
}
```
