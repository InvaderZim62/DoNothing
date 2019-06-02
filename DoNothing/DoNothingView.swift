//
//  DoNothingView.swift
//  DoNothing
//
//  Created by Phil Stern on 5/31/19.
//  Copyright © 2019 Phil Stern. All rights reserved.
//

import UIKit

struct Dimensions {
    static let abLength = 60.0
    static let bhLength = 80.0
    static let pivotRadius = 4.0
    static let handleRadius = 6.0
    static let sliderWidth = 14.0
    static let sliderLength = 60.0
    static let boxSize = 160.0
    static let boxCornerRadius = 0.0
    static let sliderCornerRadius = 4.0
    static let barWidth = 10.0
}

class DoNothingView: UIView {

    private var firstTouchAngle = 0.0
    private var barAngle = -1.05 { didSet { setNeedsDisplay() } }  // 0 to right, positive clockwise in radians

    private lazy var viewCenter = convert(center, from: superview)

    // called if bounds change
    override func layoutSubviews() {
        viewCenter = convert(center, from: superview)
        setNeedsDisplay()
    }
    
    // use these next two methods to allow user to rotate bar
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let firstTouch = touch.location(in: self)
            firstTouchAngle = atan2(Double(firstTouch.y - viewCenter.y),
                                    Double(firstTouch.x - viewCenter.x)) - barAngle
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentTouch = touch.location(in: self)
            let currentTouchAngle = atan2(Double(currentTouch.y - viewCenter.y),
                                          Double(currentTouch.x - viewCenter.x))
            barAngle = currentTouchAngle - firstTouchAngle
        }
    }
    
    private func drawSlider(at center: CGPoint, rotatedBy angle: Double) {
        let sizeSlider = CGSize(width: Dimensions.sliderLength, height: Dimensions.sliderWidth)
        let originSlider = CGPoint(x: Double(center.x) - Dimensions.sliderLength / 2.0,  // origin is top left corner
            y: Double(center.y) - Dimensions.sliderWidth / 2.0)
        let slider = UIBezierPath(roundedRect: CGRect(origin: originSlider, size: sizeSlider),
                                  cornerRadius: CGFloat(Dimensions.sliderCornerRadius))
        
        // rotate (move to view origin, rotate about view origin, move back out)
        slider.apply(CGAffineTransform(translationX: center.x, y: center.y).inverted())
        slider.apply(CGAffineTransform(rotationAngle: CGFloat(angle)))
        slider.apply(CGAffineTransform(translationX: center.x, y: center.y))
        
        UIColor.brown.setFill()
        slider.lineWidth = 2
        slider.stroke()
        slider.fill()
    }

    private func drawCornerSquare(at origin: CGPoint) {
        let size = (Dimensions.boxSize - Dimensions.sliderWidth) / 2.0
        let squareSize = CGSize(width: size, height: size)
        
        let square = UIBezierPath(roundedRect: CGRect(origin: origin, size: squareSize),
                                  cornerRadius: CGFloat(Dimensions.boxCornerRadius))
        
        UIColor.black.setStroke()
        UIColor.lightGray.setFill()
        
        square.lineWidth = 2
        square.stroke()
        square.fill()
    }

    override func draw(_ rect: CGRect) {
        // draw box around whole game
        let boxOrigin = CGPoint(x: Double(viewCenter.x) - Dimensions.boxSize / 2.0,
                                y: Double(viewCenter.y) - Dimensions.boxSize / 2.0)
        let boxSize = CGSize(width: Dimensions.boxSize, height: Dimensions.boxSize)
        let box = UIBezierPath(roundedRect: CGRect(origin: boxOrigin, size: boxSize),
                               cornerRadius: CGFloat(Dimensions.boxCornerRadius))
        UIColor.gray.setFill()
        box.fill()

        // compute pivot and handle locations
        let pivotA = CGPoint(x: Double(viewCenter.x),
                             y: Double(viewCenter.y) - Dimensions.abLength * sin(barAngle))
        let pivotB = CGPoint(x: Double(viewCenter.x) + Dimensions.abLength * cos(barAngle),
                             y: Double(viewCenter.y))
        let pivotH = CGPoint(x: Double(pivotB.x) + Dimensions.bhLength * cos(barAngle),
                             y: Double(pivotB.y) + Dimensions.bhLength * sin(barAngle))
        
        // draw sliders
        drawSlider(at: pivotA, rotatedBy: 90.0 * Double.pi / 180.0)
        drawSlider(at: pivotB, rotatedBy: 0.0)
        
        // draw four corner squares
        let origin1 = CGPoint(x: Double(viewCenter.x) - Dimensions.boxSize / 2.0,
                              y: Double(viewCenter.y) - Dimensions.boxSize / 2.0)
        let origin2 = CGPoint(x: Double(viewCenter.x) + Dimensions.sliderWidth / 2.0,
                              y: Double(viewCenter.y) - Dimensions.boxSize / 2.0)
        let origin3 = CGPoint(x: Double(viewCenter.x) - Dimensions.boxSize / 2.0,
                              y: Double(viewCenter.y) + Dimensions.sliderWidth / 2.0)
        let origin4 = CGPoint(x: Double(viewCenter.x) + Dimensions.sliderWidth / 2.0,
                              y: Double(viewCenter.y) + Dimensions.sliderWidth / 2.0)
        
        drawCornerSquare(at: origin1)
        drawCornerSquare(at: origin2)
        drawCornerSquare(at: origin3)
        drawCornerSquare(at: origin4)

        // draw bar
        UIColor.black.setStroke()
        let barOutline = UIBezierPath()
        barOutline.move(to: pivotA)
        barOutline.addLine(to: pivotH)
        barOutline.lineWidth = CGFloat(Dimensions.barWidth)
        barOutline.stroke()

        UIColor.brown.setStroke()
        let bar = UIBezierPath()
        bar.move(to: pivotA)
        bar.addLine(to: pivotH)
        bar.lineWidth = CGFloat(Dimensions.barWidth - 2)
        bar.stroke()

        // draw pivots and handle
        let circleA = UIBezierPath(arcCenter: pivotA,
                                   radius: CGFloat(Dimensions.pivotRadius),
                                   startAngle: 0.0,
                                   endAngle: CGFloat(2.0 * Double.pi),
                                   clockwise: true)
        let circleB = UIBezierPath(arcCenter: pivotB,
                                   radius: CGFloat(Dimensions.pivotRadius),
                                   startAngle: 0.0,
                                   endAngle: CGFloat(2.0 * Double.pi),
                                   clockwise: true)
        let circleH = UIBezierPath(arcCenter: pivotH,
                                   radius: CGFloat(Dimensions.handleRadius),
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
