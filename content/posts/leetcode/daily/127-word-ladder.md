---
title: "127. Word Ladder"
date: 2021-05-31
lastmod: 2021-05-31
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 127 题](https://leetcode-cn.com/problems/word-ladder)的题解。

<!--more-->

## 题目

A **transformation sequence** from word `beginWord` to word `endWord` using a dictionary `wordList` is a sequence of words `beginWord -> s1 -> s2 -> ... -> sk` such that:

- Every adjacent pair of words differs by a single letter.
- Every `si` for `1 <= i <= k` is in `wordList`. Note that `beginWord` does not need to be in `wordList`.
- `sk == endWord`

Given two words, `beginWord` and `endWord`, and a dictionary `wordList`, return _the **number of words** in the **shortest transformation sequence** from_ `beginWord` _to_ `endWord`_, or_ `0` _if no such sequence exists._

**Example 1:**

```text
Input: beginWord = "hit", endWord = "cog", wordList = Explanation:["hot","dot","dog","lot","log","cog"Explanation:]
Output: 5
Explanation: One shortest transformation sequence is "hit" -> "hot" -> "dot" -> "dog" -> cog", which is 5 words long.
```

**Example 2:**

```text
Input: beginWord = "hit", endWord = "cog", wordList = Explanation:["hot","dot","dog","lot","log"Explanation:]
Output: 0
Explanation: The endWord "cog" is not in wordList, therefore there is no valid transformation sequence.
```

**Constraints:**

- `1 <= beginWord.length <= 10`
- `endWord.length == beginWord.length`
- `1 <= wordList.length <= 5000`
- `wordList[i].length == beginWord.length`
- `beginWord`, `endWord`, and `wordList[i]` consist of lowercase English letters.
- `beginWord != endWord`
- All the words in `wordList` are **unique**.

## 解题思路

最容易想到的是用回溯法穷举所有情况，但这一定超时，我都懒得试了。

参考题解，根本没想到这题本质是考察图。

这题的第一个难点在于想到构建图，然后用广度优先搜索。题解中说了“看到最短首先想到的就是广度优先搜索”和“想到广度优先搜索自然而然的就能想到图”，那就记一下吧……

先考虑构建这样的图：每个单词都是图中的结点，所有相差一个字母的单词结点间是存在路径的。

这题的第二个难点在于怎么优化构建图的过程。如果枚举所有单词组合，那样效率太低了。

题解中给了一种利用虚拟结点的办法，比如对于单词 `hit`，创建三个虚拟节点 `*it`、`h*t`、`hi*`，并让 `hit` 向这三个虚拟节点分别连一条边。

当然，因为加入了虚拟结点，最后求最短路径的时候，要把长度减半。同时考虑边界，由于并未把起点算进去，所以最终结果是求得的距离的一半再加一。

如果能想到以上两点，这题基本就能做出来了，然而这还不是最优解法。

这题的第三个难点是怎么优化广度优先搜索。可以一边从 `beginWord` 开始，另一边从 `endWord` 开始，使用双向广度优先搜索的算法，来大大提高效率。

代码暂时不考虑写了。
