//
//  BallsView.swift
//  DoNothing
//
//  Created by Phil Stern on 6/4/19.
//  Copyright © 2019 Phil Stern. All rights reserved.
//

import UIKit

struct BallDims {
    static let radius = 20.0
    static let stringLength = 200.0
}

class BallsView: UIView {
    
    var time = 0.0 { didSet { setNeedsDisplay() } }  // time just used to force drawing update
    var pivots = [CGPoint]()
    var balls = [Ball]()

    // called if bounds change
    override func layoutSubviews() {
        computePivots()
    }
    
    private func computePivots() {
        pivots.removeAll()
        let leftPivot = Double(self.bounds.width) / 2.0 - Double(balls.count - 1) * BallDims.radius
        for i in 0..<balls.count {
            let pivot = CGPoint(x: leftPivot + Double(i) * 2.0 * BallDims.radius,
                                y: (Double(self.bounds.height) - BallDims.stringLength) / 2.0)
            pivots.append(pivot)
        }
    }

    override func draw(_ rect: CGRect) {
        for i in 0..<balls.count {
            let ballCenter = CGPoint(x: pivots[i].x + CGFloat(BallDims.stringLength * sin(balls[i].angle)),
                                     y: pivots[i].y + CGFloat(BallDims.stringLength * cos(balls[i].angle)))

            UIColor.black.setStroke()
            let string = UIBezierPath()
            string.move(to: pivots[i])
            string.addLine(to: ballCenter)
            string.lineWidth = CGFloat(2)
            string.stroke()

            let ball = UIBezierPath(arcCenter: ballCenter,
                                       radius: CGFloat(BallDims.radius - 1),  // allow for line width
                                       startAngle: 0.0,
                                       endAngle: CGFloat(2.0 * Double.pi),
                                       clockwise: true)
            UIColor.black.setStroke()
            UIColor.yellow.setFill()
            
            ball.lineWidth = 2
            ball.stroke()
            ball.fill()
        }
    }
}
