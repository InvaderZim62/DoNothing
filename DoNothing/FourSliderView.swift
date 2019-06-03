//
//  FourSliderView.swift
//  DoNothing
//
//  Created by Phil Stern on 6/2/19.
//  Copyright © 2019 Phil Stern. All rights reserved.
//

import UIKit

class FourSliderView: SliderView {

    struct Dim4 {
        static let abLength = 60.0
        static let handleLength = 70.0
        static let sliderLength = 50.0
        static let sliderWidth = 12.0
        static let boxRadius = 100.0
    }
    
    override func draw(_ rect: CGRect) {
        drawGameBackingFor(numberOfSliders: 4, with: Dim4.boxRadius)
        
        // compute pivot and handle locations
        let pivotA = CGPoint(x: viewCenterX + sqrt(2.0) * Dim4.abLength * cos(barAngle),
                             y: viewCenterY)
        let pivotB = CGPoint(x: Double(pivotA.x) - Dim4.abLength * cos(barAngle - 45.rads),
                             y: Double(pivotA.y) - Dim4.abLength * sin(barAngle - 45.rads))
        let pivotC = CGPoint(x: Double(pivotA.x) - sqrt(2.0) * Dim4.abLength * cos(barAngle),
                             y: Double(pivotA.y) - sqrt(2.0) * Dim4.abLength * sin(barAngle))
        let pivotD = CGPoint(x: Double(pivotA.x) + Dim4.abLength * cos(135.rads - barAngle),
                             y: Double(pivotA.y) - Dim4.abLength * sin(135.rads - barAngle))
        let pivotH = CGPoint(x: Double(pivotA.x) + Dim4.handleLength * cos(barAngle),
                             y: Double(pivotA.y) + Dim4.handleLength * sin(barAngle))
        
        // draw sliders
        drawSliderOf(length: Dim4.sliderLength, andWidth: Dim4.sliderWidth, at: pivotA, rotatedBy: 0.0)
        drawSliderOf(length: Dim4.sliderLength, andWidth: Dim4.sliderWidth, at: pivotB, rotatedBy: 45.rads)
        drawSliderOf(length: Dim4.sliderLength, andWidth: Dim4.sliderWidth, at: pivotC, rotatedBy: 90.rads)
        drawSliderOf(length: Dim4.sliderLength, andWidth: Dim4.sliderWidth, at: pivotD, rotatedBy: -45.rads)

        // draw eight pie wedges
        for i in 0..<8 {
            let angle = 45.rads * (0.5 + Double(i))
            drawPieSectionWith(radius: Dim4.boxRadius, pointAngle: 45.rads, sliderWidth: Dim4.sliderWidth, rotatedBy: angle)
        }
        
        // draw bar (wide for black outline)
        UIColor.black.setStroke()
        let barOutline = UIBezierPath()
        barOutline.move(to: pivotA)
        barOutline.addLine(to: pivotB)
        barOutline.addLine(to: pivotC)
        barOutline.addLine(to: pivotD)
        barOutline.addLine(to: pivotA)
        barOutline.addLine(to: pivotH)
        barOutline.lineWidth = CGFloat(Dim0.barWidth)
        barOutline.stroke()
        
        // draw bar (narrower for brown fill)
        UIColor.brown.setStroke()
        let bar = UIBezierPath()
        bar.move(to: pivotA)
        bar.addLine(to: pivotB)
        bar.addLine(to: pivotC)
        bar.addLine(to: pivotD)
        bar.addLine(to: pivotA)
        bar.addLine(to: pivotH)
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
        let circleD = UIBezierPath(arcCenter: pivotD,
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
        circleD.lineWidth = 2
        circleD.stroke()
        circleD.fill()

        UIColor.cyan.setFill()
        circleH.lineWidth = 2
        circleH.stroke()
        circleH.fill()
    }
}
