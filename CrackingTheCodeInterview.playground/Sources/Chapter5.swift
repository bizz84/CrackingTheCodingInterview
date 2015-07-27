//
//  Chapter5.swift
//  CrackingCodeInterview
//
//  Created by Andrea Bizzotto on 31/07/2014.
//  Copyright (c) 2014 musevisions. All rights reserved.
//

import Foundation

class NSStringBinary {
    
    class func binaryStringFromInt(intValue: Int32) -> NSString {
        let byteBlock = 8    // 8 bits per byte
        var totalBits = sizeof(Int32) * byteBlock // Total bits
        var binaryDigit : Int32 = 1  // Current masked bit
  
        // Binary string
        var binaryStr = ""
        repeat {
            // Check next bit, shift contents left, append 0 or 1
            binaryStr = (intValue & binaryDigit != 0 ? "1" : "0") + binaryStr
            if --totalBits != 0 && totalBits % byteBlock == 0 {
                binaryStr = "|" + binaryStr
            }
            binaryDigit <<= 1
            
        } while totalBits != 0
        
        // Return binary string
        return binaryStr
    }
}

public class Chapter5 {
    
    // You are given two 32-bit numbers, N and M, and two positions, i and j. Write a method to insert M into N such that M starts at bit j and ends at bit i.
    // You can assume that the bits j through i have enough space to fit all of M. That is, if M = 10011, you can assume that there are at least 5 bits between
    // j and i. You would not, for example, have j = 3 and i = 2 because M could not fully fit between bit 3 and bit 2
    func exercise1(N : Int32, M: Int32, i: Int32, j: Int32) -> Int32 {
        // example
        print("i: \(i), j: \(j)")
        print("N: \(NSStringBinary.binaryStringFromInt(N))")
        print("M: \(NSStringBinary.binaryStringFromInt(M))")
        
        let bitsToKeep = j - i + 1 // 4
        let maskBase : Int32 = (1 << bitsToKeep) - 1 // 0b1111
        let maskShiftedNegated : Int32 = ~(maskBase << i) // 0b11..1000011
        let clearN = N & maskShiftedNegated // 0b11100001
        let maskedMatI = (M & maskBase) << i // 0b011000
        let MinN = clearN | maskedMatI
        print("R: \(NSStringBinary.binaryStringFromInt(MinN))")
        return MinN
    }
    
    func testExercise1() {
        
        exercise1(0b11100001, M: 0b00000110, i: 1, j: 4)
        exercise1(0b11100001, M: 0b00000110, i: 0, j: 6)
        
        // Solved in 17 Min.
        // Spent some time preparing a formatting method for Int to binary string
        // Steps:
        // Create a mask
        // Shift by i, negate and apply as mask to N
        // Shift masked M, OR with result
    }
    
    // Given a real number between 0 and 1 (e.g. 0.72) that is passed in as a double,
    // print the binary representation. If the number cannot be represented accurately in binary with at most 32 characters, print "ERROR".
    func exercise2(var n : Double) -> String {
        
        if n < 0 || n > 1 {
            return "ERROR"
        }
        if n == 0 {
            return "0"
        }
        if n == 1 {
            return "1"
        }
        var s = "0."
        var count = 0
        repeat {
            n = n * 2
            s += n >= 1 ? "1" : "0"
            count++
            if n >= 1 {
                n = n - 1
            }
        } while count < 32 && n != 0
        
        if n != 0 {
            return "ERROR"
        }
        return s
    }
    
    func testExercise2() {
        var n = 0.875
        var s = exercise2(n)
        print("\(n) -> \(s)")
        n = 0.75
        s = exercise2(n)
        print("\(n) -> \(s)")
        n = 0.875
        s = exercise2(n)
        print("\(n) -> \(s)")
        n = 0.125
        s = exercise2(n)
        print("\(n) -> \(s)")
        n = 0.1259
        s = exercise2(n)
        print("\(n) -> \(s)")
        n = pow(2, -32)
        s = exercise2(n)
        print("\(n) -> \(s)")
        // Solved in 16 minutes
        // Key observation is that we can iterate and multiply the input number by 2 for 32s times and add
        // the topmost bit to the string.
        // Was working but could have made more efficient (no need to compare double with int)
    }
    
    // Given a positive integer, print the next smallest and next largest number that have the same number of 1 bits in their binary representation
    func printNextSmallest(n : Int) -> Int {
        if n == 0 {
            return -1
        }
        var nextPowerOfTwo = 1
        while n >= nextPowerOfTwo {
            nextPowerOfTwo = nextPowerOfTwo << 1
            if n == nextPowerOfTwo - 1 {
                return -1
            }
        }
        nextPowerOfTwo = nextPowerOfTwo >> 1
        while n & nextPowerOfTwo != 0 {
            nextPowerOfTwo = nextPowerOfTwo >> 1
        }
        let mask1 = ~(nextPowerOfTwo << 1)
        let reset1 = n & mask1
        let updated = reset1 | nextPowerOfTwo
        return updated
    }
    func printNextLargerst(n : Int32) -> Int32 {
        if n == 0 {
            return -1
        }
        var nextPowerOfTwo : Int32 = 1
        while n & nextPowerOfTwo == 0 {
            nextPowerOfTwo = nextPowerOfTwo << 1
        }
        while n & nextPowerOfTwo != 0 {
            nextPowerOfTwo = nextPowerOfTwo << 1
        }
        // on a 0
        
        let mask1 = ~(nextPowerOfTwo >> 1)
        let reset1 = n & mask1
        let updated = reset1 | nextPowerOfTwo
        return updated
    }
    func exercise3() {
        //        print("n: \(NSStringBinary.binaryStringFromInt(0)), nextSmallest: \(NSStringBinary.binaryStringFromInt(printNextLargerst(0)))")
        //        print("n: \(NSStringBinary.binaryStringFromInt(1)), nextSmallest: \(NSStringBinary.binaryStringFromInt(printNextLargerst(1)))")
        print("n: \(NSStringBinary.binaryStringFromInt(2)), nextSmallest: \(NSStringBinary.binaryStringFromInt(printNextLargerst(2)))")
        print("n: \(NSStringBinary.binaryStringFromInt(3)), nextSmallest: \(NSStringBinary.binaryStringFromInt(printNextLargerst(3)))")
        print("n: \(NSStringBinary.binaryStringFromInt(4)), nextSmallest: \(NSStringBinary.binaryStringFromInt(printNextLargerst(4)))")
        print("n: \(NSStringBinary.binaryStringFromInt(6)), nextSmallest: \(NSStringBinary.binaryStringFromInt(printNextLargerst(6)))")
        print("n: \(NSStringBinary.binaryStringFromInt(7)), nextSmallest: \(NSStringBinary.binaryStringFromInt(printNextLargerst(7)))")
        print("n: \(NSStringBinary.binaryStringFromInt(8)), nextSmallest: \(NSStringBinary.binaryStringFromInt(printNextLargerst(8)))")
        print("n: \(NSStringBinary.binaryStringFromInt(14)), nextSmallest: \(NSStringBinary.binaryStringFromInt(printNextLargerst(14)))")
        print("n: \(NSStringBinary.binaryStringFromInt(15)), nextSmallest: \(NSStringBinary.binaryStringFromInt(printNextLargerst(15)))")
        // Solved in 21 minutes
        // Next largest: iterate while on zeros to find first 1
        // Iterate until find next 0
        // set previous to 0, current to 1, return
        // Next smallest: if we encounter n = 2^x - 1, return error
        // Find greatest bit set to 1
        // Move to the right until we find a 0
        // Swap the two bits
        
        // WRONG, approach needed more consideration: Find first non-trailing 0, put a 1, move all the other ones
    }
    
    // Explain what the following code does: ((n & (n - 1) == 0)
    func exercise4() {
        // Checks if N is a power of 2
    }
    
    // Write a function to determine the number of bits you would need to flip to convert integer A to integer B
    func exercise5(a: Int32, b: Int32) -> Int32 {
        
        if a == b {
            return 0
        }
        var flip : Int32 = 0
        var next : Int32 = 1
        while a >= next || b >= next {
            if a & next != b & next {
                flip++
            }
            next = next << 1
        }
        print("a: \(NSStringBinary.binaryStringFromInt(a)), b: \(NSStringBinary.binaryStringFromInt(b)), flip: \(flip)")
        return flip
    }
    
    func testExercise5() {
        
        exercise5(1, b: 2)
        exercise5(1, b: 3)
        exercise5(3, b: 5)
        exercise5(3, b: 7)
        exercise5(0b11101, b: 0b01111)
        // Completed and tested in 7 minutes
        // Simple while loop that stops on the next smallest common power of two for the inputs
        // Implemented with XOR and optimal approach for converging
        // for (c = a ^ b; c != 0; c = c & (c-1)) {
        //  count++
        // }
    }
    
    // Write a program to swap odd and even bits in an integer with as fwe instructions as possible (e.g. bit 0 and bit 1 are swapped, bit 2 and bit 3 are swapped, and so on)
    func exercise6(a: Int32) -> Int32 {
        // Mask can be precomputed : 0b0101010101010101010101010101
        var oddMask : Int32 = 1; //
        for var i = 0; i < 32; i += 2 {
            oddMask |= Int32(1 << i)
        }
        let evenMask = oddMask << 1
        let result = (a >> 1 & oddMask) | (a << 1 & evenMask)
        print("a: \(NSStringBinary.binaryStringFromInt(a))\nb: \(NSStringBinary.binaryStringFromInt(result))")
        return result
    }
    func testExercise6() {
        exercise6(0b010101101111000010000111)
        // Solved in 23 minutes
        // Odd/even + shifting masking approach works, however need quick way of calculating odd, even
    }
    
    // An array A contains all the integers from 0 to n, except for one number which is missing. In this problem, we cannot access an entire integer in A with a single operation.
    // The elements of A are represented in binary, and the only operation we can use to access them is "fetch the jth bit of A[i]", which takes constant time.
    // Write code to find the missing integer. Can you do it in O(n) time?
    func exercise7() {
        
        // Could not find solution in 20 minutes.
        // Idea: Count number of 0s on each bit, subtract expected number of 0s, and negate
        
        // Approach: Count imbalances between 0s and 1s and discard half the array by bit 0, repeat for following bits
        // Complexity = sum(0, n, logn, n / 2^i) = 2n-1
    }
    
    func stringForByte(byte : UInt8) -> String {
        
        var s = ""
        for i in 0...7 {
            s += byte & UInt8(1 << i) != 0 ? "1" : "0"
        }
        return s
    }
    
    // A monochrome screen is stored as a single array of bytes, allowing eight consecutive pixels to be stored in one byte.
    // The screen has width w, where w is divisible by 8 (that is, no byte will be split across rows). The height of the screen, of course,
    // can be derived from the length of the array and the width. Implement a function
    // drawHorizontalLine(byte[] screen, int width, int x1, int x2, int y) which draws a horizontal line from (x1, y) to (x2, y).
    func exercise8(inout A : [UInt8], w: Int, x1: Int, x2: Int, y: Int) {
        
        if x2 >= x1 {
            let bytesInRow = w / 8;
            let firstByteIndexForRow = y * bytesInRow;
            let firstPixelInLeftByte = x1 % 8
            let lastPixelInRightByte = x2 % 8
            let leftLineByteIndex = firstByteIndexForRow + x1 / 8
            let rightLineByteIndex = firstByteIndexForRow + x2 / 8
            
            let leftMask = ~UInt8((1 << firstPixelInLeftByte) - 1)
            let rightMask = UInt8((1 << (lastPixelInRightByte + 1)) - 1)
            
            if leftLineByteIndex < rightLineByteIndex {
                for i in (leftLineByteIndex+1)..<rightLineByteIndex {
                    A[i] = 0xFF
                }
                
                A[leftLineByteIndex] = leftMask
                A[rightLineByteIndex] = rightMask
            }
            else {
                A[leftLineByteIndex] = leftMask & rightMask
            }
        }
        
        for byte in A {
            print("a: \(stringForByte(byte))")
        }
        
    }
    func testExercise8() {
        var A : [UInt8] = Array(count: 16, repeatedValue: 0)
        exercise8(&A, w: 64, x1: 9, x2: 64, y: 0)
        
        // Solved in 21 minutes 38 sec.
        // Just a matter of calculating offsets and appropriate masks for boundaries
        // Correct and efficient solution, forgot to check case where x1, x2 on same byte!
        // 5 more minutes for corner cases
    }
    public init() {
        testExercise1()
        //testExercise2()
        //        exercise3()
        //        testExercise5()
        //        testExercise6()
        //testExercise8()
    }
}
