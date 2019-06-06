//
//  Ball.swift
//  DoNothing
//
//  Created by Phil Stern on 6/4/19.
//  Copyright © 2019 Phil Stern. All rights reserved.
//

import UIKit

class Ball: NSObject {
    
    var angle = 0.0 {  // radians
        didSet {
            angle = max(min(angle, 30.rads), -30.rads)
        }
    }
    var rate = 0.0   // rad/sec
    var accel = 0.0  // rad/s2
    
    private var isStopping = false
    private var isHolding = false
    
    func simulate() {  // rectangular integration
        if isStopping {
            accel = 0.0
            if angle > 0.01 {
                rate = -1.0
            } else if angle < -0.01 {
                rate = 1.0
            } else {
                rate = 0.0
                angle = 0.0
                isStopping = false
                isHolding = true
            }
            angle += rate * Constants.frameTime
        } else if !isHolding {
            accel = -Constants.G / Constants.pendulumLength * sin(angle)
            rate += accel * Constants.frameTime
            angle += rate * Constants.frameTime
        }
    }
    
    func stop() {
        isStopping = true
        isHolding = false
    }
    
    func go() {
        isStopping = false
        isHolding = false
    }
    
    func reset() {
        isStopping = false
        isHolding = false
        angle = 0.0
        rate = 0.0
        accel = 0.0
    }

    static func isCollisionsBetween(balls: [Ball]) -> Bool {
        var isCollision = false
        for _ in 0..<balls.count-1 {  // make n-1 passes each time, to sort everything out
            for i in 0..<balls.count {
                // if moving right and overlapping next ball, contact occurred
                if i < balls.count-1 && balls[i].rate > 0.0 && balls[i].angle > balls[i+1].angle {
                    if abs(balls[i].rate - balls[i+1].rate) > 0.8 { isCollision = true }
                    balls[i].angle = balls[i+1].angle  // prevent overlap
                    Ball.swap(a: &balls[i].rate, b: &balls[i+1].rate)  // swap speeds per conservation of momuntum
                } else if i > 0 && balls[i].rate < 0.0 && balls[i].angle < balls[i-1].angle {
                    if abs(balls[i].rate - balls[i-1].rate) > 2.0 { isCollision = true }
                    balls[i].angle = balls[i-1].angle
                    Ball.swap(a: &balls[i].rate, b: &balls[i-1].rate)
                }
            }
        }
        // if ball to the right is close in speed and angle, match it exactly
        for i in 0..<balls.count-1 {
            if abs(balls[i].angle - balls[i+1].angle) < 0.1 &&
                abs(balls[i].rate - balls[i+1].rate) < 0.4 {
                balls[i].angle = balls[i+1].angle
                balls[i].rate = balls[i+1].rate
            }
        }
        return isCollision
    }

    static func swipedAt(index: Int, of balls: [Ball], to direction: UISwipeGestureRecognizer.Direction) {
        switch direction {
        case .left:
            balls[index].angle -= 30.rads
            for i in stride(from: index - 1, through: 0, by: -1) {
                if balls[i].angle > balls[i+1].angle { balls[i].angle = balls[i+1].angle }
            }
        case .right:
            balls[index].angle += 30.rads
            for i in index+1..<balls.count {
                if balls[i].angle < balls[i-1].angle { balls[i].angle = balls[i-1].angle }
            }
        default:
            print("Ball.swipedAt) unknown swipe direction")
        }
    }
    
    static func swap(a: inout Double, b: inout Double) {
        let temp = a
        a = b
        b = temp
    }
}
