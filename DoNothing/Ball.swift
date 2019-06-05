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
    
    func simulate() {
        accel = -CradleDims.G / CradleDims.length * sin(angle)
        rate += accel * CradleDims.frameTime  // rectangular integration
        angle += rate * CradleDims.frameTime
    }
    
    static func handleCollisionsBetween(balls: [Ball]) {
        for i in 0..<balls.count {
            if i < balls.count-1 && balls[i].rate > 0.0 && balls[i].angle >= balls[i+1].angle {
                balls[i].angle = balls[i+1].angle
                let rate = balls[i].rate
                balls[i].rate = balls[i+1].rate
                balls[i+1].rate = rate
            } else if i > 0 && balls[i].rate < 0.0 && balls[i].angle <= balls[i-1].angle {
                balls[i].angle = balls[i-1].angle
                let rate = balls[i].rate
                balls[i].rate = balls[i-1].rate
                balls[i-1].rate = rate
            }
        }
    }
}
