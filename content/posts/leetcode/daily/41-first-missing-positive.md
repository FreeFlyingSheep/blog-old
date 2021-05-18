---
title: "41. First Missing Positive"
date: 2021-05-18
lastmod: 2021-05-18
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 41 题](https://leetcode-cn.com/problems/first-missing-positive)的题解。

<!--more-->

## 题目

Given an unsorted integer array `nums`, find the smallest missing positive integer.

You must implement an algorithm that runs in `O(n)` time and uses constant extra space.

**Example 1:**

```text
Input: nums = [1,2,0]
Output: 3
```

**Example 2:**

```text
Input: nums = [3,4,-1,1]
Output: 2
```

**Example 3:**

```text
Input: nums = [7,8,9,11,12]
Output: 1
```

**Constraints:**

- `1 <= nums.length <= 5 * 105`
- `-231 <= nums[i] <= 231 - 1`

## 题解

又是抄题解的一天……如果没有空间复杂度的限制，用哈希表很容易完成。

但因为不允许用额外的空间，所以必须就地解决。考虑把现在的数组恢复成有序的，即元素 `nums[i]` 应该出现在数组的 `nums[i] - 1`（记为 `num`）的位置。于是我们简单地交换 `nums[i]` 和 `nums[num]`。对于小于 `0` 或者大于等于数组长度的 `num`，跳过即可。

这时候会有一个问题，交换后的 `nums[num]` 是在正确的位置了，换过来的 `nums[i]` 未必在正确的位置，所以在继续向后遍历前，我们要交换直到 `nums[i]` 处在正确的位置。同时，为了避免死循环，交换前还应该判断交换的两个元素是否相同。

遍历完成后，我们确保元素出现在了数组正确的位置上（除了小于 `0` 或者大于等于数组长度的元素）。假定所有元素都是正确的，这时候我们再次遍历数组，数组的第 `i` 个元素的值应该为 `i + 1`。第一个不满足该条件的值就是缺失的最小正数。如果所有元素都满足，那返回 `len(nums) + 1` 即可。

最后用 Golang 的实现如下：

```go
func firstMissingPositive(nums []int) int {
    for i := range nums {
        num := nums[i] - 1
        for num >= 0 && num < len(nums) && nums[i] != nums[num] {
            nums[i], nums[num] = nums[num], nums[i]
            num = nums[i] - 1
        }
    }
    for i := range nums {
        if nums[i] != i+1 {
            return i + 1
        }
    }
    return len(nums) + 1
}
```
