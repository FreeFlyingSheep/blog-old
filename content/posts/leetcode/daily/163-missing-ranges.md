---
title: "163. Missing Ranges"
date: 2021-04-12
lastmod: 2021-04-13
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: false
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 163 题](https://leetcode-cn.com/problems/missing-ranges)的题解。

<!--more-->

## 题目

You are given an inclusive range `[lower, upper]` and a **sorted unique** integer array `nums`, where all elements are in the inclusive range.

A number `x` is considered **missing** if `x` is in the range `[lower, upper]` and `x` is not in `nums`.

Return _the **smallest sorted** list of ranges that **cover every missing number exactly**_. That is, no element of `nums` is in any of the ranges, and each missing number is in one of the ranges.

Each range `[a,b]` in the list should be output as:

- `"a->b"` if `a != b`
- `"a"` if `a == b`

**Example 1:**

```text
Input: `nums = [0,1,3,50,75], lower = 0, upper = 99`
Output: `["2","4->49","51->74","76->99"]`
Explanation: The ranges are:
[2,2] --> "2"
[4,49] --> "4->49"
[51,74] --> "51->74"
[76,99] --> "76->99"
```

**Example 2:**

```text
Input: nums = [], lower = 1, upper = 1
Output: ["1"]
Explanation: The only missing range is [1,1], which becomes "1".
```

**Example 3:**

```text
Input: nums = [], lower = -3, upper = -1
Output: ["-3->-1"]
Explanation: The only missing range is [-3,-1], which becomes "-3->-1".
```

**Example 4:**

```text
Input: nums = [-1], lower = -1, upper = -1
Output: []
Explanation: There are no missing ranges since there are no missing numbers.
```

**Example 5:**

```text
Input: nums = [-1], lower = -2, upper = -1
Output: ["-2"]
```

**Constraints:**

- `-109 <= lower <= upper <= 109`
- `0 <= nums.length <= 100`
- `lower <= nums[i] <= upper`
- All the values of `nums` are **unique**.

## 题解

### 最初解法

因为给定数组已经是排好序的，而且数组元素是不重复的，所以只需要一次遍历即可。

每次遍历的时候比较数组前（`lower`）后（`upper`）两个元素的差，如果等于 `2`；则直接输出 `lower + 1`，如果大于 `2`，则输出 `lower + 1 -> upper - 1`。或者，当差大于 `1` 时，总是计算 `lower + 1` 和 `upper - 1`，如果它们相等，输出 `lower + 1`，反之输出 `lower + 1 -> upper - 1`。

但不能忘记开头和结尾要单独处理：

```text
[99]
0
100
```

虽然 `100 - 99` 的值为 `1`，但此时 `100` 也应该被输出。进一步观察发现，开头和结尾只需要传递 `lower - 1` 和 `upper + 1` 就能利用通用的判断方法。

这时候基本解完了，但千万别忘了数组长度为 `0` 的特例：

```text
[]
1
2
```

最后用 Golang 的实现如下：

```go
func find(lower, upper int, res *[]string) {
    if upper-lower > 1 {
        begin := strconv.Itoa(lower + 1)
        end := strconv.Itoa(upper - 1)
        if begin == end {
            *res = append(*res, begin)
        } else {
            *res = append(*res, begin+"->"+end)
        }
    }
}

func findMissingRanges(nums []int, lower int, upper int) []string {
    var res []string
    if len(nums) == 0 {
        find(lower-1, upper+1, &res)
        return res
    }

    find(lower-1, nums[0], &res)
    l := len(nums) - 1
    for i := 0; i < l; i++ {
        find(nums[i], nums[i+1], &res)
    }
    find(nums[l], upper+1, &res)
    return res
}
```

### 优化解法

上面的解法比较丑陋，因为为了处理开头和结尾，特地提取了 `find` 函数，然后分了三块来处理。

看过其他人的题解后发现，只需要用一个变量 `last` 记录上个数（把 `last` 初始化为 `lower - 1`），同时把 `upper + 1` 也加入数组末尾，不就不需要特殊处理了嘛，甚至连数组长度为 `0` 的特例也解决了！

优化后的解法如下：

```go
func findMissingRanges(nums []int, lower int, upper int) []string {
    var res []string
    nums = append(nums, upper+1)
    last := lower - 1
    for _, num := range nums {
        diff := num - last
        if diff == 2 {
            res = append(res, strconv.Itoa(last+1))
        } else if diff > 2 {
            begin := strconv.Itoa(last + 1)
            end := strconv.Itoa(num - 1)
            res = append(res, begin+"->"+end)
        }
        last = num
    }
    return res
}
```
