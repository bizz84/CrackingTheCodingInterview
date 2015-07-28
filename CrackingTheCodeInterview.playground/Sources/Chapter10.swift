//
//  Chapter10.swift
//  CrackingCodeInterview
//
//  Created by Andrea Bizzotto on 24/08/2014.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

// Find all documents that contain a list of words
public struct Chapter10_Words : ExerciseRunnable {
    
    static func intersection(set1 : [String], set2: [String]) -> [String] {
        
        // Idea: sort 2 sets, then scan and discard non uniques
        var sorted1 = set1.sort { $0 < $1 }
        var sorted2 = set2.sort { $0 < $1 }
        
        // Intersection similar to merge algorithm in merge sort
        var s1 = 0
        var s2 = 0
        var intersection : [String] = []
        while s1 < sorted1.count && s2 < sorted2.count {
            let v1 = sorted1[s1]
            let v2 = sorted2[s2]
            let swiftComparisonResult = v1.compare(v2)
            if swiftComparisonResult == NSComparisonResult.OrderedSame {
                intersection.append(v1)
                s1++
                s2++
            }
            else if swiftComparisonResult == NSComparisonResult.OrderedAscending {
                s1++
            }
            else {
                s2++
            }
        }
        return intersection
    }
    
    public static func run() {
        
        let intersect = intersection([ "doc2", "doc3", "doc6", "doc8"], set2: [ "doc1", "doc3", "doc7", "doc8", "doc9"])
        print("\(intersect)")
    }
}
