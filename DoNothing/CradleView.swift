//
//  CradleView.swift
//  DoNothing
//
//  Created by Phil Stern on 6/4/19.
//  Copyright © 2019 Phil Stern. All rights reserved.
//

import UIKit

class CradleView: UIView {
    
    var time = 0.0 { didSet { setNeedsDisplay() } }  // time just used to force drawing update
    var balls = [Ball]()
    var ballViews = [BallView]()

    private var pivots = [CGPoint]()
    private var leftBarEnd = CGPoint()
    private var rightBarEnd = CGPoint()

    // called when first on screen or if bounds change
    override func layoutSubviews() {
        computePivots()
        setNeedsDisplay()
    }

    private func computePivots() {
        pivots.removeAll()
        let leftPivot = Double(self.bounds.width) / 2.0 - Double(balls.count - 1) * Constants.ballRadius
        let barHeight = (Double(self.bounds.height) - Constants.stringLength) / 2.0
        for i in 0..<balls.count {
            let pivot = CGPoint(x: leftPivot + Double(i) * 2.0 * Constants.ballRadius,
                                y: barHeight)
            pivots.append(pivot)
        }
        leftBarEnd = CGPoint(x: leftPivot - Constants.ballRadius, y: barHeight - 2.0)
        rightBarEnd = CGPoint(x: Double(pivots.last!.x) + Constants.ballRadius, y: barHeight - 2.0)
    }

    override func draw(_ rect: CGRect) {
        for i in 0..<balls.count {
            // compute ball position
            let ballCenter = CGPoint(x: pivots[i].x + CGFloat(Constants.stringLength * sin(balls[i].angle)),
                                     y: pivots[i].y + CGFloat(Constants.stringLength * cos(balls[i].angle)))
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
