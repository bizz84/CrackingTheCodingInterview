//
//  Chapter4.swift
//  CrackingCodeInterview
//
//  Created by Andrea Bizzotto on 26/07/2014.
//  Copyright (c) 2014 musevisions. All rights reserved.
//

import Foundation

// TODO: Port to new exercise format (see Chapter1, Chapter2)

/*
Intro
Worst case & average case can vary wildly.
Need to be able to implement a tree or graph from scratch

Always clarify if tree is binary tree or binary search tree
Clarify if it's balanced or not
Full and complete -> Must have 2^n - 1 nodes
*/

class GraphNode<T> {
    
    var visited = false
    var data: T
    var nodes: [GraphNode<T>]
    
    init(data: T) {
        self.data = data
        self.nodes = []
    }
    init(data: T, nodes: GraphNode<T>...) {
        self.data = data
        self.nodes = nodes
    }
}


class BinaryNode<T> {
    
    var data: T
    var left: BinaryNode<T>?
    var right: BinaryNode<T>?
    var parent : BinaryNode<T>?
    
    init(data: T) {
        self.data = data
    }
    init(data: T, left: BinaryNode<T>?, right: BinaryNode<T>?) {
        self.data = data
        self.left = left
        self.right = right
    }
}

class Ancestors<T> {
    var ancestor1 : BinaryNode<T>?
    var ancestor2 : BinaryNode<T>?
    init() {
        
    }
}


public class Chapter4 {
    
    func postOrder<T>(node : BinaryNode<T>?, operation: (data: T) -> ()) {
        
        if let n = node {
            print("(")
            postOrder(n.left, operation: operation)
            postOrder(n.right, operation: operation)
            print("\(n.data)")
            operation(data: n.data)
            print(")")
        }
    }
    func inOrder<T>(node : BinaryNode<T>?, operation: (data: T) -> ()) {
        
        if let n = node {
            print("(")
            inOrder(n.left, operation: operation)
            print("\(n.data)")
            operation(data: n.data)
            inOrder(n.right, operation: operation)
            print(")")
        }
    }
    func preOrder<T>(node : BinaryNode<T>?, operation: (data: T) -> ()) {
        
        if let n = node {
            print("(")
            print("\(n.data)")
            operation(data: n.data)
            preOrder(n.left, operation: operation)
            preOrder(n.right, operation: operation)
            print(")")
        }
    }
    
    func breadthFirst<T>(node : BinaryNode<T>?) {
        
        if let n = node {
            var nodes : [BinaryNode<T>] = []
            nodes.append(n)
            while nodes.count > 0 {
                let q = nodes.removeAtIndex(0)
                print("\(q.data), ")
                if q.left !== nil {
                    nodes.append(q.left!)
                }
                if q.right !== nil {
                    nodes.append(q.right!)
                }
            }
        }
        print()
    }
    
    
    func balanced<T>(node : BinaryNode<T>?, level: Int, inout min : Int, inout max : Int) {
        
        if let n = node {
            //print("(")
            balanced(n.left, level: level + 1, min: &min, max: &max)
            //print("\(n.data)")
            balanced(n.right, level: level + 1, min: &min, max: &max)
            //print(")")
        }
        else {
            if level > max {
                max = level
            }
            if level < min {
                min = level
            }
        }
    }
    
    func isBalanced<T>(node: BinaryNode<T>?) -> Bool {
        
        var min = Int.max
        var max = Int.min
        balanced(node, level: 0, min: &min, max: &max)
        print("min: \(min), max: \(max)")
        return max - min <= 1
    }
    
    // Implement a function to check if a binary tree is balanced. For the purposes of this question, a balanced tree is defined to be a tree
    // such that the heights of the subrees of any node never differ by more than one.
    func exercise1() {
        
        //        let tree = BinaryNode(data: 0,
        //            left:BinaryNode(data: -10, left:BinaryNode(data: -15), right:BinaryNode(data: -5)),
        //            right:BinaryNode(data: 10, left:BinaryNode(data: 5), right:BinaryNode(data: 15)))
        
        let tree = BinaryNode(data: 0,
            left:BinaryNode(data: -10, left:BinaryNode(data: -15), right:BinaryNode(data: -5)),
            right:nil)
        
        print("\(isBalanced(tree))")
        
        // Solved in 11 minutes
        // Algorithm takes linear time and recursively computes the depth of each node, keeping 2 variables for min & max
        
        // Solution on book implements a checkHeight method which returns -1 in some cases
        // My solution should be equivalent
    }
    
    
    func explore<T>(node: GraphNode<T>?, end: GraphNode<T>) -> Bool {
        
        if let n = node {
            if n.visited {
                return false
            }
            n.visited = true
            if n === end {
                return true
            }
            for next in n.nodes {
                if explore(next, end: end) {
                    return true
                }
            }
        }
        return false
    }
    
    func findRoute<T>(start : GraphNode<T>, end: GraphNode<T>) -> Bool {
        
        return explore(start, end: end)
    }
    
    //Given a directed graph, design an algorithm to find out whether there is a route between two nodes
    func exercise2() {
        
        let node6 = GraphNode(data: 6)
        let node5 = GraphNode(data: 5, nodes: node6)
        let node7 = GraphNode(data: 7)
        let node3 = GraphNode(data: 3, nodes: node7)
        let node4 = GraphNode(data: 4, nodes: node7)
        let node2 = GraphNode(data: 2, nodes: node3, node4, node5)
        let node1 = GraphNode(data: 1, nodes: node2)
        let _ = GraphNode(data: 0, nodes: node1, node2)
        
        let start = node4
        let end = node6
        let res = findRoute(start, end: end)
        print("\(start.data) -> \(end.data): \(res)")
        
        // Solved in 16 minutes.
        // Implemented my own graph node structure (didn't look into matrix representation of graphs)
        // Solution discards nodes already visited.
        // Since it visits nodes at most once and visits at most all nodes, solution is O(n)
        
        // Didn't occurr to me to mention that breadth first may be able to find the shortest path
        // as depth first may choose a longer one
    }
    
    func buildTree(array: [Int], left: Int, right: Int) -> BinaryNode<Int>? {
        
        if (left <= right) {
            let middle = Int((left + right) / 2)
            let leftSubtree = buildTree(array, left: left, right: middle - 1)
            let rightSubtree = buildTree(array, left: middle + 1, right: right)
            
            return BinaryNode(data: array[middle], left: leftSubtree, right: rightSubtree)
        }
        return nil
    }
    
    // Given a sorted (increasing order) array with unique integer elements, write an algorithm to create a
    // binary search tree with minimal height
    func exercise3() {
        let array = [1, 2, 3, 4, 5, 6, 7]
        let tree = buildTree(array, left: 0, right: array.count - 1)
        inOrder(tree, operation: { (data) in })
        
        // Completed in 11 minutes (6 lines of code)
        // Observed that the tree with minimal height is the one that evenly splits the array at each iteration
    }
    
    
    
    func updateLists(node : BinaryNode<Int>?, level: Int, inout lists : [Node]) {
        
        if let n = node {
            if level == lists.count {
                let listForLevel = Node(data: n.data)
                lists.append(listForLevel)
            }
            else {
                let listForLevel = lists[level]
                listForLevel.append(n.data)
            }
            updateLists(n.left, level: level + 1, lists: &lists)
            updateLists(n.right, level: level + 1, lists: &lists)
        }
    }
    
    // Given a binary tree, design an algorithm which creates a linked list of all the nodes at each depth (e.g if you have a
    // tree with depth D, you'll have D Linked lists)
    func exercise4() {
        var lists : [Node] = []
        let tree = BinaryNode(data: 0,
            left:BinaryNode(data: -10, left:BinaryNode(data: -15), right:BinaryNode(data: -5)),
            right:BinaryNode(data: 10, left:BinaryNode(data: 5), right:BinaryNode(data: 15)))
        
        updateLists(tree, level: 0, lists: &lists)
        let level = 0
        for node in lists {
            print("level \(level) : \(node.asString())")
        }
        
        // Completed in 14 minutes
        // Algorighm reuses in-order trasversal to build the list
        // Each time we enter a new level, create a new list for it. For subsequent elements in the same level, just append at the end of the list
        // Tail recursion
        
        // Book also proposes a breadth search solution. Slightly confusing
    }
    
    //    func isBinarySearchTree(node: BinaryNode<Int>?) -> (Bool, Int, Int) {
    //        if node === nil {
    //            return (false, 0, 0)
    //        }
    //        var min = Int.max
    //        var max = Int.min
    //        if node.left !== nil {
    //            var (leftSearch, minLeft, maxLeft) = isBinarySearchTree(node.left!)
    //            if maxLeft > node.data {
    //                return (false, 0, 0)
    //            }
    //            min = minLeft
    //        }
    //        else {
    //            min = node.data
    //        }
    //        if node.right !== nil {
    //            var (rightSearch, minRight, maxRight) = isBinarySearchTree(node.right!)
    //            if minRight < node.data {
    //                return (false, 0, 0)
    //            }
    //            max = maxRight
    //        }
    //        else {
    //            max = node.data
    //        }
    //        return (true, min, max)
    //    }
    
    
    func isBinarySearchTree(node: BinaryNode<Int>) -> (Bool, Int, Int) {
        var min = node.data
        var max = node.data
        var ok = true
        if node.left !== nil {
            let (okLeft, minLeft, maxLeft) = isBinarySearchTree(node.left!)
            if maxLeft > node.data || !okLeft {
                ok = false
            }
            min = minLeft
        }
        if node.right !== nil {
            let (okRight, minRight, maxRight) = isBinarySearchTree(node.right!)
            if minRight < node.data || !okRight {
                ok = false
            }
            max = maxRight
        }
        return (ok, min, max)
        // TODO: Should rewrite to take in min and max as parameters rather than returning them
    }
    
    func isBinarySearchTreeMinMax(node : BinaryNode<Int>?, min : Int, max: Int) -> Bool {
        
        if node === nil {
            return true
        }
        if node!.data <= min || node!.data > max {
            return false
        }
        let bstLeft = isBinarySearchTreeMinMax(node!.left, min : min, max: node!.data)
        let bstRight = isBinarySearchTreeMinMax(node!.right, min: node!.data, max: max)
        return bstLeft && bstRight
    }
    
    // Implement a function to check if a binary tree is a binary search tree
    func exercise5() {
        
        let tree = BinaryNode(data: 20,
            left:BinaryNode(data: 10),
            right:BinaryNode(data: 30, left:BinaryNode(data: 21), right:nil))
        
        //        let isBinarySearch = isBinarySearchTree(tree)
        let isBinarySearch = isBinarySearchTreeMinMax(tree, min: Int.min, max: Int.max)
        
        print("binary search: \(isBinarySearch)")
        // Solved in 21 minutes
        // Not very clearly defined in my mind, eventually found right solution
        // Solution is O(n)
        // Should have explained better on paper
    }
    
    
    func findNextInAncestors(var node : BinaryNode<Int>, value: Int) -> BinaryNode<Int>? {
        
        while node.parent !== nil {
            node = node.parent!
            if node.data > value {
                return node
            }
        }
        return nil
    }
    
    func findInDescendants(var node : BinaryNode<Int>) -> BinaryNode<Int>? {
        while node.left !== nil {
            node = node.left!
        }
        return node
    }
    
    func exercise6(node : BinaryNode<Int>) -> BinaryNode<Int>? {
        if node.right !== nil {
            // Need to descend
            return findInDescendants(node.right!)
        }
        if node.parent === nil {
            return nil
        }
        return findNextInAncestors(node.parent!, value : node.data)
    }
    
    // Write an algorithm to find the 'next' node (i.e. in order successor) of a given node in a binary search tree.
    // You may assume that each node has a link to its parent.
    func testExercise6() {
        
        //      let node10 = BinaryNode(data: 10)
        let node3 = BinaryNode(data: 3)
        let node2 = BinaryNode(data: 2)
        let node5 = BinaryNode(data: 5)
        let node7 = BinaryNode(data: 7)
        let node6 = BinaryNode(data: 6)
        //        node10.left = node3
        node3.left = node2
        node3.right = node5
        node5.right = node7
        node7.left = node6
        node7.parent = node5
        node5.parent = node3
        node2.parent = node3
        node6.parent = node7
        //        node3.parent = node10
        
        let foundNode = exercise6(node5)
        
        if foundNode !== nil {
            print("next in order: \(foundNode!.data)")
        }
        else {
            print("element is last in order")
        }
        
        // solved in 20 minutes
        // Worst case complexity: O(n) if tree is degenerate where input node is last in order
        // Average complexity: O(logN) if tree is balanced
        
        // Algorithm is correct however it would have been preferable to better name the submethods
        // Also need to learn to explain better as I go.
        
        // Typically I can explain well when I nail it, but need a bit of trial when it's not obvious.
    }
    
    func ancestor<T>(node: BinaryNode<T>?, node1 : BinaryNode<T>, node2 : BinaryNode<T>, inout ancestors : Ancestors<T>) -> BinaryNode<T>? {
        
        if let n = node {
        
            ancestor(n.left, node1: node1, node2: node2, ancestors: &ancestors)
            ancestor(n.right, node1: node1, node2: node2, ancestors: &ancestors)
            
            // Extra conditions to check we actually assign only ancestors
            if ancestors.ancestor2 !== ancestors.ancestor1 && ancestors.ancestor1 !== nil && (n.left === ancestors.ancestor1 || n.right === ancestors.ancestor1) {
                ancestors.ancestor1 = n
            }
            if ancestors.ancestor2 !== ancestors.ancestor1 && ancestors.ancestor2 !== nil && (n.left === ancestors.ancestor2 || n.right === ancestors.ancestor2)  {
                ancestors.ancestor2 = n
            }
            // Discovery step
            if n === node1 {
                ancestors.ancestor1 = node1
            }
            if n === node2 {
                ancestors.ancestor2 = node2
            }
            if ancestors.ancestor1 !== nil && ancestors.ancestor2 !== nil && ancestors.ancestor1 === ancestors.ancestor2 {
                return ancestors.ancestor1
            }
        }
        return nil
    }
    
    // Design an algorithm and write the code to find the first common ancestor of two nodes in a binary tree.
    // Avoid storing additional nodes in a data structure.
    // NOTE: This is not necessarily a binary search tree.
    func exercise7() {
        
        //      let node10 = BinaryNode(data: 10)
        let node0 = BinaryNode(data: 0)
        let node1 = BinaryNode(data: 1)
        let node2 = BinaryNode(data: 2)
        let node3 = BinaryNode(data: 3)
        let node4 = BinaryNode(data: 4)
        let node5 = BinaryNode(data: 5)
        let node6 = BinaryNode(data: 6)
        let node7 = BinaryNode(data: 7)
        let node8 = BinaryNode(data: 8)
        let node9 = BinaryNode(data: 9)
        
        let node10 = BinaryNode(data: 10)
        
        node2.right = node3
        node3.right = node1
        node2.left = node7
        node7.left = node4
        node7.right = node6
        node4.left = node5
        node4.right = node8
        node5.left = node9
        node6.right = node0
        
        var ancestors = Ancestors<Int>()
        let found = ancestor(node2, node1: node5, node2: node10, ancestors: &ancestors)
        
        if found === nil {
            print("not found")
        }
        else {
            print("Ancestor: \(found!.data)")
        }
        // Solved in 1h4min
        // Scans whole tree in O(n) steps. Additional O(logN) space for recursion
        // Initial approach involved calculating the lenghts in a backwards approach.
        // Faulty once found second match. Corrected to find the common ancestor by updating nodes.
        
        // Solutions in book were different but not better than mine
    }
    
    // You have two very large binary trees: T1, with millions of nodes, and T2, with hundreds of nodes. Create an algorighm to decide if T2 is a subtree of T1.
    // A tree T2 is a subtree of T1 if there exists a node n in T1 such that the subtree of T1 is identical to T2. That is, if you cut off the tree at the node n, the
    // two trees would be identical
    
    func identical(node1 : BinaryNode<Int>?, node2 : BinaryNode<Int>?) -> Bool {
        
        if node1 === nil && node2 === nil {
            return true
        }
        if node1 !== nil && node2 === nil || node2 !== nil && node1 === nil {
            return false
        }
        if node1!.data != node2!.data {
            print("\(node1!.data) != \(node2!.data)")
            return false
        }
        // must be same here
        print("\(node1!.data) == \(node2!.data)")
        let left = identical(node1!.left, node2: node2!.left)
        let right = identical(node1!.right, node2: node2!.right)
        return left && right
    }
    
    func findSubtree(tree: BinaryNode<Int>?, subtree : BinaryNode<Int>) -> Bool {
        
        if tree === nil {
            return false
        }
        if identical(tree, node2: subtree) {
            return true
        }
        if findSubtree(tree!.left, subtree: subtree) {
            return true
        }
        if findSubtree(tree!.right, subtree: subtree) {
            return true
        }
        return false
    }
    
    func exercise8() {
        
        let node0 = BinaryNode(data: 0)
        let node1 = BinaryNode(data: 1)
        let node2 = BinaryNode(data: 2)
        let node3 = BinaryNode(data: 3)
        let node4 = BinaryNode(data: 4)
        let node5 = BinaryNode(data: 5)
        let node6 = BinaryNode(data: 6)
        let node7 = BinaryNode(data: 7)
        let node8 = BinaryNode(data: 8)
        let node66 = BinaryNode(data: 6)
        let node9 = BinaryNode(data: 9)
        
        node2.right = node3
        node3.right = node1
        node2.left = node7
        node7.left = node4
        node7.right = node6
        node4.left = node5
        node4.right = node8
        node5.left = node9
        node6.right = node66
        node66.right = node0
        
        let same = findSubtree(node2, subtree: node66)
        
        print("same: \(same)")
        
        // Solved in 20 minutes
        // Runtime: O(T1 * T2) (worst case)
        // Any optimisation on this would have to be clever about partial tree matches which should not be expected on an interview
        
        // Did not think about converting to string and performing linear scan
        
        // This problem had a very interesting complexity analysis which I should review
    }
    
    func printSubPath(node : BinaryNode<Int>, sum : Int) {
        if node.data > sum {
            return
        }
        if node.data == sum {
            print("\(sum)")
            return
        }
        var s = "\(node.data) "
        var iter = node
        var count = node.data
        while iter.left !== nil {
            iter = iter.left!
            count += iter.data
            s += "\(iter.data) "
            if count > sum {
                break
            }
            if count == sum {
                print("\(s)")
                break
            }
        }
        s = "\(node.data) "
        iter = node
        count = node.data
        while iter.right !== nil {
            iter = iter.right!
            count += iter.data
            s += "\(iter.data) "
            if count > sum {
                break
            }
            if count == sum {
                print("\(s)")
                break
            }
        }
        return
    }
    
    func subPathLeft(var node : BinaryNode<Int>, sum : Int) -> String? {
        if node.data > sum {
            return nil
        }
        if node.data == sum {
            return nil
        }
        var s = "\(node.data) "
        var count = node.data
        
        while node.left !== nil {
            node = node.left!
            count += node.data
            s += "\(node.data) "
            if count > sum {
                return nil
            }
            if count == sum {
                return s
            }
        }
        return nil
    }
    func subPathRight(var node : BinaryNode<Int>, sum : Int) -> String? {
        if node.data > sum {
            return nil
        }
        if node.data == sum {
            return nil
        }
        var s = "\(node.data) "
        var count = node.data
        
        while node.right !== nil {
            node = node.right!
            count += node.data
            s += "\(node.data) "
            if count > sum {
                return nil
            }
            if count == sum {
                return s
            }
        }
        return nil
    }
    
    func printPaths(node : BinaryNode<Int>?, sum: Int) {
        
        if let n = node {
            printSubPath(n, sum: sum)
            //            if n.data == sum {
            //                print("\(sum)")
            //            }
            //            if let s = subPathLeft(n, sum: sum) {
            //                print("\(s)")
            //            }
            //            if let s = subPathRight(n, sum: sum) {
            //                print("\(s)")
            //            }
            printPaths(n.left, sum: sum)
            printPaths(n.right, sum: sum)
        }
    }
    
    // You are given a binary tree in which each node contains a value. Design an algorithm to print all paths which sum to a given value. The path
    // does not need to start or end at the root or a leaf, but it must go in a straight line down
    func exercise9() {
        
        let tree = BinaryNode(data: 1,
            left:BinaryNode(data: 4, left:BinaryNode(data: 3), right:BinaryNode(data: 2, left: BinaryNode(data: 5), right: BinaryNode(data: 7))),
            right:BinaryNode(data: 2, left:nil, right:BinaryNode(data: 4)))
        
        printPaths(tree, sum: 7)
        // Solved in 21 minutes, can be refactored
        // Similarly to previous solution, runtime is likely to be linear plus a small factor
        // O(n + k*avg)
        // Where k is number of paths that sum to the given value and avg is their average length
        
        // Assumed that all number were positive
        // If all numbers can be positive or negative, can have multiple paths starting at same node which complicates the solution
        // Read up!
    }
    
    public init() {
        
//        let tree = BinaryNode(data: 0,
//            left:BinaryNode(data: -10, left:BinaryNode(data: -15), right:BinaryNode(data: -5)),
//            right:BinaryNode(data: 10, left:BinaryNode(data: 5), right:BinaryNode(data: 22)))
        
        
        //        preOrder(tree, { (data) in })
        //        print()
        //        inOrder(tree, { (data) in  })
        //        postOrder(tree, { (data) in  })
        //        exercise1()
        //        exercise2()
        //        exercise3()
        //        exercise4()
        //exercise5()
        //        testExercise6()
        //        exercise7()
        //        exercise8()
        //        exercise9()
    }
    
}