---
title: "4. Median of Two Sorted Arrays"
date: 2021-04-25
lastmod: 2021-04-25
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 4 题](https://leetcode-cn.com/problems/median-of-two-sorted-arrays)的题解。

<!--more-->

## 题目

Given two sorted arrays `nums1` and `nums2` of size `m` and `n` respectively, return **the median** of the two sorted arrays.

**Example 1:**

```text
Input: nums1 = [1,3], nums2 = [2]
Output: 2.00000
Explanation: merged array = [1,2,3] and median is 2.
```

**Example 2:**

```text
Input: nums1 = [1,2], nums2 = [3,4]
Output: 2.50000
Explanation: merged array = [1,2,3,4] and median is (2 + 3) / 2 = 2.5.
```

**Example 3:**

```text
Input: nums1 = [0,0], nums2 = [0,0]
Output: 0.00000
```

**Example 4:**

```text
Input: nums1 = [], nums2 = [1]
Output: 1.00000
```

**Example 5:**

```text
Input: nums1 = [2], nums2 = []
Output: 2.00000
```

**Constraints:**

- `nums1.length == m`
- `nums2.length == n`
- `0 <= m <= 1000`
- `0 <= n <= 1000`
- `1 <= m + n <= 2000`
- `-106 <= nums1[i], nums2[i] <= 106`

**Follow up:** The overall run time complexity should be `O(log (m+n))`.

## 题解

进阶要求需要二分查找，但这题的二分查找比较复杂，我太菜了，所以暂时放弃了，改用归并算法，时间复杂度为 `O(m+n)`。

这里只需要计数就行，不需要额外用空间去存储归并后的数组，因此空间复杂度可以做到 `O(1)`。

归并的思路比较简单（我这个菜鸟竟然写了半天），这里不展开了，最后用 Golang 的实现如下：

```go
func findMedianSortedArrays(nums1 []int, nums2 []int) float64 {
    m, n := len(nums1), len(nums2)
    even := (m+n)%2 == 0
    var i, j, num, last int
    for k := (m + n) / 2; k >= 0; k-- {
        last = num
        if i == m {
            num = nums2[j]
            j++
        } else if j == n {
            num = nums1[i]
            i++
        } else {
            if nums1[i] < nums2[j] {
                num = nums1[i]
                i++
            } else {
                num = nums2[j]
                j++
            }
        }
    }
    if even {
        return (float64(last) + float64(num)) / 2
    } else {
        return float64(num)
    }
}
```
