---
title: "42. Trapping Rain Water"
date: 2021-04-20
lastmod: 2021-04-20
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

力扣（LeetCode）[第 42 题](https://leetcode-cn.com/problems/trapping-rain-water)的题解。

<!--more-->

## 题目

Given `n` non-negative integers representing an elevation map where the width of each bar is `1`, compute how much water it can trap after raining.

**Example 1:**

![Example 1](/images/leetcode/daily/42-trapping-rain-water/rainwatertrap.png)

```text
Input: height = [0,1,0,2,1,0,1,3,2,1,2,1]
Output: 6
Explanation: The above elevation map (black section) is represented by array [0,1,0,2,1,0,1,3,2,1,2,1]. In this case, 6 units of rain water (blue section) are being trapped.
```

**Example 2:**

```text
Input: height = [4,2,0,3,2,5]
Output: 9
```

**Constraints:**

- `n == height.length`
- `0 <= n <= 3 * 104`
- `0 <= height[i] <= 105`

## 最初解法

下面把图中的格子视为方块。先计算出最大高度，再用双重循环，从上往下，从走往右遍历，依次计算每一层可能积水的方块个数。

对于每一层，仅当左和右都有达到这一层高度的方块时，才可能积水（只有当两边高，中间低的时候才会积水）。

具体来说，当左边出现一个满足高度的方块时，开始计数，直到寻找到第一个满足高度的右方块或者遍历到底。如果找到这样的右方块，把计数的方块累加到总和里，然后从把这个右方块视为新的左方块继续寻找。

这是一个很糟糕的暴力解法，最后用 Golang 的实现如下：

```go
func trap(height []int) int {
    max := 0
    for _, h := range height {
        if h > max {
            max = h
        }
    }

    total := 0
    for i := max; i >= 0; i-- {
        for j := 0; j < len(height); j++ {
            count := 0
            if height[j] >= i {
                j++
                for j < len(height) && height[j] < i {
                    count++
                    j++
                }
                if j < len(height) {
                    total += count
                    j--
                }
            }
        }
    }
    return total
}
```

### 优化思路

我的暴力解法和官方题解的暴力解法不一样，我这种做法有点偏了，很难基于这种思路去优化。时间复杂度应该是 `O(mn)`，其中 `m` 是最大高度。

官方题解的暴力解法是对每个元素都向左向右扫描，水能达到的最高位置等于两边最大高度的较小值减去当前高度的值，时间复杂度是 `O(n^2)`。

参考官方题解，对应官方的暴力做法，有三种更好的解法思路：动态规划、单调栈、双指针。

这些做法我准备等以后遇到更典型的题目后，再回过头来看（鸽了）。
