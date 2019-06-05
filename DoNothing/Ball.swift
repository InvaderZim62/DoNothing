//
//  Ball.swift
//  DoNothing
//
//  Created by Phil Stern on 6/4/19.
//  Copyright © 2019 Phil Stern. All rights reserved.
//

import UIKit

class Ball: NSObject {
    
    var angle = 0.0  // radians
    var rate = 0.0   // rad/sec
    var accel = 0.0  // rad/s2
    
    init(angle: Double) {
        self.angle = angle
    }
    
    func simulate() {  // rectangular integration
        accel = -CradleDims.G / CradleDims.length * sin(angle)
        rate += accel * CradleDims.frameTime
        angle += rate * CradleDims.frameTime
    }
    
    static func handleCollisionsBetween(balls: [Ball]) {
        for i in 0..<balls.count {
            if i < balls.count-1 && balls[i].rate > 0.0 && balls[i].angle >= balls[i+1].angle {
                balls[i].angle = balls[i+1].angle
                Ball.swap(a: &balls[i].rate, b: &balls[i+1].rate)
            } else if i > 0 && balls[i].rate < 0.0 && balls[i].angle <= balls[i-1].angle {
                balls[i].angle = balls[i-1].angle
                Ball.swap(a: &balls[i].rate, b: &balls[i-1].rate)
            }
        }
    }
    
    static func swipedAt(index: Int, of balls: [Ball], to direction: UISwipeGestureRecognizer.Direction) {
        switch direction {
        case .left:
            for i in 0...index {
                balls[i].angle = -30.rads
            }
        case .right:
            for i in index..<balls.count {
                balls[i].angle = 30.rads
            }
        default:
            print("Ball.swipedAt) unknown swipe direction")
        }
    }
    
    func stop() {
        angle = 0.0
        rate = 0.0
        accel = 0.0
    }
    
    static func swap(a: inout Double, b: inout Double) {
        let temp = a
        a = b
        b = temp
    }
}
