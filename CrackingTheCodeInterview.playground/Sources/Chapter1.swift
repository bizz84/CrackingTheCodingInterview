//
//  Chapter1.swift
//  CrackingCodeInterview
//
//  Created by Andrea Bizzotto on 19/07/2014.
//  Copyright (c) 2014 musevisions. All rights reserved.
//

import Foundation

extension Character {
    public var hashValue: Int {
        return String(self).hashValue
    }
    var hashValueModulo256 : Int {
        return (self.hashValue % 256)
    }
}

extension Character {
    func unicodeScalarCodePoint() -> UInt32 {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars
        
        return scalars[scalars.startIndex].value
    }
}

extension String {
    
    func charactersNeededCount() -> Int {
        var whitespaceCount = 0
        for character in self.characters {
            if character == " " {
                whitespaceCount++
            }
        }
        return self.characters.count + whitespaceCount * 2
    }
}


/*********************************************** EXERCISE 1 *****************************************************/
public struct Chapter1_Exercise1 : ExerciseRunnable {
    
    // Implement an algorithm to determine if a string has all unique characters. What if you cannot use additional data structures?
    static func exercise1(s : String) -> Bool {
        
        var buckets: [Character : Int] = [ : ]
        for character in s.characters {
            if let count = buckets[character] {
                buckets[character] = count + 1
                print("\(s): character \(character) found twice")
                return false
            }
            else {
                buckets[character] = 1
            }
        }
        return true
    }
    static func exercise1NoExtraDataStructures(s : String) -> Bool {
        
        var buckets = Array<Int>(count: 256, repeatedValue: 0)
        for character in s.characters {
            if buckets[character.hashValueModulo256] == 1 {
                return false
            }
            buckets[character.hashValueModulo256] = 1
        }
        
        return true
    }
    
    public static func testExercise1(input : String) {
        
        let result1 = exercise1(input)
        print("\(input) unique: \(result1)")
        let result2 = exercise1NoExtraDataStructures(input)
        print("\(input) unique: \(result2)")
        
        // Complete solution in 35 minutes
        // Missed: Ask interviewer if we can assume characters are ASCII
        // Optimisation: If > 256 characters in string, return false
        // Can make values bool rather than int
        // Space optimisation: Can use a bit vector rather than the full Boolean array -> Bit structure with 128 bits (or 32 if letters A -> Z)
        // Consider discussing alternative strategies (sort characters of string in NLog(N) and check for adjacent characters
    }

    public static func run() {
        testExercise1("Hello")
    }
}

public struct Chapter1 {
    
    
    /*********************************************** EXERCISE 3 *****************************************************/
    // Given 2 strings, write a method to decide if one is a permutation of the other
    
    static func hashTable(s : String) -> [Character : Int] {
        
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
    
    static func exercise3(a: String, b: String) -> Bool {
        
        if a.characters.count != b.characters.count {
            return false
        }
        let tableA = hashTable(a)
        let tableB = hashTable(b)
        
        return tableA == tableB
    }
    static func testExercise3() -> Void {
        var equal = false
        equal = exercise3("Hell", b: "Hlleo")
        print("Equal: \(equal)");
        equal = exercise3("Hello", b: "Hlleo")
        print("Equal: \(equal)");
        equal = exercise3("abcde", b: "edcba")
        print("Equal: \(equal)");
        equal = exercise3("", b: "")
        print("Equal: \(equal)");
        equal = exercise3("a", b: "a")
        print("Equal: \(equal)");
        
        // Solved in 11 minutes. Mentioned that can solve with hash table in O(n), or pre-sorting strings in O(N*logN)
        // Correctly analysed trivial cases, including strings of different lengths
        // Forgot to ask if comparison is case sensitive and how to deal with whitespace -> Always ask as much as possible about inputs
        // Important note: Ensure to use build in comparisons for collection types
    }
    
    
    /*********************************************** EXERCISE 4 *****************************************************/
    // Write a method to replace all spaces in a string with '%20'. You may assume that the string has sufficient space at the end
    // to hold the additional characters and that you are given the 'true' length of the string
    // EXAMPLE
    // Input:   "Mr John Smith    ", 13
    // Output:  "MR%20John%20Smith"
    
    static func exercise4(a: String) -> String {
        
        let characterCount = a.charactersNeededCount()
        
        var array: [Character] = Array<Character>(count:characterCount, repeatedValue: " ")
        var index = 0
        for character in a.characters {
            if character == " " {
                array[index++] = "%"
                array[index++] = "2"
                array[index++] = "0"
            }
            else {
                array[index++] = character;
            }
        }
        var result = ""
        for character in array {
            result.append(character)
        }
        return result
    }
    
    static func testExercise4() {
        
        var input = "Hello World";
        var encoded = exercise4(input)
        //        let range = Range<String.Index>(start: 0, end: countElements(input))
        //        let native = input.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        print("input: '\(input)', encoded: '\(encoded)'")
        
        input = "I like this interview";
        encoded = exercise4(input)
        print("input: '\(input)', encoded: '\(encoded)'")
        
        input = "";
        encoded = exercise4(input)
        print("input: '\(input)', encoded: '\(encoded)'")
        
        // Solved in 17 minutes with complexity 2*N
        // Observed that a more optimal solution would be to scan the string backwards to ensure no characters are overwritten. This can be done in N steps.
        // Solution went directly for proceeding backwards.
    }
    
    /*********************************************** EXERCISE 5 *****************************************************/
    // Implement a method to perform basic string compression using the counts of repeated characters. For example, the string aabcccccaaa would become a2b1c5a3. If the compressed string
    // would not become smaller than the original string, your method should return the original string. You can assume the string has only upper and lower case characters.
    static func exercise5(s: String) -> String {
        
        //println("\(s)")
        var compressed : String = ""
        var lastCharacter : Character = " "
        var repeated = 0
        for character in s.characters {
            //println("current: \(character), last: \(lastCharacter), repeated: \(repeated), compressed: \(compressed)")
            if lastCharacter != character {
                if lastCharacter != " " {
                    let codePoint = Character("0").unicodeScalarCodePoint() + UInt32(repeated)
                    compressed += String(lastCharacter)
                    compressed.append(Character(UnicodeScalar(codePoint)))
                }
                repeated = 1
            }
            else {
                repeated++
            }
            lastCharacter = character
        }
        let codePoint = Character("0").unicodeScalarCodePoint() + UInt32(repeated)
        compressed.append(lastCharacter)
        compressed.append(Character(UnicodeScalar(codePoint)))
        
        return compressed.characters.count >= s.characters.count ? s : compressed
    }
    static func testExercise5Wrapper(s: String) {
        
        let compressed = exercise5(s)
        print("input: \(s), compressed: \(compressed)")
    }
    static func testExercise5() {
        
        testExercise5Wrapper("Hello")
        testExercise5Wrapper("aabbccc")
        testExercise5Wrapper("aabbcc")
        testExercise5Wrapper("aaaaeeeeefdwwwwwww")
        // Solved in 30 min
        // Noted that we could do in 2 passes to first determine the length of the compressed string
        // Note O(p + k*k) due to string concatenation
        // Always tell the interviewer that when string concatenation happens repeatedly it's best to use a string buffer of initial known length
        
        // Note that often these types of problems can be resolved in two scans!
    }
    
    /*********************************************** EXERCISE 6 *****************************************************/
    // Given an image represented by an NxN matrix, where each pixel of the image is 4 bytes, write a method to rotate the image by 90 degrees.
    // Can you do this in place?
    static func exercise6(inout array: [[Int]]) {
        
        let N = array.count
        //let end = (N % 2 == 0) ? N/2-1 : N/2
        for row in 0..<N/2 {
            for col in 0...N/2 {
                
                let c1 = N - 1 - row
                let r1 = col
                
                let r2 = c1
                let c2 = N - 1 - r1
                
                let c3 = N - 1 - r2
                let r3 = c2
                
                //let c0 = N - 1 - r3
                //let r0 = c3
                
                //println("[\(row),\(col)], [\(r1),\(c1)], [\(r2),\(c2)], [\(r3),\(c3)]")
                
                let current = array[row][col]
                array[row][col] = array[r3][c3]
                array[r3][c3] = array[r2][c2]
                array[r2][c2] = array[r1][c1]
                array[r1][c1] = current
            }
        }
    }
    
    static func exercise6Wrapper(inout array: [[Int]]) {
        print("Start: \(array)")
        exercise6(&array)
        print("End: \(array)")
    }
    static func testExercise6() {
        var array0: [[Int]] = [[]]
        exercise6Wrapper(&array0)
        var array1: [[Int]] = [[1]]
        exercise6Wrapper(&array1)
        var array2: [[Int]] = [[1,2],[3,4]]
        exercise6Wrapper(&array2)
        var array3: [[Int]] = [[1,2,3],[4,5,6],[7,8,9]]
        exercise6Wrapper(&array3)
        var array4: [[Int]] = [[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]]
        exercise6Wrapper(&array4)
        var array5: [[Int]] = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15],[16,17,18,19,20],[21,22,23,24,25]]
        exercise6Wrapper(&array5)
        // Solved in 49 minutes
        // Found correct method for swapping in place on 4 pairs of given indices
        // Struggled a bit with indices correspondences
        // Did not observe that only necessary to iterate to half of length of square
        // By trial and error, determined loop indices for odd and even ranges, not even quite sure why it works
        
        // Could have solved quickly by paying more attention to all details of the problem
    }
    
    /*********************************************** EXERCISE 7 *****************************************************/
    // Write an algorithm such that if an element of an MxN matrix is 0, its entire row and column are set to 0
    static func exercise7(inout array : [[Int]]) {
        
        let M = array.count // number of rows
        if M == 0 {
            return;
        }
        let N = array[0].count // number of colums
        if N == 0 {
            return;
        }
        var rowFlags : [Bool] = Array(count: M, repeatedValue: false)
        var colFlags : [Bool] = Array(count: N, repeatedValue: false)
        
        for var r = 0; r < M; r++ {
            if rowFlags[r] == true {
                continue;
            }
            for var c = 0; c < N; c++ {
                if colFlags[c] == true {
                    continue;
                }
                if (array[r][c] == 0) {
                    rowFlags[r] = true;
                    colFlags[c] = true;
                }
            }
        }
        //println("row flags: \(rowFlags), colFlags: \(colFlags)")
        
        for var r = 0; r < M; r++ {
            if rowFlags[r] == true {
                nullifyRow(r, array: &array)
            }
        }
        for var c = 0; c < N; c++ {
            if colFlags[c] == true {
                nullifyCol(c, array: &array)
            }
        }
    }
    
    static func nullifyRow(r: Int, inout array : [[Int]]) {
        let N = array[0].count
        for var c = 0; c < N; c++ {
            array[r][c] = 0;
        }
    }
    static func nullifyCol(c: Int, inout array : [[Int]]) {
        let M = array.count
        for var r = 0; r < M; r++ {
            array[r][c] = 0;
        }
    }
    
    static func exercise7Wrapper(inout array: [[Int]]) {
        print("Before: \(array)")
        exercise7(&array)
        print("After: \(array)")
    }
    static func testExercise7() {
        var input : [[Int]] = [[1, 2, 0, 9], [4, 5, 6, 9], [7, 9, 9, 9]]
        exercise7Wrapper(&input)
        input = [[0],[1]]
        exercise7Wrapper(&input)
        // Solved in under 20 min
        // Complexity is O(n2)
        // Correct
        // Tries to optimise by flagging elements
        // Did not realise there was a way to solve this with O(1) space by using first row and column as flag. Clever.
    }
    
    // Assume you have a methods isSubstring which checks if one word is a substring of another. Given two strings s1 and s2,
    // write code to check if s2 is a rotation of s1 using only one call to isSubstring (e.g. "waterbottle" is a rotation of
    // "erbottlewat").
    
    // s1 : waterbottle
    // s2 : erbottlewat
    // cat : erbottle[waterbottle]wat
    static func exercise8(s1: String, s2: String) -> Bool {
        
        let s2Repeated = s2 + s2
        return (s2Repeated as NSString).containsString(s1);
    }
    
    static func testExercise8(s1 : String, s2: String) {
        let substring = exercise8(s1, s2: s2)
        print("s1: \(s1), s2: \(s2), substring: \(substring)")
        // Solved in 11 minutes
        // Identified solution with O(2n) space, O(n) time
        // Correct but forgot to put check in code for same length
    }
    
//    public static func runAll() {
//        testExercise1("Hello")
//        testExercise1("abcde")
//        testExercise3()
//        testExercise4()
//        testExercise5()
//        testExercise6()
//        testExercise7()
//        testExercise8("waterbottle", s2: "erbottlewat")
//    }
}