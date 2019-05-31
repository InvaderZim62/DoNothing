//
//  DoNothingView.swift
//  DoNothing
//
//  Created by Phil Stern on 5/31/19.
//  Copyright © 2019 Phil Stern. All rights reserved.
//

import UIKit

struct Dimension {
    static let abLength = 60.0
    static let bhLength = 80.0
    static let pivotRadius = 4.0
    static let sliderWidth = 14.0
    static let sliderLength = 60.0
    static let boxSize = 160.0
    static let boxCornerRadius = 0.0
}

class DoNothingView: UIView {

    private var firstTouchAngle = 0.0
    private var rotate = 0.0 { didSet { setNeedsDisplay() } }  // rotation angle in radians

    private lazy var viewCenter = convert(center, from: superview)

    override func layoutSubviews() {  // called if bounds change
        viewCenter = convert(center, from: superview)
        setNeedsDisplay()
    }
    
    // use these next two methods to allow user to rotate wheel view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let firstTouch = touch.location(in: self)
            firstTouchAngle = atan2(Double(firstTouch.y - viewCenter.y),  // 0 to right, pos CW
                                    Double(firstTouch.x - viewCenter.x)) - rotate
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentTouch = touch.location(in: self)
            let currentTouchAngle = atan2(Double(currentTouch.y - viewCenter.y),
                                          Double(currentTouch.x - viewCenter.x))
            rotate = currentTouchAngle - firstTouchAngle
        }
    }

    override func draw(_ rect: CGRect) {
        // draw box around whole game
        let boxOrigin = CGPoint(x: Double(viewCenter.x) - Dimension.boxSize / 2.0,
                                y: Double(viewCenter.y) - Dimension.boxSize / 2.0)
        let boxSize = CGSize(width: Dimension.boxSize, height: Dimension.boxSize)
        let box = UIBezierPath(roundedRect: CGRect(origin: boxOrigin, size: boxSize),
                               cornerRadius: CGFloat(Dimension.boxCornerRadius))
        UIColor.gray.setFill()
        box.fill()

        // compute pivot and handle locations
        let pivotA = CGPoint(x: Double(viewCenter.x),
                             y: Double(viewCenter.y) - Dimension.abLength * sin(rotate))
        let pivotB = CGPoint(x: Double(viewCenter.x) + Dimension.abLength * cos(rotate),
                             y: Double(viewCenter.y))
        let pivotH = CGPoint(x: Double(pivotB.x) + Dimension.bhLength * cos(rotate),
                             y: Double(pivotB.y) + Dimension.bhLength * sin(rotate))
        
        // draw sliders at pivots
        let originSliderA = CGPoint(x: Double(pivotA.x) - Dimension.sliderWidth / 2.0,
                                    y: Double(pivotA.y) - Dimension.sliderLength / 2.0)
        let sizeSliderA = CGSize(width: Dimension.sliderWidth, height: Dimension.sliderLength)
        let sliderA = UIBezierPath(roundedRect: CGRect(origin: originSliderA, size: sizeSliderA), cornerRadius: 4.0)
        
        let originSliderB = CGPoint(x: Double(pivotB.x) - Dimension.sliderLength / 2.0,
                                    y: Double(pivotB.y) - Dimension.sliderWidth / 2.0)
        let sizeSliderB = CGSize(width: Dimension.sliderLength, height: Dimension.sliderWidth)
        let sliderB = UIBezierPath(roundedRect: CGRect(origin: originSliderB, size: sizeSliderB), cornerRadius: 4.0)
        
        UIColor.brown.setFill()
        sliderA.lineWidth = 2
        sliderA.stroke()
        sliderA.fill()
        sliderB.lineWidth = 2
        sliderB.stroke()
        sliderB.fill()
        
        // draw four corner squares
        UIColor.lightGray.setFill()
        let size = (Dimension.boxSize - Dimension.sliderWidth) / 2.0
        let squareSize = CGSize(width: size, height: size)
        
        let origin1 = CGPoint(x: Double(viewCenter.x) - Dimension.boxSize / 2.0,
                              y: Double(viewCenter.y) - Dimension.boxSize / 2.0)
        let square1 = UIBezierPath(roundedRect: CGRect(origin: origin1, size: squareSize),
                                   cornerRadius: CGFloat(Dimension.boxCornerRadius))
        square1.lineWidth = 2
        square1.stroke()
        square1.fill()
        
        let origin2 = CGPoint(x: Double(viewCenter.x) + Dimension.sliderWidth / 2.0,
                              y: Double(viewCenter.y) - Dimension.boxSize / 2.0)
        let square2 = UIBezierPath(roundedRect: CGRect(origin: origin2, size: squareSize),
                                   cornerRadius: CGFloat(Dimension.boxCornerRadius))
        square2.lineWidth = 2
        square2.stroke()
        square2.fill()
        
        let origin3 = CGPoint(x: Double(viewCenter.x) - Dimension.boxSize / 2.0,
                              y: Double(viewCenter.y) + Dimension.sliderWidth / 2.0)
        let square3 = UIBezierPath(roundedRect: CGRect(origin: origin3, size: squareSize),
                                   cornerRadius: CGFloat(Dimension.boxCornerRadius))
        square3.lineWidth = 2
        square3.stroke()
        square3.fill()
        
        let origin4 = CGPoint(x: Double(viewCenter.x) + Dimension.sliderWidth / 2.0,
                              y: Double(viewCenter.y) + Dimension.sliderWidth / 2.0)
        let square4 = UIBezierPath(roundedRect: CGRect(origin: origin4, size: squareSize),
                                   cornerRadius: CGFloat(Dimension.boxCornerRadius))
        square4.lineWidth = 2
        square4.stroke()
        square4.fill()

        // draw bar
        UIColor.black.setStroke()
        let barOutline = UIBezierPath()
        barOutline.move(to: pivotA)
        barOutline.addLine(to: pivotH)
        barOutline.lineWidth = 8
        barOutline.stroke()

        UIColor.brown.setStroke()
        let bar = UIBezierPath()
        bar.move(to: pivotA)
        bar.addLine(to: pivotH)
        bar.lineWidth = 6
        bar.stroke()

        // draw pivots and handle
        let circleA = UIBezierPath(arcCenter: pivotA,
                                   radius: CGFloat(Dimension.pivotRadius),
                                   startAngle: 0.0,
                                   endAngle: CGFloat(2.0 * Double.pi),
                                   clockwise: true)
        let circleB = UIBezierPath(arcCenter: pivotB,
                                   radius: CGFloat(Dimension.pivotRadius),
                                   startAngle: 0.0,
                                   endAngle: CGFloat(2.0 * Double.pi),
                                   clockwise: true)
        let circleH = UIBezierPath(arcCenter: pivotH,
                                   radius: CGFloat(Dimension.pivotRadius),
                                   startAngle: 0.0,
                                   endAngle: CGFloat(2.0 * Double.pi),
                                   clockwise: true)
        UIColor.black.setStroke()
        UIColor.yellow.setFill()
        
        circleA.lineWidth = 2
        circleA.stroke()
        circleA.fill()
        circleB.lineWidth = 2
        circleB.stroke()
        circleB.fill()
        
        UIColor.cyan.setFill()
        circleH.lineWidth = 2
        circleH.stroke()
        circleH.fill()
    }
}
