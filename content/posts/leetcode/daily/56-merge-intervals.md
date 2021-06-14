---
title: "56. Merge Intervals"
date: 2021-05-11
lastmod: 2021-05-11
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 56 题](https://leetcode-cn.com/problems/merge-intervals)的题解。

<!--more-->

## 题目

Given an array of `intervals` where `intervals[i] = [starti, endi]`, merge all overlapping intervals, and return _an array of the non-overlapping intervals that cover all the intervals in the input_.

**Example 1:**

```text
Input: intervals = [[1,3],[2,6],[8,10],[15,18]]
Output: [[1,6],[8,10],[15,18]]
Explanation: Since intervals [1,3] and [2,6] overlaps, merge them into [1,6].
```

**Example 2:**

```text
Input: intervals = [[1,4],[4,5]]
Output: [[1,5]]
Explanation: Intervals [1,4] and [4,5] are considered overlapping.
```

**Constraints:**

- `1 <= intervals.length <= 104`
- `intervals[i].length == 2`
- `0 <= starti <= endi <= 104`

## 题解

感觉和会议室那题差不多，然后写了半天写不对，看了一下题解……

首先，肯定是按起始时间排序，这个很容易想到。

之后，问题在于怎么合并排好序的时间区间。如果某个区间的开始时间比之前所有区间的结束时间都大，那么它与之前的区间一定不重合；反之，区间是有重合的。对于重合的区间，需要取结束时间的最大值。

注意，题目确保至少存在一个区间，当返回内容为空时，直接添加第一个区间即可。

最后用 Golang 的实现如下：

```go
type ints [][]int

func (s ints) Len() int {
    return len(s)
}

func (s ints) Swap(x, y int) {
    s[x], s[y] = s[y], s[x]
}

func (s ints) Less(x, y int) bool {
    return s[x][0] < s[y][0]
}

func merge(intervals [][]int) [][]int {
    sort.Sort(ints(intervals))
    res := [][]int{}
    for _, interval := range intervals {
        if len(res) == 0 || res[len(res)-1][1] < interval[0] {
            res = append(res, interval)
        } else if interval[1] > res[len(res)-1][1] {
            res[len(res)-1][1] = interval[1]
        }
    }
    return res
}
```
