//
//  Chapter9.swift
//  CrackingCodeInterview
//
//  Created by Andrea Bizzotto on 02/08/2014.
//  Copyright (c) 2014 musevisions. All rights reserved.
//

import Foundation

// A child is running up a staircase with n steps, and can hop either 1 step, 2 steps, or 3 steps at a time.
// Implement a method to count how many possible ways the child can run up the stairs.
public struct Chapter9_Exercise1 : ExerciseRunnable {

    static func hops(startPos: Int, steps: Int) -> Int {
        if startPos == steps {
            return 0
        }
        if startPos == steps - 1 {
            return 1 // 1 hop
        }
        if startPos == steps - 2 {
            return 2 // either 1 + 1, or 2
        }
        if startPos == steps - 3 {
            // 1 1 1, 2 1, 1 2, 3
            return 4
        }
        // Any other case, 3 choices
        let steps1 = hops(startPos + 1, steps: steps)
        let steps2 = hops(startPos + 2, steps: steps)
        let steps3 = hops(startPos + 3, steps: steps)
        return steps1 + steps2 + steps3
    }
    static func hops(steps: Int) -> Int {
        
        var base : [Int] = Array(count : steps, repeatedValue : 0)
        base[0] = 1
        base[1] = 2
        base[2] = 4
        for var i = 3; i < steps; i++ {
            base[i] = base[i - 1] + base[i - 2] + base[i - 3]
        }
        return base[steps - 1]
    }
    static func hopsTopDown(steps: Int, inout map: [Int]) -> Int {
        
        if steps <= 3 {
            return map[steps - 1]
        }
        
        if map[steps - 1] > 0 {
            return map[steps - 1]
        }
        // Works but it's O(n^3)
        map[steps - 1] = hopsTopDown(steps - 1, map: &map) + hopsTopDown(steps - 2, map: &map) + hopsTopDown(steps - 3, map: &map)
        return map[steps - 1]
    }
    
    static func exercise1(steps: Int) -> Int {
        // We took k hops to get to position m, we can then move to position m + 1, m + 2, m + 3 i n k + 1 hops
        
        //return hops(0, steps: steps)
        return hops(steps)
    }
    
    static func testExercise1(steps: Int) {
        var map = Array(count: steps, repeatedValue: 0)
        map[0] = 1
        map[1] = 2
        map[2] = 4
        print("\(steps), hops: \(hopsTopDown(steps, map: &map))")
        
        // Solved in 15 min recursively
        // Another 10 minutes to come up with dynamic programming approach which takes linear time.
    }
    public static func run() {
        testExercise1(4)
        testExercise1(5)
        testExercise1(10)
        testExercise1(14)
        testExercise1(20)
        testExercise1(36)
    }
}

// Imagine a robot sitting on the upper left corner of an X by Y grid. The robot can only move in two directions: right and down
// How many possible paths are there for the robot to go from (0, 0) to (X, Y)?
// FOLLOW UP
// Imagine certain spots are "off limits", such that the robot cannot step on them. Design an algorithm to find a path for the robot from the
// top left to the bottom right
public struct Chapter9_Exercise2 : ExerciseRunnable {

    // TODO: Re-implement!
    static func exercise2(X: Int, Y: Int, inout grid : [[Int]]) -> Int {
        
        if X < 1 || Y < 1 {
            return 0 // Negative grid
        }
        if Y > 1 {
            grid[1][0] = 1
        }
        if X > 1 {
            grid[0][1] = 1
        }
        for var y = 0; y < Y; y++ {
            for var x = 0; x < X; x++ {
                if x == 0 && y == 0 || y == 0 && x == 1 || y == 1 && x == 0 {
                    continue
                }
                if grid[y][x] == -1 {
                    continue
                }
                var allowed = false
                if x > 0 {
                    if grid[y][x - 1] != -1 {
                        grid[y][x] += grid[y][x - 1] // + 1
                        allowed = true
                    }
                }
                if y > 0 {
                    if grid[y - 1][x] != -1 {
                        grid[y][x] += grid[y - 1][x] // + 1
                        allowed = true
                    }
                    if !allowed {
                        grid[y][x] = -1
                    }
                }
            }
        }
        //        print("Y: \(Y), X: \(X), steps : \(grid[Y - 1][X - 1])")
        return grid[Y - 1][X - 1]
    }
    static func findPath(X: Int, Y: Int, var grid : [[Int]]) -> [(Int, Int)] {
        var path : [(Int, Int)] = Array()
        var y = Y - 1
        var x = X - 1
        path.insert((y, x), atIndex: 0)
        while x > 0 || y > 0 {
            if y > 0 {
                if grid[y - 1][x] != -1 {
                    path.insert((y - 1, x), atIndex: 0)
                }
                y--
                continue
            }
            if x > 0 {
                if grid[y][x - 1] != -1 {
                    path.insert((y, x - 1), atIndex: 0)
                }
                x--
                continue
            }
        }
        for (row, col) in path {
            print("(\(row), \(col))")
        }
        return path
    }
    
    static func testExercise2Grid(X: Int, Y: Int) {
        
        var grid : [[Int]] = Array(count: Y, repeatedValue: Array(count: X, repeatedValue: 0))
        exercise2(X, Y: Y, grid: &grid)
        print("Y: \(Y), X: \(X), steps : \(grid[Y - 1][X - 1])")
    }
    static func testExercise2() {
        testExercise2Grid(2, Y: 1)
        testExercise2Grid(1, Y: 2)
        testExercise2Grid(2, Y: 2)
        testExercise2Grid(3, Y: 2)
        testExercise2Grid(2, Y: 3)
        testExercise2Grid(3, Y: 3)
        testExercise2Grid(4, Y: 4)
        testExercise2Grid(5, Y: 5)
    }
    static func testExercise2Path() {
        
        var grid : [[Int]] = Array(count: 4, repeatedValue: Array(count: 4, repeatedValue: 0))
        grid[2][1] = -1
        grid[1][2] = -1
        grid[3][2] = -1
        //grid[2][3] = -1
        if exercise2(4, Y: 4, grid: &grid) != -1 {
            findPath(4, Y: 4, grid: grid)
        }
        
        // completed both assignments in 20 minutes
        // Extra 10 minutes for findPath
        // WRONG SOlution: Does not need to add 2 at each new grid cell -> It is indeed and "n choose r" problem.
        // For Greedy solvers, hash tables with point coordinates on grid as keys can be optimal space solution.
        
        // Consider using caches to solve dynamic programming problems
    }
    public static func run() {
        testExercise2()
        testExercise2Path()
    }

}

// A magic index in an array  A[0...n-1] is defined to be an index such that A[i] = i. Given a sorted array of distinct integers,
// write a method to find a magic index, if one exists, in array A.
// FOLLOW UP
// What if the values are not distinct?
public struct Chapter9_Exercise3 : ExerciseRunnable {
    
    static func exercise3(a: [Int]) -> Int {
        //      0     1   2  3  4  5  6
        // A = [-20, -10, 0, 5, 5, 5, 5]
        
        // O(n) solution is trivial
        // Check in O(n)
        var left = 0
        var right = a.count - 1
        while left <= right {
            let middle = (left + right) / 2
            let b = a[middle]
            if middle == b {
                return middle
            }
            if middle > b {
                left = middle + 1
            }
            else {
                right = middle - 1
            }
        }
        return -1
    }
    
    static func testExercise3() {
        
        let magic = exercise3([-20, -10, 0, 3, 4, 7, 20])
        print("\(magic)")
        
        // Solution in 13 minutes, doesn't work for non-distinct values, which would require a linear scan instead.
        // Potentially just one split, and then move left or right -> n/2 elements
        // Optimal solution is still recursive
        // WTF Stop using iteration, use recursion more!
    }

    public static func run() {
        testExercise3()
    }
}

// Write a method to return all subsets of a set
public struct Chapter9_Exercise4 : ExerciseRunnable {

    static func exercise4(a : [Int]) -> [[Int]] {
        
        var result : [[Int]] = [a]
        for var i = 0; i < a.count; i++ {
            var copy = a
            copy.removeAtIndex(i)
            if copy.count > 0 {
                result.append(copy)
                if copy.count > 1 {
                    result.extend(exercise4(copy))
                }
            }
        }
        return result
    }
    
    static func exercise4Recursive(a : [Int], index : Int) -> [[Int]] {
        if index == 0 {
            return [[], [a[0]]]
        }
        let subsets = exercise4Recursive(a, index: index - 1)
        let current = a[index]
        var newSubsets : [[Int]] = subsets
        for subset in subsets {
            var newSubset = subset
            newSubset.append(current)
            newSubsets.append(newSubset)
        }
        return newSubsets
    }
    
    static func testExercise4() {
        
        let combinations = exercise4Recursive([1, 2, 3, 4], index:3)
        print("\(combinations)")
        
        // Returns results with duplicates. Use hash table to count duplicates? Requires hashing array uniquely
        // WRONG SOLUTION
        // Must use recursion and base case and build
        // Solution (N) = Append Element to each solution to (N-1) and add 1
        // There is also a solution of combinatorics nature, calculating sets from bit representations of all integers from 0 to 2^N
    }
    public static func run() {
        testExercise4()
    }

}

// Write a method to compute all permutations of a string of unique characters
public struct Chapter9_Exercise5 : ExerciseRunnable {

    static func permutations(s : String) -> [String] {
        if s.characters.count == 0 {
            return []
        }
        if s.characters.count == 1 {
            return [s]
        }
        let firstCharacter = s.substringWithRange(Range(start: s.startIndex, end: s.startIndex.successor()))
        let remaining = s.substringFromIndex(s.startIndex.successor())
        let strings = permutations(remaining)
        var newStrings : [String] = []
        for permutation in strings {
            newStrings.append(firstCharacter + permutation)
            for var i = permutation.startIndex.successor(); i != permutation.endIndex; i++ {
                newStrings.append(permutation.substringToIndex(i) + firstCharacter + permutation.substringFromIndex(i))
            }
            newStrings.append(permutation + firstCharacter)
        }
        print("\(s) produced \(newStrings)")
        return newStrings
    }
    static func testExercise5() {
        
        permutations("abcd")
        // Solved in 20 minutes
        // Code is a bit dirty but works, calculates in n! steps
    }
    public static func run() {
        testExercise5()
    }
}

// Implement an algorithm to print all valid (e.g., properly opened and closed) combinations of n-pairs of parentheses
// EXAMPLE:
// Input : 3
// Output: ((())), (()()), (())(), ()(()), ()()()
public struct Chapter9_Exercise6 : ExerciseRunnable {

    // TODO: Re-implement!
    static func parentheses(N: Int) -> [String] {
        
        // Given Sol(N) = set of solutions
        // Sol(N+1) = ()Sol(N), Sol(N)(), (Sol(N))
        if N <= 0 {
            return []
        }
        if N == 1 {
            return ["()"]
        }
        let subcase = parentheses(N - 1)
        var solution : [String] = []
        for s in subcase {
            let s1 = "()" + s
            solution.append(s1)
            let s2 = s + "()"
            if s1 != s2 {
                solution.append(s2)
            }
            solution.append("(" + s + ")")
        }
        return solution
    }
    
    static func parentheses(inout set: [String], s: String, leftRem : Int, rightRem : Int) {
        if leftRem == 0 && rightRem == 0 {
            set.append(s);
        }
        else {
            if leftRem > 0 {
                let sl = s + "(";
                parentheses(&set, s: sl, leftRem: leftRem - 1, rightRem: rightRem)
            }
            if rightRem > 0 && rightRem > leftRem {
                let sr = s + ")";
                parentheses(&set, s: sr, leftRem: leftRem, rightRem: rightRem - 1)
            }
        }
    }
    
    static func testExercise6() {
        let n = 4
        var set : [String] = []
        parentheses(&set, s: "", leftRem: n, rightRem: n)
        
        print("\(n): \(set)")
        // Solved in 11 min
        // Complexity
        // O(3^N)
        // Correct as we never close a parenthesis before one is open, recursively
        // Method has duplicates, doens't work
        // Book solution iteratively builds list with rules leftPar > 0, rightPar > leftPar
    }

    public static func run() {
        testExercise6()
    }
}

// Implement the "paint fill" function that one might see on many image editing programs. That is, given a screen
// (represented by a two-dimensional array of colors), a point, and a new color, fill the surrounding area until the color changes from the original color.
public struct Chapter9_Exercise7 : ExerciseRunnable {

    // TODO: Implement!
    
    //    enum Color {
    //        case Black, White, Red, Yellow, Green
    //    }
    //    func paintFill(screen: [[Color]], x: Int, y: Int, ocolor: Color, ncolor: Color) -> Bool {
    //        if x < 0 || x > screen[0].count || y < 0 || y > screen.count {
    //            return false
    //        }
    //        if screen[y][x] == ocolor {
    //            screen[y][x] = ncolor
    //            paintFill(screen, x: x - 1, y: y, ocolor: ocolor, ncolor: ncolor)
    //            paintFill(screen, x: x + 1, y: y, ocolor: ocolor, ncolor: ncolor)
    //            paintFill(screen, x: x, y: y - 1, ocolor: ocolor, ncolor: ncolor)
    //            paintFill(screen, x: x, y: y + 1, ocolor: ocolor, ncolor: ncolor)
    //        }
    //    }
    
    //    func paintFill
    static func exercise7() {
        
        // Not implemented, could not think that this was depth-first search on a graph
        // Very computationally expensive. Better to implement breadth-first
        
        // WRONT ANSWER
    }

    public static func run() {
        exercise7()
    }
}

// Given an infinite number of quarters (25 cents), dimes (10 cents), nickels (5 cents) and pennies (1 cent), write code
// to calculate the number of ways of representing n cents
public struct Chapter9_Exercise8 : ExerciseRunnable {

    // TODO: Implement!
    func exercise8() {
        // Base cases up to N = 25
        // N = 1...4 : 1
        // N = 5...9 : 2
        // N = 10..14 : 4
        // N = 15..19 : 6
        
        // Top down approach to solve recursion
        // If you can't understand the underlying property, you won't solve the problem.
        
        // WRONT ANSWER
        
        // Essentially, top down recursion is hard
    }

    public static func run() {

    }
}

// Write an algorithm to print all ways of arranging eight queens on a 8x8 chess board so that none of them share the same row, column, or diagonal.
// In this case, diagonal means all diagonals, not just the two that bisect the board
public struct Chapter9_Exercise9 : ExerciseRunnable {

    // TODO: Reimplement!
    func strikeOff(board:[[Int]], row: Int, col: Int) -> [[Int]] {
        
        var copy = board
        // Clear row
        for var c = 0; c < 8; c++ {
            copy[row][c] = -1
        }
        // Clear col
        for var r = 0; r < 8; r++ {
            copy[r][col] = -1
        }
        // Clear diagonals
        var r2 = row + 1
        var c2 = col + 1
        while r2 < 8 && c2 < 8 {
            copy[r2][c2] = -1
            r2++
            c2++
        }
        r2 = row - 1
        c2 = col - 1
        while r2 >= 0 && c2 >= 0 {
            copy[r2][c2] = -1
            r2--
            c2--
        }
        r2 = row + 1
        c2 = col - 1
        while r2 < 8 && c2 >= 0 {
            copy[r2][c2] = -1
            r2++
            c2--
        }
        r2 = row - 1
        c2 = col + 1
        while r2 >= 0 && c2 < 8 {
            copy[r2][c2] = -1
            r2--
            c2++
        }
        // TODO Diagonals
        
        copy[row][col] = 1
        return copy
    }
    func findNextFree(board : [[Int]], fromRow: Int, fromCol: Int) -> (Int, Int) {
        
        for var r = fromRow; r < 8; r++ {
            for var c = fromCol; c < 8; c++ {
                let value = board[r][c]
                if value == 0 {
                    return (r, c)
                }
            }
        }
        return (-1, -1)
    }
    
    func queensPlaced(board: [[Int]]) -> Int {
        
        var count = 0
        for var r = 0; r < 8; r++ {
            for var c = 0; c < 8; c++ {
                if board[r][c] == 1 {
                    count++
                }
            }
        }
        return count
    }
    func queens(board : [[Int]], remaining: Int) -> [[Int]] {
        // Each time I place a queen, I can cross off the corresponding, row, col and diagonals
        // Brute force approach:
        // Place first queen at position (i, j), then try all other combinations for other queens
        if remaining == 0 {
            return board
        }
        var bestBoard = board
        var bestPlacement = 0
        
        for var r = 0; r < 8; r++ {
            for var c = 0; c < 8; c++ {
                let (row, col) = findNextFree(board, fromRow: r, fromCol: c)
                if row != -1 && col != -1 {
                    let boardCopy = strikeOff(board, row: row, col: col)
                    let solution = queens(boardCopy, remaining: remaining - 1)
                    let placed = queensPlaced(boardCopy)
                    if placed > bestPlacement {
                        bestPlacement = placed
                        bestBoard = solution
                    }
                    if placed == 7 {
                        return bestBoard
                    }
                }
            }
        }
        return bestBoard
    }
    
    func testExercise9() {
        let board : [[Int]] = Array(count: 8, repeatedValue: Array(count: 8, repeatedValue: 0))
        let solution = queens(board, remaining: 8)
        print("board: \(solution), queens: \(queensPlaced(solution))")
        
        // Failed miserably. No idea how to solve these top down ones
    }

    
    public static func run() {
        
    }
}

// TODO: Implement 9.10 and 9.11!
