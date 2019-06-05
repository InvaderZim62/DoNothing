//
//  CradleView.swift
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

class CradleView: UIView {
    
    var time = 0.0 { didSet { setNeedsDisplay() } }  // time just used to force drawing update
    var pivots = [CGPoint]()
    var leftBarEnd = CGPoint()
    var rightBarEnd = CGPoint()
    var balls = [Ball]()
    var ballViews = [BallView]()

    // called if bounds change
    override func layoutSubviews() {
        computePivots()
    }
    
    func setBalls(balls: [Ball]) {
        self.balls = balls
        for _ in 0..<balls.count {
            let ballView = BallView(frame: CGRect(x: 0.0, y: 0.0, width: 2.0 * BallDims.radius, height: 2.0 * BallDims.radius))
            ballViews.append(ballView)
            addSubview(ballView)
       }
    }
    
    private func computePivots() {
        pivots.removeAll()        
        let leftPivot = Double(self.bounds.width) / 2.0 - Double(balls.count - 1) * BallDims.radius
        let barHeight = (Double(self.bounds.height) - BallDims.stringLength) / 2.0
        for i in 0..<balls.count {
            let pivot = CGPoint(x: leftPivot + Double(i) * 2.0 * BallDims.radius,
                                y: barHeight)
            pivots.append(pivot)
        }
        leftBarEnd = CGPoint(x: leftPivot - BallDims.radius, y: barHeight - 2.0)
        rightBarEnd = CGPoint(x: Double(pivots.last!.x) + BallDims.radius, y: barHeight - 2.0)
    }

    override func draw(_ rect: CGRect) {
        for i in 0..<balls.count {
            // compute ball position
            let ballCenter = CGPoint(x: pivots[i].x + CGFloat(BallDims.stringLength * sin(balls[i].angle)),
                                     y: pivots[i].y + CGFloat(BallDims.stringLength * cos(balls[i].angle)))
            ballViews[i].center = ballCenter

            // draw string
            UIColor.black.setStroke()
            let string = UIBezierPath()
            string.move(to: pivots[i])
            string.addLine(to: ballCenter)
            string.lineWidth = CGFloat(2)
            string.stroke()
        }
        // draw top bar
        UIColor.black.setStroke()
        let barOutline = UIBezierPath()
        barOutline.move(to: leftBarEnd)
        barOutline.addLine(to: rightBarEnd)
        barOutline.lineWidth = CGFloat(10)
        barOutline.stroke()

        UIColor.brown.setStroke()
        let bar = UIBezierPath()
        bar.move(to: leftBarEnd)
        bar.addLine(to: rightBarEnd)
        bar.lineWidth = CGFloat(8)
        bar.stroke()
    }
}
