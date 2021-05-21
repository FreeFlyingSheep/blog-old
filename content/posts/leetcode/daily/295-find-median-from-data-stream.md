---
title: "295. Find Median from Data Stream"
date: 2021-05-21
lastmod: 2021-05-21
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 295 题](https://leetcode-cn.com/problems/find-median-from-data-stream)的题解。

<!--more-->

## 题目

The **median** is the middle value in an ordered integer list. If the size of the list is even, there is no middle value and the median is the mean of the two middle values.

- For example, for `arr = [2,3,4]`, the median is `3`.
- For example, for `arr = [2,3]`, the median is `(2 + 3) / 2 = 2.5`.

Implement the MedianFinder class:

- `MedianFinder()` initializes the `MedianFinder` object.
- `void addNum(int num)` adds the integer `num` from the data stream to the data structure.
- `double findMedian()` returns the median of all elements so far. Answers within `10-5` of the actual answer will be accepted.

**Example 1:**

```text
Input
["MedianFinder", "addNum", "addNum", "findMedian", "addNum", "findMedian"]
[[], [1], [2], [], [3], []]
Output
[null, null, null, 1.5, null, 2.0]

Explanation
MedianFinder medianFinder = new MedianFinder();
medianFinder.addNum(1);    // arr = [1]
medianFinder.addNum(2);    // arr = [1, 2]
medianFinder.findMedian(); // return 1.5 (i.e., (1 + 2) / 2)
medianFinder.addNum(3);    // arr[1, 2, 3]
medianFinder.findMedian(); // return 2.0
```

**Constraints:**

- `-105 <= num <= 105`
- There will be at least one element in the data structure before calling `findMedian`.
- At most `5 * 104` calls will be made to `addNum` and `findMedian`.

**Follow up:**

- If all integer numbers from the stream are in the range `[0, 100]`, how would you optimize your solution?
- If `99%` of all integer numbers from the stream are in the range `[0, 100]`, how would you optimize your solution?

## 题解

最容易想到的是用一个数组，每次求中位数的时候排序，这样大概率超时。

之后从排序出发，想到用每次插入都用插入排序，就能把整体时间复杂度降低。

再想优化，就考虑用一些查找树的数据结构，但 Golang 的库不提供，而且插入排序能过，我也没准备实现搜索树。

有一点要注意，往切片中间插入一个元素时，应该先扩容，然后再拷贝：

```go
nums = append(nums, 0)
copy(nums[i+1:], nums[i:])
nums[i] = num
```

当然也可以用一个临时切片，但那样会浪费空间，虽然无大碍，但不建议那么写。

最后用 Golang 的实现如下（插入排序）：

```go
type MedianFinder struct {
    nums []int
}

func Constructor() MedianFinder {
    return MedianFinder{}
}

func (this *MedianFinder) AddNum(num int) {
    i := 0
    for i < len(this.nums) {
        if this.nums[i] >= num {
            break
        }
        i++
    }
    this.nums = append(this.nums, 0)
    copy(this.nums[i+1:], this.nums[i:])
    this.nums[i] = num
}

func (this *MedianFinder) FindMedian() float64 {
    l := len(this.nums)
    if l%2 == 0 {
        return (float64(this.nums[l/2-1]) + float64(this.nums[l/2])) / 2
    } else {
        return float64(this.nums[l/2-1])
    }
}
```
