//
//  Chapter2.swift
//  CrackingCodeInterview
//
//  Created by Andrea Bizzotto on 20/07/2014.
//  Copyright (c) 2014 musevisions. All rights reserved.
//

import Foundation

class Node : Hashable, Equatable {
    
    var data : Int
    var next : Node?
    
    init(data: Int) {
        self.data = data
        self.next = nil
    }
    init(data: Int, next: Node?) {
        self.data = data
        self.next = next
    }
    
    func append(data : Int) {
        let end = Node(data: data)
        var n = self
        while n.next != nil {
            n = n.next!
        }
        n.next = end
    }
    
    func asString() -> String {
        var s = ""
        s += "\(self.data), "
        var n = self
        while n.next != nil {
            n = n.next!
            s += "\(n.data), "
        }
        return s
    }
    
    var hashValue: Int { return data }
    
}
func ==(lhs: Node, rhs: Node) -> Bool {
    return lhs === rhs
}

public struct Chapter2_Exercise1 : ExerciseRunnable {

    // Write code to remove duplicates from an unsorted linked list
    // FOLLOW UP
    // How would you solve this problem if a temporary buffer is not allowed?
    static func exercise1(list : Node) {
        
        // Data, Original Index, Flagged
        var array : [(Int, Int, Bool)] = []
        var iter = list
        var index = 0
        array += [(iter.data, index, false)]
        while let value = iter.next {
            array += [(value.data, index, false)]
            index++
            iter = iter.next!
        }
        
        array.sortInPlace { $0.0 < $1.0 }
        
        // Flag duplicates
        for var i = 1; i < array.count; i++ {
            let pData = array[i - 1].0
            let data = array[i].0
            if data == pData {
                array[i].2 = true
            }
        }
        
        // TODO: Back to original ordering?
        array.sortInPlace { $0.1 < $1.1 }
        
        print("\(array)")
        
        var i = 1
        iter = list
        while let next = iter.next {
            let flag = array[i].2
            if flag == true {
                // Remove element from list!
                iter.next = next.next
            }
            else {
                iter = next
            }
            i++
        }
        
        iter = list
        print("\(iter.data)")
        while let value = iter.next {
            print("\(value.data)")
            iter = iter.next!
        }
    }
    
    static func exercise1Hash(List : Node) {
        var hash : [ Int : Bool ] = [:]
        var iter = List
        hash[iter.data] = true
        while let value = iter.next {
            if hash[value.data] != nil {
                // Element already exists: Delete
                iter.next = value.next
            }
            else {
                hash[value.data] = true
            }
            iter = value
        }
        iter = List
        print("\(iter.data)")
        while let value = iter.next {
            print("\(value.data)")
            iter = iter.next!
        }
    }
    
    static func testExercise1() {
        
        // 2, 4, 2, 1, 1, 3, 5 -> 2, 4, 1, 3, 5
        //        var list = Node(data: 2, next: Node(data: 4, next: Node(data: 2, next: Node(data: 1, next: Node(data: 1, next: Node(data: 3, next: Node(data: 5)))))))
        let list = Node(data: 2, next: Node(data: 2, next: Node(data: 4, next: Node(data: 1, next: Node(data: 1, next: Node(data: 3, next: Node(data: 5, next: Node(data: 5))))))))
        exercise1Hash(list)
        // Solved in 22 minutes.
        // Approach sorts an array twice, first time to find duplicates, then to restore original ordering. Finally scans the list and removes duplicates based on the array flag
        // ERROR
        // Could be sorted in O(N) time : Linked List + Hash table
        // Hash table is always good to count duplicates
        // Advantage of linked list is that this can be done in one pass.
        // Much simpler.
        // If no extra buffer?
        // Alternative implementation in O(n*n) time and extra O(1) space is to use a runner to check each element against all following ones.
        // LEARNED: If a solution seems complex, always check if there is a simpler one! You can save 20 min of exercise with 2 min of analysis!
    }
    
    public static func run() {
        testExercise1()
    }
}

public struct Chapter2_Exercise2 : ExerciseRunnable {

    
    // Implement an algorithm to find the k-th to last element on a singly linked list
    static func exercise2(list : Node, k: Int) -> Int {
        
        // N + (N - k) steps = 2N - k
        var count = 1
        var iter = list
        while let value = iter.next {
            count++
            //print("val: \(value.data), count: \(count)")
            iter = value
        }
        
        if k >= count {
            return 0
        }
        if k == count - 1 {
            return list.data
        }
        
        let target = count - k - 1
        count = 1
        iter = list
        while let value = iter.next {
            
            if count == target {
                return value.data
            }
            count++
            iter = iter.next!
        }
        return 0
    }
    
    static func testExercise2() {
        // 2241135 -> 3
        let list = Node(data: 2, next: Node(data: 2, next: Node(data: 4, next: Node(data: 1, next: Node(data: 1, next: Node(data: 3, next: Node(data: 5)))))))
        let k = 7
        let data = exercise2(list, k: k)
        print("k: \(k), data: \(data)")
        // Solution in 15 min
        // Implemented by first determining the number of elements in the list, then counting again from the beginning.
        // Alternatively could have created a new list as the reverse of the original one with a recursive approach and then iterated linearly on that one
        
        // The best solution was iterative but without iterating on the list twice. In fact, all is needed is 2 pointers. The first one advances by k positions
        // initially, then they both advance together. When the first pointer hits the end, the second one is in the right place.
        
        // Remember Runner, Recursion, using properties, combine List / Array / Hash tables etc.
        
    }
    
    public static func run() {
        testExercise2()
    }
}

public struct Chapter2_Exercise3 : ExerciseRunnable {

    // Implement an algorithm to delete a node in the middle of a singly linked list, given only access to that node
    // Example:
    // Input: The node c from the linked list a -> b -> c -> d -> e
    // Result: Nothing is returned, but the new linked list looks like a -> b -> d -> e
    
    static func exercise3(middle: Node) {
        let iter = middle
        if iter.next !== nil {
            iter.data = iter.next!.data
            iter.next = iter.next!.next
        }
        //        while let next = iter.next {
        //            iter.data = next.data
        //            if next.next? {
        //                iter = iter.next!
        //            }
        //            else {
        //                iter.next = nil
        //                break
        //            }
        //        }
    }
    
    static func testExercise3() {
        
        let middle = Node(data: 3, next: Node(data: 4, next: Node(data: 5)))
        let list = Node(data: 1, next: Node(data: 2, next: middle))
        exercise3(middle)
        
        var iter = list
        print("\(iter.data)")
        while let next = iter.next {
            print("\(next.data)")
            iter = iter.next!
        }
        // Solved in 11 minutes
        // Trick is to move the shift back the contents of the nodes in the list and deleting the last one rather than the first one
        // Suboptimal. Efficient solution works in O(1) by copying the data of the next node and just discarding the next node
        // Learned. Remember that linked list DO NOT REQUIRE shifting of all elements like arrays do.
    }

    public static func run() {
        testExercise3()
    }
}

public struct Chapter2_Exercise4 : ExerciseRunnable {

    // Write code to partition a linked list around a value x, such that all nodes less than x come before all nodes greater than or equal to x
    static func exercise4(list : Node, x: Int) {
        
        // 1 2 5 6 2 3, x : 4
        // 1 2 2 6 5 3, x : 4
        // 1 2| 2| 3| 5 6
        var firstGreater = list
        var iter = list
        while let next = iter.next {
            if iter.data >= x {
                firstGreater = iter
                break
            }
            iter = next
        }
        
        while let next = iter.next {
            if next.data < x {
                // then swap next and firstGreater
                swap(&firstGreater.data, &next.data)
                firstGreater = firstGreater.next!
            }
            iter = iter.next!
        }
    }
    
    static func testExercise4() {
        //var list = Node(data: 1, next: Node(data: 2, next: Node(data: 6, next: Node(data: 5, next: Node(data: 2, next: Node(data: 3))))))
        let list = Node(data: 6)
        exercise4(list, x: 4)
        print("\(list.data)")
        var iter = list
        while let next = iter.next {
            print("\(next.data)")
            iter = iter.next!
        }
        // Solved in 18 minutes
        // Complexity : O(n) and O(1) space
        // Trick was to keep a pointer to the node with the first element greater than X and swapping all values less than X with it and advancing it
        // Book solution was to use separate before and after lists and merge them at the end. My solution is better because it's in-place, however
        // it's not stable in the sense that it doesn't preserve the order of the elements
        // BOnus!
    }

    public static func run() {
        testExercise4()
    }

}

public struct Chapter2_Exercise5 : ExerciseRunnable {

    // You have two numbers represented by a linked list, where each node contains a single digit. The digits are stored in reverse order, such that the 1's digit is at
    // the head of the list. Write a function that adds the two numbers and returns the sum as a linked list.
    
    static func sum(a: Int, b: Int, carry: Int) -> (Int, Int) {
        
        print("adding \(a) + \(b) + \(carry)")
        var c = 0
        var result = a + b + carry
        if result >= 10 {
            c = 1
            result -= 10
        }
        return (result, c)
    }
    static func exercise5(a: Node, b: Node) -> Node {
        
        var iterA = a
        var iterB = b
        
        var (result, carry) = sum(a.data, b: b.data, carry: 0)
        let list = Node(data: result)
        var l = list
        var moreA : Bool = iterA.next !== nil
        var moreB : Bool = iterB.next !== nil
        while moreA || moreB || carry > 0 {
            var dataA = 0
            if let aa = iterA.next {
                dataA = aa.data
                iterA = aa
            }
            var dataB = 0
            if let bb = iterB.next {
                dataB = bb.data
                iterB = bb
            }
            (result, carry) = sum(dataA, b: dataB, carry: carry)
            l.next = Node(data: result)
            l = l.next!
            moreA = iterA.next !== nil
            moreB = iterB.next !== nil
        }
        return list
    }
    static func testExercise5() {
        //        var listA = Node(data: 1, next: Node(data: 2, next: Node(data: 6, next: Node(data: 5, next: Node(data: 2, next: Node(data: 3))))))
        //        var listB = Node(data: 0, next: Node(data: 7, next: Node(data: 4, next: Node(data: 5))))
        let listA = Node(data: 1, next: Node(data: 2, next: Node(data: 6, next: Node(data: 5, next: Node(data: 2, next: Node(data: 3))))))
        let listB = Node(data: 9, next: Node(data: 7, next: Node(data: 3, next: Node(data: 4, next: Node(data: 7, next: Node(data: 6))))))
        let result = exercise5(listA, b: listB)
        
        print("\(result.data)")
        var iter = result
        while let next = iter.next {
            print("\(next.data)")
            iter = iter.next!
        }
        // Solved in 22 minutes.
        // Takes linear time
        // Builds a new linked list.
        // Possible to extend one of the lists with the result (maybe)
    }
    
    // FOLLOW UP
    // Suppose the digits are stored in forward order. Repeat the above problem

    public static func run() {
        testExercise5()
    }

}


public struct Chapter2_Exercise6 : ExerciseRunnable {

    // Given a circular linked list, implement an algorithm which returns the node at the beginning of the loop
    // DEFINITION
    // Circular linked list: A (corrupt) linked list in which a node's next pointer points to an earlier node, so as to make a loop in the linked list
    // Example
    // Input : A -> B -> C -> D -> E -> C [the same C as earlier]
    // Output: C
    static func exercise6(list : Node) -> Int {
        
        var nodes : [Node : Bool] = [ : ]
        
        var iter = list
        nodes[iter] = true
        while let next = iter.next {
            if nodes[next] == true {
                return next.data
            }
            nodes[next] = true
            //print("\(next.data)")
            iter = iter.next!
        }
        return 0
    }
    static func exercise6quadratic(list : Node) -> Int {
        
        var nodes : [Node] = []
        var iter = list
        nodes.append(iter)
        while let next = iter.next {
            for previous in nodes {
                if previous === next {
                    return previous.data
                }
            }
            nodes.append(next)
            //print("\(next.data)")
            iter = iter.next!
        }
        return 0
    }
    static func exercise6runner(list : Node) -> Int {
        
        //        var found = 0
        var iter = list
        var iter2 = list
        while let _ = iter.next {
            if let next2Next = iter2.next?.next {
                iter2 = next2Next
                print("comparing \(iter.data) with \(iter2.data)")
                if (iter2 === iter) {
                    return iter.data
                }
            }
            else {
                return 0
            }
            //print("\(next.data)")
            iter = iter.next!
        }
        return 0
    }
    static func testExercise6() {
        
        let node6 = Node(data: 6)
        let node5 = Node(data: 5, next: node6)
        let node4 = Node(data: 4, next: node5)
        let node3 = Node(data: 3, next: node4)
        let node2 = Node(data: 2, next: node3)
        let node1 = Node(data: 1, next: node2)
        let list = node1
        node6.next = node1
        
        let repeated = exercise6runner(list)
        print("\(repeated)")
        
        // Solved in 14 min
        // Came up with 2 possible solutions
        // The first one is to store nodes as keys on a hash table. This comes with the complication of having to find a way to calculate the hash of a pointer,
        // which some languages may even disallow. If possible, solution is O(n)
        // Other solution is to store all values in an array and checking for object identity which will lead to a solution in O(n2) time and O(n) space
        
        // Only solved part of the problem.
        // Need to observe that the collision point is k steps from the begining of the circle so resetting the start pointer and walking both pointers
        // by 1 will have them meet at the beginning of the cycle.
        // Could have implemented it better.
    }
    
    public static func run() {
        testExercise6()
    }

}


public struct Chapter2_Exercise7 : ExerciseRunnable {

    // Implement a function to check if a linked list is a palindrome
    static func exercise7(list : Node) -> Bool {
        
        if list.next == nil {
            return true
        }
        print("Inserting \(list.data)")
        var reverse = Node(data: list.data)
        var iter = list
        var iter2 = list
        while let next2 = iter2.next?.next {
            iter = iter.next!
            print("Inserting \(iter.data)")
            reverse = Node(data: iter.data, next: reverse)
            iter2 = next2
        }
        if iter2.next !== nil {
            iter = iter.next!
        }
        iter2 = reverse
        print("iter: \(iter.data)")
        print("Comparing \(iter2.data) with \(iter.data)")
        if iter2.data != iter.data {
            return false
        }
        while let next = iter.next {
            iter2 = iter2.next!
            print("Comparing \(iter2.data) with \(next.data)")
            if iter2.data != next.data {
                return false
            }
            iter = iter.next!
        }
        return true
    }
    
    static func testExercise7() {
        //next:
        let listB = Node(data: 1, next: Node(data: 2, next: Node(data: 3, next: Node(data: 4, next :Node(data: 3, next: Node(data: 2, next: Node(data: 1)))))))
        let result = exercise7(listB)
        print("palindrome: \(result)")
        // Can solve in N + N/2 steps and O(n) extra space
        
        // MEntioned trivial for double linked list
        // Solved in 15 min with auxiliary array -> could have built an alternative linked list instead
        // Final solution in 28 minutes without array, works in N steps, O(1) extra space
        // Book points out that a recursive solution can be found.
        // TODO: Study recursion
    }
    
    public static func run() {
        testExercise7()
    }
}

/*
Learned from this chapter:
Hash tables help with duplicate, counting elements problems
Runner helps with problems that require to calculate the length of the list of do a given number of steps
Remember that insert in place / delete in place operations on list are O(1)
Finding loops in list can be done with runner + some clever observations about the properties of the list
Palindrome list test can be solved with runner approach
*/
