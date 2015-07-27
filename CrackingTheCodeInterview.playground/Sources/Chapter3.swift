//
//  Chapter3.swift
//  CrackingCodeInterview
//
//  Created by Andrea Bizzotto on 25/07/2014.
//  Copyright (c) 2014 musevisions. All rights reserved.
//

import Foundation

class ArrayStack {
    
    var array: [Int] = []
    
    func push(data: Int) {
        array.append(data)
    }
    func pop() -> Int {
        return array.removeLast()
    }
    func peek() -> Int {
        // TODO Error if empty
        return array[array.count - 1]
    }
    func empty() -> Bool {
        return array.count == 0
    }
    func asString() -> String {
        var s = "( "
        for value in array {
            s += "\(value) "
        }
        s += ")"
        return s
    }
    init() {
        
    }
}

class Stack {
    
    var top : Node?
    
    init() {
        top = nil
    }
    init(top: Node?) {
        self.top = top
    }
    
    func push(data: Int) {
        top = Node(data: data, next: top)
    }
    
    func pop() -> Int {
        if (top !== nil) {
            let result = top!.data
            top = top!.next
            return result
        }
        return -1
    }
    func peek() -> Int {
        return top !== nil ? top!.data : -1
    }
    func empty() -> Bool {
        return top === nil
    }
    
    func asString() {
        
    }
}

public class Chapter3 {
    
    class ThreeStacks {
        
        var array : [Int] = []
        
        var sizes : [Int] = [ 0, 0, 0 ]
        
        func arrayIndexForStack(index: Int) -> Int {
            if index == 0 {
                return 0
            }
            if index == 1 {
                return sizes[0]
            }
            if index == 2 {
                return sizes[0] + sizes[1]
            }
            return -1
        }
        func push(index: Int, data: Int) {
            sizes[index]++
            let indexToInsert = arrayIndexForStack(index)
            array.insert(data, atIndex: indexToInsert)
        }
        func pop(index: Int) -> Int {
            if sizes[index] == 0 {
                return -1
            }
            sizes[index]--
            let indexToInsert = arrayIndexForStack(index)
            return array.removeAtIndex(indexToInsert)
        }
        func peek(index: Int) -> Int {
            if sizes[index] == 0 {
                return -1
            }
            let indexToInsert = arrayIndexForStack(index)
            return array[indexToInsert]
        }
        
        func describe() -> String {
            var s = "( "
            for var i = sizes[0] - 1; i >= 0; i-- {
                s += "\(array[i]) "
            }
            s += ")( "
            for var i = sizes[1] + sizes[0] - 1; i >= sizes[0]; i-- {
                s += "\(array[i]) "
            }
            s += ")( "
            for var i = sizes[2] + sizes[1] + sizes[0] - 1; i >= sizes[0] + sizes[1]; i-- {
                s += "\(array[i]) "
            }
            s += ")"
            return s
        }
        
        init() {
            
        }
    }
    
    // Describe how you would use a single array to implement 3 stacks
    func testExercise1() {
        // 1, 2, 3 -> 3, 2, 1
        // 4, 5, 6 -> 6, 5, 4
        // 7, 8, 9 -> 9, 8, 7
        let stack = ThreeStacks()
        stack.push(0, data: 1)
        stack.push(1, data: 4)
        stack.push(2, data: 7)
        stack.push(0, data: 2)
        stack.push(1, data: 5)
        stack.push(2, data: 8)
        print("p1: \(stack.pop(0))") // 2
        print("p2: \(stack.pop(1))") // 5
        print("p2: \(stack.pop(1))") // 4
        stack.push(0, data: 3)
        stack.push(1, data: 6)
        stack.push(2, data: 9)
        print("p3: \(stack.pop(2))") // 9
        print("p1: \(stack.pop(0))") // 3
        print("p2: \(stack.pop(1))") // 6
        print("p1: \(stack.pop(0))") // 1
        print("p1: \(stack.pop(0))") // 1
        print("p3: \(stack.pop(2))") // 8
        print("p3: \(stack.pop(2))") // 7
        // Completed in 24 minutes
        // Well analysed solution
        // Initial idea was valid, but solution became better once I took full advantage of the ability to insert in place on a dynamic array
        // Push/pops are O(1) due to amortised array insert/remove
        // Would not work as well with a list
        
        // Should have asked whether we wanted to allocate fixed space or flexible space to stacks
        // Forgot to add exception handling code
        // Does not extend nicely if we wanted to support more than 3 stacks
    }
    
    
    class NodeWithMin {
        var data: Int
        var min: Int
        init(data: Int, min: Int) {
            self.data = data
            self.min = min
        }
    }
    
    class StackWithMin {
        
        var array: [NodeWithMin] = []
        
        func push(data: Int) {
            let m = min(data, minValue())
            array.append(NodeWithMin(data: data, min: m))
        }
        func pop() -> Int {
            return array.removeLast().data
        }
        func peek() -> NodeWithMin {
            // TODO Error if empty
            return array[array.count - 1]
        }
        func minValue() -> Int {
            if array.count == 0 {
                return Int.max
            }
            return peek().min
        }
        init() {
            
        }
    }
    
    // How would you design a stack which, in addition to push and pop, also has a function min that returns the minimum element? Push, pop and min should all operate in O(1) time
    func testExercise2() {
        
        // Evaluated whether it's possible to store the minimum on a linked list.
        // If a pop causes the minimum to be remove, the next available minimum can't be found in O(1) time if some sort of ordering isn't kept
        // Spent the whole time thinking it was a queue
        // Discovered that this can't be done with a queue
        
        let s = StackWithMin()
        
        s.push(7)
        print("\(s.minValue())")
        s.push(1)
        print("\(s.minValue())")
        s.push(5)
        print("\(s.minValue())")
        s.push(3)
        print("\(s.minValue())")
        s.push(4)
        print("\(s.minValue())")
        print("pop: \(s.pop()), min: \(s.minValue())")
        print("pop: \(s.pop()), min: \(s.minValue())")
        print("pop: \(s.pop()), min: \(s.minValue())")
        print("pop: \(s.pop()), min: \(s.minValue())")
        
        // 14 minutes
        // Very good learning from this exercise. Shows what can be done with stacks as a variation of existing problems
    }
    
    // Imagine a literal stack of plates. If the stack gets too high, it might topple.
    // Therefore, in real life, we would start the new stack when the previous stack exceeds some threshold.
    // Implement a data structure SetOfStacks that mimicks this. SetOfStacks should be composed of several stacks and
    // should create a new stack once the previous stack exceeds capacity. SetOfStacks.push and SetOfStacks.pop()
    // should behave identically to a single stack (that is, pop() should return the same values as it would if it
    // were just a single stack).
    
    // FOLLOW UP: implement a function popAt(int index) which performs a pop operation on a specific sub-stack
    class SimpleStack {
        
        var array : [Int] = []
        let capacity : Int
        init(capacity: Int) {
            self.capacity = capacity
        }
        
        func push(data: Int) {
            array.append(data)
        }
        
        func pop() -> Int {
            if empty() {
                return -1 // Error
            }
            return array.removeLast()
        }
        
        func full() -> Bool {
            return array.count == capacity
        }
        func empty() -> Bool {
            return array.count == 0
        }
    }
    
    class SetOfStacks {
        
        var stacks : [SimpleStack] = []
        let capacity : Int
        func push(data : Int) {
            
            if (stacks.count == 0) {
                print("Creating first stack")
                stacks.append(SimpleStack(capacity: self.capacity))
            }
            var lastStack = stacks[stacks.count - 1]
            if lastStack.full() {
                print("Creating another stack")
                stacks.append(SimpleStack(capacity: self.capacity))
                lastStack = stacks[stacks.count - 1]
            }
            lastStack.push(data)
        }
        
        func pop() -> Int {
            if (stacks.count == 0) {
                // Error
                print("Stack is empty: Error")
                return -1
            }
            let lastStack = stacks[stacks.count - 1]
            let result = lastStack.pop()
            if lastStack.empty() {
                print("Discarding empty stack")
                stacks.removeLast()
            }
            return result
        }
        
        func popAt(index: Int) -> Int {
            if (index >= stacks.count) {
                // Error
                return -1
            }
            return stacks[index].pop()
        }
        
        init(capacity : Int) {
            
            self.capacity = capacity
        }
    }
    
    func testExercise3() {
        
        let ss = SetOfStacks(capacity: 3)
        for i in 1...9 {
            ss.push(i)
            print("pushed: \(i)")
        }
        for _ in 1...5 {
            print("popping: \(ss.pop())")
        }
        print("popping: \(ss.popAt(0))")
        
        // Completed in 19 minutes
        // Guided thorugh implementation.
        // Properly separated classes for reuse. Push implemnetation for SetOfStack could be cleaner
        // Good implementation, didn't ask about rollover policy, but likely would discuss this with interviewer (for bonus points)
    }
    
    // In the classic problem of the Towers of Hanoi, you have 3 towers and N disks of different sizes which can slide onto any tower.
    // The puzzle starts with disks sorted in ascending order of size from top to bottom (i.e. each disk sits on top of an even larger one).
    // You have the following constraints:
    // 1. Only one disk can be moved at a time
    // 2. A disk is slid off the top of one tower onto the next tower.
    // 3. A disk can only be placed on top of a larger disk
    // Write a program to move disks from the first tower to the last using stacks
    func solve(s: ThreeStacks, level: Int, origin: Int, buffer: Int, destination: Int) {
        if level == 2 {
            s.push(buffer, data: s.pop(origin))
            print("\(s.describe())")
            s.push(destination, data: s.pop(origin))
            print("\(s.describe())")
            s.push(destination, data: s.pop(buffer))
            print("\(s.describe())")
        }
        else {
            solve(s, level: level - 1, origin: origin, buffer: destination, destination: buffer)
            s.push(destination, data: s.pop(origin))
            solve(s, level: level - 1, origin: buffer, buffer: origin, destination: destination)
        }
        
    }
    func testExercise4() {
        
        let N = 12
        let s = ThreeStacks()
        for var i = N; i >= 1; i-- {
            s.push(0, data: i)
        }
        
        solve(s, level: N, origin: 0, buffer: 1, destination: 2)
        // Took 1 hour to get to the solution that works for N = 4
        // Approach is to solve for N == 2, understand solution for N = 3 given 2,
        // and determine special conditions for solving for greater N
        
        // No special conditions were required, just proper resolution of the recursive approach
    }
    
    class MyQueue {
        
        var s1: Stack
        var s2: Stack
        
        init() {
            s1 = Stack()
            s2 = Stack()
        }
        
        func push(data: Int) {
            
            while !s1.empty() {
                s2.push(s1.pop())
            }
            s1.push(data)
            while !s2.empty() {
                s1.push(s2.pop())
            }
        }
        func pop() -> Int {
            return s1.pop()
        }
    }
    // Write a MyQueue class which implements a queue using two stacks
    func testExercise5() {
        
        let q = MyQueue()
        q.push(1)
        q.push(2)
        q.push(3)
        q.push(4)
        q.push(5)
        q.push(6)
        print("\(q.pop())")
        print("\(q.pop())")
        print("\(q.pop())")
        print("\(q.pop())")
        print("\(q.pop())")
        print("\(q.pop())")
        // O(n) to do a push
        // Haven't investigated if there's a better approach
        // Solved in 17 minutes
        // Can be implemented more efficiently by only performing the swap on pop or peek
    }
    
    func reverse(from: ArrayStack, to: ArrayStack, pivot: Int) {
        var steps : Int = 0
        var usedPivot = false
        while !from.empty() {
            if usedPivot || from.peek() > pivot {
                
                print("FILL s1: \(to.asString()), s2: \(from.asString()), pop: \(from.peek()), pivot: \(pivot)")
                to.push(from.pop())
            }
            else {
                print("FILL s1: \(to.asString()), s2: \(from.asString()), pivot: \(pivot)")
                to.push(pivot)
                usedPivot = true
            }
            steps++
        }
        if !usedPivot {
            print("FILL s1: \(to.asString()), s2: \(from.asString()), pivot: \(pivot)")
            to.push(pivot)
            steps++
        }
        for _ in 1...steps {
            print("REVERSE s1: \(to.asString()), s2: \(from.asString()), pop: \(to.peek())")
            from.push(to.pop())
        }
    }
    
    func exercise6(s1: ArrayStack) -> ArrayStack {
        
        // s1: 9 1 7 5 6 2 4
        // s2: []
        // temp: 4
        let s2 = ArrayStack()
        print("s1: \(s1.asString()), s2: \(s2.asString()), pop: \(s1.peek())")
        s2.push(s1.pop())
        if s1.empty() {
            return s2;
        }
        
        while !s1.empty() {
            
            print("s1: \(s1.asString()), s2: \(s2.asString()), pop: \(s1.peek())")
            reverse(s2, to: s1, pivot: s1.pop())
        }
        print("s1: \(s1.asString()), s2: \(s2.asString())")
        return s2
    }
    
    
    
    // Write a program to sort a stack in ascending order (with biggest items on top).
    // You may use at most one additional stack to hold items, but you may not copy the elements into any other data structure (such as an array).
    // The stack supports the following operations: push, pop, peek, and isEmpty
    func testExercise6() {
        
        let s1 = ArrayStack()
        s1.push(9)
        s1.push(1)
        s1.push(7)
        s1.push(5)
        s1.push(6)
        s1.push(2)
        s1.push(4)
        
        let sorted = exercise6(s1)
        
        print("sorted: \(sorted.asString())")
        
        // Solution in 65 minutes (talk about speed!)
        // Solution is correct, it uses triangolation and a reverse algorithm to build up ordering on the stack
        // It's complexity is very likely O(n2) since a full reverse takes approx 2N steps
        // Can be done in place? Not that I'm aware of
        
        // The optimal solution has the same complexity as the one I came up with,
        // However it's much simpler and doesn't require so many reversals of the array.
        // This means that the original idea could have been simplified BEFORE implementing the solution
        
        // I need to be very aware of coming up with solutions that are simple!
    }
    
    // An animal shelter holds only dogs and cats, and operates on a strictly "first in, first out" basis.
    // People must adopt either the "oldest" (based on arrival time) of all animals at the shelter,
    // or they can select whether they would prefer a dog or a cat (and they will receive the oldest animal of that type).
    // They cannot select which specific animal they would like. Create the data structures to mantain this system
    // and implement operations such as enqueue, dequeueAny, dequeueDog and dequeueCat.
    // You may use the built-in Linked List data structure
    
    class AnimalShelter {
        
        var catsList : Node?
        var dogsList : Node?
        
        var arrival = 0
        
        func updateList(list: Node?, data: Int) -> Node {
            if list == nil {
                return Node(data: data)
            }
            list!.append(data)
            return list!
        }
        func enqueue(isDog: Bool) {
            if (isDog) {
                print("enqueuing dog: \(arrival)")
                dogsList = updateList(dogsList, data: arrival++)
            }
            else {
                print("enqueuing cat: \(arrival)")
                catsList = updateList(catsList, data: arrival++)
            }
        }
        func dequeue(inout list: Node?) -> Int {
            if list == nil {
                return -1 // No dogs left
            }
            let result = list!.data
            list = list!.next
            return result
        }
        func dequeueDog() -> Int {
            return dequeue(&dogsList)
        }
        func dequeueCat() -> Int {
            return dequeue(&catsList)
        }
        
        func peekDog() -> Int {
            return dogsList !== nil ? dogsList!.data : -1
        }
        func peekCat() -> Int {
            return catsList !== nil ? catsList!.data : -1
        }
        
        func dequeueAny() -> Int {
            let firstDogArrival = peekDog()
            let firstCatArrival = peekCat()
            if firstCatArrival == -1 && firstDogArrival == -1 {
                return -1 // No animals left
            }
            else if firstDogArrival == -1 {
                return dequeueCat()
            }
            else if firstCatArrival == -1 {
                return dequeueDog()
            }
            return firstCatArrival > firstDogArrival ? dequeueDog() : dequeueCat()
        }
        
        init() {
            
        }
    }
    
    func testExercise7() {
        
        let a = AnimalShelter()
        a.enqueue(true) // dog 0
        a.enqueue(true) // dog 1
        a.enqueue(false) // cat 2
        a.enqueue(false) // cat 3
        a.enqueue(false) // cat 4
        a.enqueue(true) // dog 5
        
        print("dequeuing dog: \(a.dequeueDog())") // 0
        print("dequeuing cat: \(a.dequeueCat())") // 2
        print("dequeuing any: \(a.dequeueAny())") // dog 1
        print("dequeuing any: \(a.dequeueAny())") // cat 3
        print("dequeuing any: \(a.dequeueAny())") // cat 4
        print("dequeuing cat: \(a.dequeueCat())") // nocats left
        print("dequeuing any: \(a.dequeueAny())") // cat 4
        
        // Implemented in 28 minutes (however Linked list was broken, spen 5 minutes fixing it)
        // Too much duplicated code in the implementation
        // Implementation is also super slow because I need to append at the end of the linked lists
        // Improved in somewhat longer time -> took time because I don't know swift that well yet
        
        // Consider extending list class?
        // Should have asked what information we desire to hold for each animal (name?)
    }
    
    public init() {
        //        testExercise1()
        //        testExercise2()
        //        testExercise3()
        //        testExercise4()
        //        testExercise6()
        testExercise7()
    }
}