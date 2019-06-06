//
//  Ball.swift
//  DoNothing
//
//  Created by Phil Stern on 6/4/19.
//  Copyright © 2019 Phil Stern. All rights reserved.
//

import UIKit

struct BallConsts {
    static let collisionThreshold = 0.8  // rad/sec, a click sound occurs for collisions above this threshold
    static let stickyAngle = 0.1         // rad, below this relative angle and rate, the balls will stick together
    static let stickyRate = 0.1          // rad/sec
    static let maxAngle = 30.rads        // rad, max angle during setup and simulation
}

class Ball: NSObject {
    
    var accel = 0.0    // rad/s2
    var rate = 0.0     // rad/sec
    var angle = 0.0 {  // radians
        didSet {
            angle = max(min(angle, BallConsts.maxAngle), -BallConsts.maxAngle)  // limit angle
        }
    }

    private var isStopping = false
    private var isHolding = false
    
    func simulate() {
        if isStopping {
            // bring to reat
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
            // inegrate accel to get rate and angle (rectangular rule integration)
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
        accel = 0.0
        rate = 0.0
        angle = 0.0
    }

    static func isCollisionBetween(_ balls: [Ball]) -> Bool {
        var isCollision = false
        for _ in 0..<balls.count - 1 {  // make n-1 passes, to propagate changes down the line
            for i in 0..<balls.count {
                if i < balls.count - 1 && balls[i].rate > 0.0 && balls[i].angle > balls[i + 1].angle {
                    // if moving right and overlapping next ball, contact occurred
                    if abs(balls[i].rate - balls[i + 1].rate) > BallConsts.collisionThreshold { isCollision = true }
                    balls[i].angle = balls[i+1].angle  // prevent overlap
                    Ball.swap(&balls[i].rate, &balls[i+1].rate)  // swap speeds per conservation of momuntum
                } else if i > 0 && balls[i].rate < 0.0 && balls[i].angle < balls[i - 1].angle {
                    // if moving left and overlapping previous ball, contact occurred
                    if abs(balls[i].rate - balls[i - 1].rate) > BallConsts.collisionThreshold { isCollision = true }
                    balls[i].angle = balls[i - 1].angle
                    Ball.swap(&balls[i].rate, &balls[i - 1].rate)
                }
            }
        }
        // if ball to the right is close in speed and angle, match it exactly
        for i in 0..<balls.count-1 {
            if abs(balls[i].angle - balls[i + 1].angle) < BallConsts.stickyAngle &&
                abs(balls[i].rate - balls[i + 1].rate) < BallConsts.stickyRate {
                balls[i].rate = balls[i + 1].rate
                balls[i].angle = balls[i + 1].angle
            }
        }
        return isCollision
    }

    // increment swiped balls maxAngle in the direction of swipe, including any in their way
    static func swipedAt(index: Int, of balls: [Ball], to direction: UISwipeGestureRecognizer.Direction) {
        switch direction {
        case .left:
            balls[index].angle -= BallConsts.maxAngle
            for i in stride(from: index - 1, through: 0, by: -1) {
                if balls[i].angle > balls[i + 1].angle { balls[i].angle = balls[i + 1].angle }
            }
        case .right:
            balls[index].angle += BallConsts.maxAngle
            for i in index+1..<balls.count {
                if balls[i].angle < balls[i - 1].angle { balls[i].angle = balls[i - 1].angle }
            }
        default:
            print("Ball.swipedAt) unknown swipe direction")
        }
    }
    
    static func swap(_ a: inout Double, _ b: inout Double) {
        let temp = a
        a = b
        b = temp
    }
}
