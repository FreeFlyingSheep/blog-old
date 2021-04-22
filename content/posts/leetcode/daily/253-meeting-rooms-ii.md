---
title: "253. Meeting Rooms II"
date: 2021-04-22
lastmod: 2021-04-22
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

<!--more-->

## 题目

Given an array of meeting time intervals `intervals` where `intervals[i] = [starti, endi]`, return _the minimum number of conference rooms required_.

**Example 1:**

```text
Input: intervals = [[0,30],[5,10],[15,20]]
Output: 2
```

**Example 2:**

```text
Input: intervals = [[7,10],[2,4]]
Output: 1
```

**Constraints:**

- `1 <= intervals.length <= 104`
- `0 <= starti < endi <= 106`

## 最初解法

该解法会超时，思路仅供参考！

如果两个会议时间段有重合，那么就需要多开一个会议室。需要的会议室个数即所有会议的时间段重合的层数。

用位图来记录每个时间点使用的会议的个数，所求的会议室个数就等于层数的最大值。

需要注意会议的时间段是左闭右开区间，题目没说清楚。

最后用 Golang 的实现如下：

```go
func minMeetingRooms(intervals [][]int) int {
    bits := make(map[int]int)
    for _, interval := range intervals {
        start := interval[0]
        end := interval[1]
        for i := start; i < end; i++ {
            if _, ok := bits[i]; !ok {
                bits[i] = 1
            } else {
                bits[i]++
            }
        }
    }

    max := 0
    for bit := range bits {
        if bits[bit] > max {
            max = bits[bit]
        }
    }
    return max
}
```

## 优化解法

参考题解，有两种解法，一个是借助最小堆，另一个是序列化。

由于 Golang 没内置优先队列和最小堆的实现，所以这里为了偷懒，仅考虑序列化的解法。

把所有会议的开始时间和结束时间放两个数组，对这两个数组进行排序。用 `start` 和 `end` 分别指向开始时间和结束时间的数组。

如果 `start` 对应的时间小于 `end` 对应的时间，说明还有会议没结束，需要多开一个会议室，然后 `start` 向后移动一格；反之，有空闲的会议室，`end` 向后移动一格。

最后用 Golang 的实现如下：

```go
func minMeetingRooms(intervals [][]int) int {
    var starts, ends []int
    for _, interval := range intervals {
        starts = append(starts, interval[0])
        ends = append(ends, interval[1])
    }
    sort.Ints(starts)
    sort.Ints(ends)

    total := 0
    start, end := 0, 0
    for start < len(starts) {
        if starts[start] < ends[end] {
            total++
        } else {
            end++
        }
        start++
    }
    return total
}
```
