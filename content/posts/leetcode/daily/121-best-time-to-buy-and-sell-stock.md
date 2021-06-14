---
title: "121. Best Time to Buy and Sell Stock"
date: 2021-05-04
lastmod: 2021-05-04
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 121 题](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock)的题解。

<!--more-->

## 题目

You are given an array `prices` where `prices[i]` is the price of a given stock on the `ith` day.

You want to maximize your profit by choosing a **single day** to buy one stock and choosing a **different day in the future** to sell that stock.

Return _the maximum profit you can achieve from this transaction_. If you cannot achieve any profit, return `0`.

**Example 1:**

```text
Input: prices = [7,1,5,3,6,4]
Output: 5
Explanation: Buy on day 2 (price = 1) and sell on day 5 (price = 6), profit = 6-1 = 5.
Note that buying on day 2 and selling on day 1 is not allowed because you must buy before you sell.
```

**Example 2:**

```text
Input: prices = [7,6,4,3,1]
Output: 0
Explanation: In this case, no transactions are done and the max profit = 0.
```

**Constraints:**

- `1 <= prices.length <= 105`
- `0 <= prices[i] <= 104`

## 题解

把买和卖的天数分别记为 `buy` 和 `sell`，利润（`profit`）为 `prices[sell] - prices[buy]`。因为不能在同一天进行买和卖操作，所以理论上 `buy` 不能等于 `sell`，但即使这两者相等，`profit` 也是正好等于 `0`，所以不影响。

遍历 `prices`，如果发现当前的价格低于买入价格，那么应该在这一天买入（`buy = day`），如果此时卖出在买入前，把卖出的天数也同步到这一天（`sell = buy`）；如果当前的价格大于卖出价格，那么应该在这一天卖出（`sell = day`）。如果发生了买或者卖操作，那么重新计算利润，保存最大值。

最后用 Golang 的实现如下：

```go
func maxProfit(prices []int) int {
    buy, sell := 0, 0
    max := 0
    for day := 1; day < len(prices); day++ {
        action := false
        if prices[day] < prices[buy] {
            buy = day
            if sell < buy {
                sell = buy
            }
            action = true
        } else if prices[day] > prices[sell] {
            sell = day
            action = true
        }
        if action {
            profit := prices[sell] - prices[buy]
            if profit > max {
                max = profit
            }
        }
    }
    return max
}
```
