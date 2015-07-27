//
//  Chapter11.swift
//  CrackingCodeInterview
//
//  Created by Andrea Bizzotto on 07/08/2014.
//  Copyright (c) 2014 musevisions. All rights reserved.
//

import Foundation

//extension Array {
//    func toString() -> String{
//        var str : String = ""
//        for (idx, item) in enumerate(self) {
//            str += "\(item)"
//        }
//        return str
//    }
//}

public class Chapter11 {
    
    
    func bubbleSort(inout array: [Int]) {
        
        for var i = 0; i < array.count - 1; i++ {
            for var j = i + 1; j < array.count; j++ {
                if array[i] > array[j] {
                    swap(&array[i], &array[j])
                }
            }
        }
    }
    
    func selectionSort(inout array : [Int]) {
        
        for var i = 0; i < array.count; i++ {
            //let first = array[i]
            var argMin = i
            for var j = i + 1; j < array.count; j++ {
                if array[j] < array[argMin] {
                    argMin = j
                }
            }
            if argMin != i {
                swap(&array[i], &array[argMin])
            }
        }
    }
    
    func mergeSort(inout array : [Int], inout helper : [Int], from: Int, to: Int) {
        
        if from < to {
            let middle = (from + to) / 2
            mergeSort(&array, helper: &helper, from: from, to: middle)
            mergeSort(&array, helper: &helper, from: middle + 1, to: to)
            merge(&array, helper: &helper, low: from, middle: middle, high: to)
        }
        
        // TODO: Merge from, to
    }
    
    func merge(inout array: [Int], inout helper: [Int], low: Int, middle: Int, high: Int) {
        for var i = low; i <= high; i++ {
            helper[i] = array[i]
        }
        
        var helperLeft = low
        var helperRight = middle + 1
        var current = low
        
        while helperLeft <= middle && helperRight <= high {
            if helper[helperLeft] <= helper[helperRight] {
                array[current] = helper[helperLeft]
                helperLeft++
            }
            else {
                array[current] = helper[helperRight]
                helperRight++
            }
            current++
        }
        
        let remaining = middle - helperLeft
        for var i = 0; i <= remaining; i++ {
            array[current + i] = helper[helperLeft + i]
        }
    }
    
    // You are given two sorted arrays, A and B, where A has a large enough buffer at the end to hold B. Write a method to merge B into A in sorted order.
    func exercise1(inout a: [Int], b: [Int]) {
        
        var rightA = a.count - b.count - 1
        var rightB = b.count - 1
        
        var current = a.count - 1
        while rightB >= 0 {
            if a[rightA] > b[rightB] {
                a[current] = a[rightA]
                rightA--
            }
            else {
                a[current] = b[rightB]
                rightB--
            }
            current--
        }
    }
    
    
    func testExercise1() {
        var a = [1, 2, 6, 9, 12, 0, 0, 0]
        let b = [3, 7, 15]
        
        exercise1(&a, b: b)
        
        print("\(a)")
        // Solved in 4.30 min
    }
    
    func hashTable(s : String) -> [Character : Int] {
        
        var table: [Character : Int] = [ : ]
        for character in s.characters {
            if let count = table[character] {
                table[character] = count + 1
            }
            else {
                table[character] = 1
            }
        }
        return table
    }
    
    // Write a method to sort an array of strings so that all the anagrams are next to each other
    // Group
    //
    
    func sortedCharacters(s: String) -> String {
        
        var a = Array(s.characters)
        a.sortInPlace { $1.unicodeScalarCodePoint() > $0.unicodeScalarCodePoint() }
        return String(a)
//        return a.toString()
    }
    func exercise2(strings : [String]) -> [String] {
        
        var hash : [String : [String]] = [ : ]
        
        for string in strings {
            let key = sortedCharacters(string)
            if let _ = hash[key] {
                hash[key]!.append(string)
            }
            else {
                hash[key] = [string]
            }
            print("\(key), anagrams: \(hash[key]!)")
        }
        
        var result: [String] = []
        for (_, anagrams) in hash {
            result += anagrams
        }
        return result
    }
    
    func testExercise2() {
        let strings = ["abba", "baba", "acca", "abab", "caca"]
        let sorted = exercise2(strings)
        print("\(sorted)")
        // Failed. Best solution:
        // Put sorted representation of strings in hashTable where each key is the sorted string, then unload hasttable into array.
    }
    
    // Given a sorted array of n integers that has been rotated an unknown number of times, write code to find an element in the array. You may assume that the array was
    // originally sorted in increasing order.
    // EXAMPLE
    // Input: find 5 in {15, 16, 19, 20, 25, 1, 3, 4, 5, 7, 10, 14 }
    // Output: 8 (the index of 5 in the array)
    func exercise3(a : [Int], findMe: Int) -> Int {
        
        var left = 0
        var right = a.count - 1
        
        while left <= right {
            let middle = (left + right) / 2
            if a[middle] == findMe {
                return middle
            }
            if a[middle] < findMe && middle < a.count - 1 && a[a.count - 1] >= findMe {
                left = middle + 1
            }
            else {
                right = middle - 1
            }
        }
        return -1
    }
    
    func testExercise3() {
        let a = [15, 16, 19, 20, 25, 1, 3, 4, 5, 7, 10, 14]
        let index = exercise3(a, findMe: 15)
        print("\(a), index: \(index)")
        // Solved in 14 minutes as variation of binary search
        // Not considering duplicates. May be wrong
    }
    
    // Imagine you have a 20GB file with one string per line. Explain how you would sort the file
    
    // External sort, completed in 6 min
    
    // Given a sorted array of strings which is interspersed with empty strings, write a method to find the locations of a given string
    // EXAMPLE
    // Input: Find "Ball" in { "at", "", "", "", "ball", "", "", "car", "", "", "dad", "", ""}
    // Output: 4
    func exercise5(a : [String], findMe: String) -> Int {
        
        var left = 0
        var right = a.count - 1
        
        while left <= right {
            let middle = (left + right) / 2
            if a[middle] == "" {
                // Move middle left or right
                var middleLeft = middle - 1
                while a[middleLeft] == "" {
                    middleLeft--
                }
                if a[middleLeft] == findMe {
                    return middleLeft
                }
                if a[middleLeft] < findMe {
                    // Look for middle right
                    var middleRight = middle + 1
                    while a[middleRight] == "" {
                        middleRight++
                    }
                    if a[middleRight] == findMe {
                        return middleRight
                    }
                    else {
                        left = middleRight + 1
                        continue
                    }
                }
                else {
                    right = middleLeft - 1
                    continue
                }
            }
            if a[middle] == findMe {
                return middle
            }
            if a[middle] < findMe {
                left = middle + 1
            }
            else {
                right = middle - 1
            }
        }
        return -1
    }
    
    func testExercise5() {
        
        let strings = [ "at", "", "", "", "ball", "", "", "car", "", "", "dad", "", ""]
        let index = exercise5(strings, findMe: "dad")
        print("index: \(index)")
        
        // Solved in 9 min
        // Should strings compare be case insensitive?
        // repeated values?
        // Analysed cases
        // Forgot to mention what we should do if string to be found is empty
    }
    
    // Given an N x N matrix in which each row and each column is sorted in ascending order, write a method to find an element.
    func lineBinarySearch(M : [[Int]], findMe: Int, dimension: Int, var first: Int, var last: Int, picker: (M: [[Int]], middle: Int, dimension: Int) -> Int) -> Int {
        
        while first <= last {
            let middle = (first + last) / 2
            let value = picker(M: M, middle: middle, dimension: dimension)
            if value == findMe {
                return middle
            }
            if value < findMe {
                first = middle + 1
            }
            else {
                last = middle - 1
            }
        }
        return -1
    }
    
    func rowBinarySearch(M : [[Int]], findMe: Int, col: Int, firstRow: Int, lastRow: Int) -> Int {
        
        return lineBinarySearch(M, findMe: findMe, dimension: col, first: firstRow, last: lastRow, picker: { (M : [[Int]], middle: Int, dimension: Int) in
            return M[middle][dimension]
        })
    }
    
    func colBinarySearch(M : [[Int]], findMe: Int, row: Int, firstCol: Int, lastCol: Int) -> Int {
        
        return lineBinarySearch(M, findMe: findMe, dimension: row, first: firstCol, last: lastCol, picker: { (M : [[Int]], middle: Int, dimension: Int) in
            return M[dimension][middle]
        })
    }
    
    
    func exercise6(M : [[Int]], findMe: Int) -> (Int, Int) {
        
        /*
        5  10 15 25 30
        7  12 18 32 36
        20 25 28 40 50
        
        Find 32
        */
        
        // 2 Dimensional binary search
        
        var firstRow = 0
        var lastRow = M.count - 1
        var firstCol = 0
        var lastCol = M[0].count - 1
        
        while firstRow <= lastRow && firstCol <= lastCol {
            
            let middleRow = (firstRow + lastRow) / 2
            let middleCol = (firstCol + lastCol) / 2
            
            let value = M[middleRow][middleCol]
            if value == findMe {
                return (middleRow, middleCol)
            }
            
            if value < findMe {
                
                let rowIndex = rowBinarySearch(M, findMe: findMe, col: middleCol, firstRow: middleRow + 1, lastRow: lastRow)
                if rowIndex != -1 {
                    return (rowIndex, middleCol)
                }
                let colIndex = colBinarySearch(M, findMe: findMe, row: middleRow, firstCol: middleCol + 1, lastCol: lastCol)
                if colIndex != -1 {
                    return (middleRow, colIndex)
                }
                
                
                firstRow = middleRow + 1
                firstCol = middleCol + 1
            }
            else {
                let rowIndex = rowBinarySearch(M, findMe: findMe, col: middleCol, firstRow: firstRow, lastRow: middleRow - 1)
                if rowIndex != -1 {
                    return (rowIndex, middleCol)
                }
                let colIndex = colBinarySearch(M, findMe: findMe, row: middleRow, firstCol: firstCol, lastCol: middleCol - 1)
                if colIndex != -1 {
                    return (middleRow, colIndex)
                }
                
                lastRow = middleRow - 1
                lastCol = middleCol - 1
            }
        }
        return (-1, -1)
    }
    
    func testExercise6() {
        
        let m : [[Int]] = [
            [5, 10, 15, 25, 30],
            [7, 12, 18, 32, 36],
            [20, 25, 28, 40, 50],
        ]
        //        var m : [[Int]] = [
        //            [15, 20, 70, 85],
        //            [25, 35, 80, 95],
        //            [30, 55, 95, 105],
        //            [40, 80, 100, 120],
        //        ]
        let (row, col) = exercise6(m, findMe: 30)
        print("\(row), \(col)")
        
        // Works for two dimensional thingy (19 minutes)
        // Some optimisation to work on closures
        // Find distinct elements?
        
        // Since it took time to develop this approach, should mention that we can do M binary searches on rows with complexity O(M log N)
        
        // Wrong solution
    }
    
    // A circus is designing a tower routine consisting of people standing atop one another's shoulders. For practical and aesthetic reasons,
    // each person must be both shorter and lighter than the person below him or her. Given the heights and weights of each person in the circus,
    // write a method to compute the largest possible number of people in such a tower.
    // EXAMPLE
    // Input (ht, wt): (65, 100), (70, 150), (56, 90), (75, 190), (60, 95), (68, 110)
    // Output: The longest tower is length 6 and includes from top to bottom:
    // (56, 90), (60, 95), (65, 100), (68, 110), (70, 150), (75, 190)
    
    struct Person : CustomStringConvertible {
        let height : Int
        let weight : Int
        init(height: Int, weight: Int) {
            self.height = height
            self.weight = weight
        }
        var description : String {
            return "(\(height),\(weight))"
        }
    }
    func longestIncreasingSequence(people: [Person], picker: (Person) -> Int) -> Int {
        var max = 1
        var currentMax = 1
        for var i = 1; i < people.count; i++ {
            
            let value = picker(people[i])
            let valuePrev = picker(people[i-1])
            if value > valuePrev {
                currentMax++
                if currentMax > max {
                    max = currentMax
                }
            }
            else {
                currentMax = 1
            }
        }
        return max
    }
    
    func exercise7(people: [Person]) -> Int {
        // Sort by height -> find longest ordered sequence of weights
        // Sort by weight -> find longest ordered sequence of heights
        // Return the greater of the two
        
        let heightSorted = people.sort { (p1, p2) -> Bool in return p1.height < p2.height }
        let longestWeightSequence = longestIncreasingSequence(heightSorted, picker: { (person: Person) -> Int in return person.weight })
        
        let weightSorted = people.sort { (p1, p2) -> Bool in return p1.weight < p2.weight }
        let longestHeightSequence = longestIncreasingSequence(weightSorted, picker: { (person: Person) -> Int in return person.height })
        
        if (longestWeightSequence > longestHeightSequence) {
            print("longest weight sequence: \(longestWeightSequence), people: \(heightSorted)")
            return longestWeightSequence
        }
        else {
            print("longest height sequence: \(longestHeightSequence), people: \(weightSorted)")
            return longestHeightSequence
        }
    }
    
    func testExercise7() {
        
        let people = [
            Person(height: 65, weight: 100),
            Person(height: 70, weight: 150),
            Person(height: 56, weight: 90),
            Person(height: 75, weight: 190),
            Person(height: 60, weight: 95),
            Person(height: 68, weight: 110)
        ]
        exercise7(people)
        // Solved in 21 minutes
        // Got stuck on sorting, closures etc
        // Got property right away
        
        // Book uses Longest increasing subsequence to compute solution
    }
    
    // Imagine you are reading a stream of integers. Periodically, you wish to be able to look up the rank of a number x (the number of values less than or equal to x).
    // Implement the data structures and algorithms to support these operations. That is, implement the method track(int x) which is called when each number is generated,
    // and the method getRankOfNumber(int x), which returns the number of values less than or equal to x (not including x itsefl).
    // EXAMPLE
    // Stream (in order of appearance): 5, 1, 4, 4, 5, 9, 7, 13, 3
    // getRankOfNumber(1) = 0
    // getRankOfNumber(3) = 1
    // getRankOfNumber(4) = 2
    
    class Stream {
        
        var values: [Int] = []
        // O(n)
        func track(x: Int) {
            
            for var i = 0; i < values.count; i++ {
                if x < values[i] {
                    // Insert at this position and shift
                    values.insert(x, atIndex: i)
                    return
                }
            }
            values.append(x)
        }
        
        // O(log N)
        func getRankOfNumber(x: Int) -> Int {
            
            var left = 0
            var right = values.count - 1
            
            while left <= right {
                let middle = (left + right) / 2
                if values[middle] == x {
                    return middle
                }
                if values[middle] < x {
                    left = middle + 1
                }
                else {
                    right = middle - 1
                }
            }
            return -1
        }
        func printRankOf(x: Int) {
            let rank = getRankOfNumber(x)
            print("rank of \(x) is \(rank)")
        }
    }
    
    
    func testExercise8() {
        
        let stream = Stream()
        stream.track(5)
        stream.printRankOf(5)
        stream.track(1)
        stream.printRankOf(1)
        stream.printRankOf(5)
        stream.track(4)
        stream.track(4)
        stream.track(5)
        stream.track(9)
        stream.track(7)
        stream.track(13)
        stream.track(3)
        stream.printRankOf(7)
        stream.track(5)
        stream.printRankOf(7)
        // O(n) solution in 11 minutes
        // Proposed solution was to use a binary search tree which can solve the problem in O(log N)
        // Clever counting of rank for each node so that full trasversal is not needed
    }
    
    
    public init() {
        
        //        testExercise1()
        //        testExercise2()
        //        testExercise3()
        //        testExercise4()
        //        testExercise6()
        //        testExercise6()
        //        testExercise7()
        testExercise8()
    }
}