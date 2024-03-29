//
//  ThreeSliderView.swift
//  DoNothing
//
//  Created by Phil Stern on 6/2/19.
//  Copyright © 2019 Phil Stern. All rights reserved.
//

import UIKit

class ThreeSliderView: SliderView {

    struct Dim3 {
        static let abLength = 70.0
        static let handleLength = 70.0
        static let sliderLength = 55.0
        static let sliderWidth = 14.0
        static let boxRadius = 100.0
    }
    
    override func draw(_ rect: CGRect) {
        includeHandle = delegate?.getHandleState() ?? true

        drawGameBackingFor(numberOfSliders: 3, with: Dim3.boxRadius)
        
        // compute pivot and handle locations
        let pivotA = CGPoint(x: centerX + Dim3.abLength * (cos(60.rads - barAngle) / tan(60.rads) + sin(60.rads - barAngle)),
                             y: centerY)
        let pivotB = CGPoint(x: Double(pivotA.x) - Dim3.abLength * cos(barAngle - 30.rads),
                             y: Double(pivotA.y) - Dim3.abLength * sin(barAngle - 30.rads))
        let pivotC = CGPoint(x: Double(pivotA.x) - Dim3.abLength * sin(60.rads - barAngle),
                             y: Double(pivotA.y) - Dim3.abLength * cos(60.rads - barAngle))
        let pivotH = CGPoint(x: Double(pivotA.x) + Dim3.handleLength * cos(barAngle),
                             y: Double(pivotA.y) + Dim3.handleLength * sin(barAngle))
        
        // draw sliders
        drawSliderOf(length: Dim3.sliderLength, andWidth: Dim3.sliderWidth, at: pivotA, rotatedBy: 0.0)
        drawSliderOf(length: Dim3.sliderLength, andWidth: Dim3.sliderWidth, at: pivotB, rotatedBy: 60.rads)
        drawSliderOf(length: Dim3.sliderLength, andWidth: Dim3.sliderWidth, at: pivotC, rotatedBy: -60.rads)

        // draw six pie wedges
        for i in 0..<6 {
            let angle = 60.rads * (0.5 + Double(i))
            drawPieSectionWith(radius: Dim3.boxRadius, pointAngle: 60.rads, sliderWidth: Dim3.sliderWidth, rotatedBy: angle)
        }
        
        // draw bar (wide for black outline)
        UIColor.black.setStroke()
        let barOutline = UIBezierPath()
        barOutline.move(to: pivotA)
        barOutline.addLine(to: pivotB)
        barOutline.addLine(to: pivotC)
        barOutline.addLine(to: pivotA)
        if includeHandle { barOutline.addLine(to: pivotH) }
        barOutline.lineWidth = CGFloat(Dim0.barWidth)
        barOutline.stroke()

        // draw bar (narrower for brown fill)
        UIColor.brown.setStroke()
        let bar = UIBezierPath()
        bar.move(to: pivotA)
        bar.addLine(to: pivotB)
        bar.addLine(to: pivotC)
        bar.addLine(to: pivotA)
        if includeHandle { bar.addLine(to: pivotH) }
        bar.lineWidth = CGFloat(Dim0.barWidth - 2)
        bar.stroke()
        
        // draw pivots and handle circles
        let circleA = UIBezierPath(arcCenter: pivotA,
                                   radius: CGFloat(Dim0.pivotRadius),
                                   startAngle: 0.0,
                                   endAngle: CGFloat(2.0 * Double.pi),
                                   clockwise: true)
        let circleB = UIBezierPath(arcCenter: pivotB,
                                   radius: CGFloat(Dim0.pivotRadius),
                                   startAngle: 0.0,
                                   endAngle: CGFloat(2.0 * Double.pi),
                                   clockwise: true)
        let circleC = UIBezierPath(arcCenter: pivotC,
                                   radius: CGFloat(Dim0.pivotRadius),
                                   startAngle: 0.0,
                                   endAngle: CGFloat(2.0 * Double.pi),
                                   clockwise: true)
        let circleH = UIBezierPath(arcCenter: pivotH,
                                   radius: CGFloat(Dim0.handleRadius),
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

        if includeHandle {
            UIColor.cyan.setFill()
            circleH.lineWidth = 2
            circleH.stroke()
            circleH.fill()
        }
    }
}
