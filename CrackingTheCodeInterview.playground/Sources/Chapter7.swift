//
//  Chapter7.swift
//  CrackingCodeInterview
//
//  Created by Andrea Bizzotto on 01/08/2014.
//  Copyright (c) 2014 musevisions. All rights reserved.
//

import Foundation


public class Chapter7 {
    
    // 7.1 You have a basketball hoop and someone says you can play one of two games
    // Game1: You get one shot to make the hoop
    // Game2: You get three shots and you have to make 2 of 3 shots
    // If p is the probability of making a particular shot, for which values of p should you pick one game or ther other?
    
    /*
    p(hoop) = p
    p(at least 2) = p(2) + p(3) = 3 * p2 * (1-p) + p3
    Should choose game 1 if
    p > 3 * p2 * (1-p) + p3
    2p3 - 3p2 + p > 0
    (2p - 1)(p - 1) > 0 -> p - 1 > 0 for all p < 1 ->
    2p - 1 < 0   for p < 0.5
    -> Should choose game 1 if p < 0.5
    */
    
    // There are three ants on different vertices of a triangle. What is the probability of collision (between any two or all of them) if they start walking on the sides of the triangle?
    // Assume that each ant randomly picks a direction, with either direction being equally likely to be chosen, and that they walk at the same speed.
    // Similarly, find the probability of collision with n ants on an n-vertex polygon
    
    /*
    P(no collision) = P(left)^3 + P(right)^3 = 0.5^3 + 0.5^3 = 1/4
    P(collision) = 1 - P(no collision) = 3/4
    
    For N vertices -> 1 - (1/2)^N-1
    */
    
    // Given two lines on a cartesian plane, determine whether the two lines would intersect
    /*
    Ask Questions!
    How are the lines represented as? Implicit equation?, slope and offset from Y?
    What if they are the same line?
    decide data structure
    */
    
    class Line {
        let epsilon = 0.000001
        let slope : Float
        let offset : Float
        init(slope : Float, offset: Float) {
            self.slope = slope
            self.offset = offset
        }
        
        func intersects(l: Line) -> Bool {
            if slope == l.slope && offset == l.offset {
                return true
            }
            if slope == l.slope {
                return false
            }
            return true
        }
        
    }
    //    extension Line
    
    func exercise3() {
        let line1 = Line(slope: 0.5, offset: 10)
        let line2 = Line(slope: 0.5, offset: 11)
    }
    
    // Write methods to implement the multiply, subtract and divide operations for integers. Use only the add operator
    func multiply(a: Int, b: Int) -> Int {
        if a == 0 || b == 0 {
            return 0
        }
        
        
        let bb = abs(b)
        var mult = a
        for var count = 1; count < bb; count++ {
            mult += a
        }
        if b < 0 {
            mult = invert(mult)
        }
        
        return mult
    }
    
    func invert(var a: Int) -> Int {
        var neg = 0
        let d = a > 0 ? -1 : 1
        while a != 0 {
            neg += d
            a += d
        }
        return neg
    }
    
    
    func subract(a: Int, b: Int) -> Int {
        return a + invert(b)
        // Did not quite get that invert was required
    }
    
    func divide(a: Int, b: Int) -> Int {
        
        if b == 0 {
            // Error
            return 0
        }
        var x = 0
        let willInvert = a < 0 && b > 0 || a > 0 && b < 0
        var aa = abs(a)
        let bb = abs(b)
        while aa >= 0 {
            aa -= bb
            x++
        }
        x = x + -1
        if willInvert {
            x = invert(x)
        }
        return x
    }
    
    func testMultiply() {
        
        let a = 2
        let b = 0
        let c = divide(a, b: b);
        print("a: \(a), b: \(b), c: \(c)")
        
        // Way over 30 min
        // Struggled to find replacement for subtract
        // Implemented divide with a few bugs but solved with some tests
        // Special handling needed for b = 0
        // Forgot optimisation for making multiplication faster
    }
    
    // Given two squares on a two-dimensional plane, find a line that would cut these two squares in half. Assume that the top and the bottom sides of the square run parallel to the x axis.
    
    class Square {
        
        var side: Double
        var centerX: Double
        var centerY: Double
        init(centerX: Double, centerY: Double, side: Double) {
            self.centerX = centerX
            self.centerY = centerY
            self.side = side
        }
        //        init(left: Double, top: Double, side: Double) {
        //
        //        }
    }
    
    // Line: ax + by + c = 0
    class LineForSquare {
        var x0: Double
        var y0: Double
        var dx: Double // Normalise this
        var dy: Double
        init(x0: Double, y0: Double, dx: Double, dy: Double) {
            self.x0 = x0
            self.y0 = y0
            self.dx = dx
            self.dy = dy
        }
        
        
    }
    
    func intersection(s1: Square, s2: Square) -> LineForSquare  {
        
        if s1.centerX == s2.centerX && s1.centerY == s2.centerY {
            // return any line passing at this point
            return LineForSquare(x0: s1.centerX, y0: s1.centerY, dx : 1, dy: 0)
        }
        let dx = s1.centerX - s2.centerX
        let dy = s1.centerY - s2.centerY
        let l = LineForSquare(x0: s1.centerX, y0: s1.centerY, dx : dx, dy: dy)
        return l
    }
    
    func exercise5() {
        
        let sq1 = Square(centerX: 5, centerY: 5, side: 10)
        let sq2 = Square(centerX: 20, centerY: 30, side: 15)
        let l = intersection(sq1, s2: sq2)
    }
    
    // Skip 7.6, 7.7
    
    public init() {
        exercise5()
    }
    
}
