---
title: "348. Design Tic-Tac-Toe"
date: 2021-05-15
lastmod: 2021-05-15
tags: [Golang, 数据结构与算法]
categories: [LeetCode]
draft: true
---

[LeetCode 刷题笔记系列](/posts/leetcode/leetcode)，力扣（LeetCode）[第 348 题](https://leetcode-cn.com/problems/design-tic-tac-toe)的题解。

<!--more-->

## 题目

Assume the following rules are for the tic-tac-toe game on an `n x n` board between two players:

1. A move is guaranteed to be valid and is placed on an empty block.
2. Once a winning condition is reached, no more moves are allowed.
3. A player who succeeds in placing `n` of their marks in a horizontal, vertical, or diagonal row wins the game.

Implement the `TicTacToe` class:

- `TicTacToe(int n)` Initializes the object the size of the board `n`.
- `int move(int row, int col, int player)` Indicates that player with id `player` plays at the cell `(row, col)` of the board. The move is guaranteed to be a valid move.

**Follow up:**  
Could you do better than `O(_n_2)` per `move()` operation?

**Example 1:**

```text
Input
["TicTacToe", "move", "move", "move", "move", "move", "move", "move"]
[[3], [0, 0, 1], [0, 2, 2], [2, 2, 1], [1, 1, 2], [2, 0, 1], [1, 0, 2], [2, 1, 1]]
Output
[null, 0, 0, 0, 0, 0, 0, 1]

Explanation
TicTacToe ticTacToe = new TicTacToe(3);
Assume that player 1 is "X" and player 2 is "O" in the board.
ticTacToe.move(0, 0, 1); // return 0 (no one wins)
|X| | |
| | | |    // Player 1 makes a move at (0, 0).
| | | |

ticTacToe.move(0, 2, 2); // return 0 (no one wins)
|X| |O|
| | | |    // Player 2 makes a move at (0, 2).
| | | |

ticTacToe.move(2, 2, 1); // return 0 (no one wins)
|X| |O|
| | | |    // Player 1 makes a move at (2, 2).
| | |X|

ticTacToe.move(1, 1, 2); // return 0 (no one wins)
|X| |O|
| |O| |    // Player 2 makes a move at (1, 1).
| | |X|

ticTacToe.move(2, 0, 1); // return 0 (no one wins)
|X| |O|
| |O| |    // Player 1 makes a move at (2, 0).
|X| |X|

ticTacToe.move(1, 0, 2); // return 0 (no one wins)
|X| |O|
|O|O| |    // Player 2 makes a move at (1, 0).
|X| |X|

ticTacToe.move(2, 1, 1); // return 1 (player 1 wins)
|X| |O|
|O|O| |    // Player 1 makes a move at (2, 1).
|X|X|X|
```

**Constraints:**

- `2 <= n <= 100`
- player is `1` or `2`.
- `1 <= row, col <= n`
- `(row, col)` are **unique** for each different call to `move`.
- At most `n2` calls will be made to `move`.

## 最初解法

暴力法，依次遍历所有行、列，主、副对角线，判断是否全为 `player`。

时间和空间复杂度都为 `O(n^2)`，用 Golang 的实现如下：

```go
type TicTacToe struct {
    board [][]int
}

func Constructor(n int) TicTacToe {
    board := make([][]int, n)
    for i := range board {
        board[i] = make([]int, n)
    }
    return TicTacToe{board}
}

func (this *TicTacToe) Move(row int, col int, player int) int {
    this.board[row][col] = player

    n := len(this.board)
    for i := 0; i < n; i++ {
        j := 0
        for j < n {
            if this.board[i][j] != player {
                break
            }
            j++
        }
        if j == n {
            return player
        }

        k := 0
        for k < n {
            if this.board[k][i] != player {
                break
            }
            k++
        }
        if k == n {
            return player
        }
    }

    i := 0
    for i < n {
        if this.board[i][i] != player {
            break
        }
        i++

    }
    if i == n {
        return player
    }

    i = 0
    for i < n {
        if this.board[i][n-i-1] != player {
            break
        }
        i++
    }
    if i == n {
        return player
    }

    return 0
}
```

## 优化解法

参考其他题解，因为就两个玩家，一个落子记为 `1`，另一个记为 `-1`，那我们只需要判断所有行、列以及主、副对角线的和即可。

时间复杂度都为 `O(1)`，空间复杂度为 `O(n)`，用 Golang 的实现如下：

```go
type TicTacToe struct {
    n    int
    rows []int
    cols []int
    main int
    sub  int
}

func Constructor(n int) TicTacToe {
    rows := make([]int, n)
    cols := make([]int, n)
    return TicTacToe{n, rows, cols, 0, 0}
}

func (this *TicTacToe) Move(row int, col int, player int) int {
    val := 1
    win := this.n
    if player == 2 {
        val = -1
        win = -this.n
    }

    this.rows[row] += val
    if this.rows[row] == win {
        return player
    }

    this.cols[col] += val
    if this.cols[col] == win {
        return player
    }

    if row == col {
        this.main += val
    }
    if this.main == win {
        return player
    }

    if row+col == this.n-1 {
        this.sub += val
    }
    if this.sub == win {
        return player
    }

    return 0
}
```
