//
//  Chapter10.swift
//  CrackingCodeInterview
//
//  Created by Andrea Bizzotto on 24/08/2014.
//  Copyright (c) 2014 musevisions. All rights reserved.
//

import Foundation

public class Chapter10 {
    
    // Find all documents that contain a list of words
    func words() {
        
        // 1: Create hash table of all words:
        // "books" : doc2, doc3, doc6, doc8
        // "many"  : doc1, doc3, doc7, doc8, doc9
    }
    
    func intersection(set1 : [String], set2: [String]) -> [String] {
        
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
    
    public init() {
        
        let intersect = intersection([ "doc2", "doc3", "doc6", "doc8"], set2: [ "doc1", "doc3", "doc7", "doc8", "doc9"])
        print("\(intersect)")
    }
}
