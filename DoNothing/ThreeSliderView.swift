//
//  ThreeSliderView.swift
//  DoNothing
//
//  Created by Phil Stern on 6/2/19.
//  Copyright © 2019 Phil Stern. All rights reserved.
//

import UIKit

struct Dim3 {
    static let abLength = 70.0
    static let pivotRadius = 4.0
    static let handleRadius = 6.0
    static let sliderWidth = 14.0
    static let sliderLength = 55.0
    static let sliderCornerRadius = 4.0
    static let boxRadius = 100.0
    static let barWidth = 10.0
}

class ThreeSliderView: UIView {
    
    private let thirty = 30.0 * Double.pi / 180.0  // radians
    private let sixty = 60.0 * Double.pi / 180.0

    private var firstTouchAngle = 0.0
    private var barAngle = -1.05 { didSet { setNeedsDisplay() } }  // 0 to right, positive clockwise in radians

    private lazy var viewCenter = convert(center, from: superview)
    private lazy var viewCenterX = Double(viewCenter.x)
    private lazy var viewCenterY = Double(viewCenter.y)

    // called if bounds change
    override func layoutSubviews() {
        viewCenter = convert(center, from: superview)
        viewCenterX = Double(viewCenter.x)
        viewCenterY = Double(viewCenter.y)
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
        let sizeSlider = CGSize(width: Dim3.sliderLength, height: Dim3.sliderWidth)
        let originSlider = CGPoint(x: Double(center.x) - Dim3.sliderLength / 2.0,  // origin is top left corner
            y: Double(center.y) - Dim3.sliderWidth / 2.0)
        let slider = UIBezierPath(roundedRect: CGRect(origin: originSlider, size: sizeSlider),
                                  cornerRadius: CGFloat(Dim3.sliderCornerRadius))

        // rotate (move to view origin, rotate about view origin, move back out)
        slider.apply(CGAffineTransform(translationX: center.x, y: center.y).inverted())
        slider.apply(CGAffineTransform(rotationAngle: CGFloat(angle)))
        slider.apply(CGAffineTransform(translationX: center.x, y: center.y))

        UIColor.brown.setFill()
        slider.lineWidth = 2
        slider.stroke()
        slider.fill()
    }
    
    private func drawPieSection(rotatedBy angle: Double) {
        let pieLength = Dim3.boxRadius - 1.155 * Dim3.sliderWidth  // = 1 / (2 * sin(thirty) * cos(thirty))
        
        let pie = UIBezierPath()
        pie.move(to: CGPoint(x: viewCenterX, y: viewCenterY))
        pie.addLine(to: CGPoint(x: viewCenterX + pieLength * cos(thirty), y: viewCenterY + pieLength * sin(thirty)))
        pie.addLine(to: CGPoint(x: viewCenterX + pieLength * cos(thirty), y: viewCenterY + pieLength * sin(-thirty)))
        pie.addLine(to: CGPoint(x: viewCenterX, y: viewCenterY))

        pie.apply(CGAffineTransform(translationX: CGFloat(viewCenterX), y: CGFloat(viewCenterY)).inverted())
        pie.apply(CGAffineTransform(rotationAngle: CGFloat(angle)))
        pie.apply(CGAffineTransform(translationX: CGFloat(viewCenterX + Dim3.sliderWidth * cos(angle)),
                                               y: CGFloat(viewCenterY + Dim3.sliderWidth * sin(angle))))
        UIColor.black.setStroke()
        UIColor.lightGray.setFill()
        
        pie.lineWidth = 2
        pie.stroke()
        pie.fill()
    }
    
    override func draw(_ rect: CGRect) {
        // draw box around whole game
        let box = UIBezierPath()
        box.move(to: CGPoint(x: viewCenterX + Dim3.boxRadius, y: viewCenterY))
        for i in 1...5 {
            let angle = Double(i) * sixty
            box.addLine(to: CGPoint(x: viewCenterX + Dim3.boxRadius * cos(angle),
                                    y: viewCenterY - Dim3.boxRadius * sin(angle)))
        }
        UIColor.gray.setFill()
        box.fill()
        
        // compute pivot and handle locations
        let pivotC = CGPoint(x: viewCenterX + Dim3.abLength * (cos(sixty - barAngle) / tan(sixty) + sin(sixty - barAngle)),
                             y: viewCenterY)
        let pivotA = CGPoint(x: Double(pivotC.x) - Dim3.abLength * cos(barAngle - thirty),
                             y: Double(pivotC.y) - Dim3.abLength * sin(barAngle - thirty))
        let pivotB = CGPoint(x: Double(pivotC.x) - Dim3.abLength * sin(sixty - barAngle),
                             y: Double(pivotC.y) - Dim3.abLength * cos(sixty - barAngle))
        let pivotH = CGPoint(x: Double(pivotC.x) + Dim3.abLength * cos(barAngle),
                             y: Double(pivotC.y) + Dim3.abLength * sin(barAngle))
        
        // draw sliders
        drawSlider(at: pivotA, rotatedBy: sixty)
        drawSlider(at: pivotB, rotatedBy: -sixty)
        drawSlider(at: pivotC, rotatedBy: 0.0)
        
        // draw five pie wedges
        for i in 0...5 {
            let angle = thirty + Double(i) * sixty
            drawPieSection(rotatedBy: angle)
        }
        
        // draw bar
        UIColor.black.setStroke()
        let barOutline = UIBezierPath()
        barOutline.move(to: pivotC)
        barOutline.addLine(to: pivotA)
        barOutline.addLine(to: pivotB)
        barOutline.addLine(to: pivotC)
        barOutline.addLine(to: pivotH)
        barOutline.lineWidth = CGFloat(Dim3.barWidth)
        barOutline.stroke()

        UIColor.brown.setStroke()
        let bar = UIBezierPath()
        bar.move(to: pivotC)
        bar.addLine(to: pivotA)
        bar.addLine(to: pivotB)
        bar.addLine(to: pivotC)
        bar.addLine(to: pivotH)
        bar.lineWidth = CGFloat(Dim3.barWidth - 2)
        bar.stroke()
        
        // draw pivots and handle
        let circleA = UIBezierPath(arcCenter: pivotA,
                                   radius: CGFloat(Dim3.pivotRadius),
                                   startAngle: 0.0,
                                   endAngle: CGFloat(2.0 * Double.pi),
                                   clockwise: true)
        let circleB = UIBezierPath(arcCenter: pivotB,
                                   radius: CGFloat(Dim3.pivotRadius),
                                   startAngle: 0.0,
                                   endAngle: CGFloat(2.0 * Double.pi),
                                   clockwise: true)
        let circleC = UIBezierPath(arcCenter: pivotC,
                                   radius: CGFloat(Dim3.pivotRadius),
                                   startAngle: 0.0,
                                   endAngle: CGFloat(2.0 * Double.pi),
                                   clockwise: true)
        let circleH = UIBezierPath(arcCenter: pivotH,
                                   radius: CGFloat(Dim3.handleRadius),
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
        circleC.lineWidth = 2
        circleC.stroke()
        circleC.fill()

        UIColor.cyan.setFill()
        circleH.lineWidth = 2
        circleH.stroke()
        circleH.fill()
    }
}
