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
        static let boxRadius = 100.0
    }
    
    private func drawPieSection(rotatedBy angle: Double) {
        let pieLength = Dim4.boxRadius - Dim0.sliderWidth / (2.0 * sin(half45) * cos(half45))

        let pie = UIBezierPath()
        pie.move(to: CGPoint(x: viewCenterX, y: viewCenterY))
        pie.addLine(to: CGPoint(x: viewCenterX + pieLength * cos(half45), y: viewCenterY + pieLength * sin(half45)))
        pie.addLine(to: CGPoint(x: viewCenterX + pieLength * cos(half45), y: viewCenterY + pieLength * sin(-half45)))
        pie.addLine(to: CGPoint(x: viewCenterX, y: viewCenterY))
        
        pie.apply(CGAffineTransform(translationX: CGFloat(viewCenterX), y: CGFloat(viewCenterY)).inverted())
        pie.apply(CGAffineTransform(rotationAngle: CGFloat(angle)))
        pie.apply(CGAffineTransform(translationX: CGFloat(viewCenterX + 0.5 * Dim0.sliderWidth / sin(half45) * cos(angle)),
                                               y: CGFloat(viewCenterY + 0.5 * Dim0.sliderWidth / sin(half45) * sin(angle))))
        UIColor.black.setStroke()
        UIColor.lightGray.setFill()
        
        pie.lineWidth = 2
        pie.stroke()
        pie.fill()
    }
    
    override func draw(_ rect: CGRect) {
        drawGameBackingFor(numberOfSliders: 4, with: Dim4.boxRadius)
        
        // compute pivot and handle locations
        let pivotA = CGPoint(x: viewCenterX + sqrt(2.0) * Dim4.abLength * cos(barAngle),
                             y: viewCenterY)
        let pivotB = CGPoint(x: Double(pivotA.x) - Dim4.abLength * cos(barAngle - fortyFive),
                             y: Double(pivotA.y) - Dim4.abLength * sin(barAngle - fortyFive))
        let pivotC = CGPoint(x: Double(pivotA.x) - sqrt(2.0) * Dim4.abLength * cos(barAngle),
                             y: Double(pivotA.y) - sqrt(2.0) * Dim4.abLength * sin(barAngle))
        let pivotD = CGPoint(x: Double(pivotA.x) + Dim4.abLength * cos(oneThirtyFive - barAngle),
                             y: Double(pivotA.y) - Dim4.abLength * sin(oneThirtyFive - barAngle))
        let pivotH = CGPoint(x: Double(pivotA.x) + Dim4.handleLength * cos(barAngle),
                             y: Double(pivotA.y) + Dim4.handleLength * sin(barAngle))
        
        // draw sliders
        drawSlider(of: Dim4.sliderLength, at: pivotA, rotatedBy: 0.0)
        drawSlider(of: Dim4.sliderLength, at: pivotB, rotatedBy: fortyFive)
        drawSlider(of: Dim4.sliderLength, at: pivotC, rotatedBy: ninty)
        drawSlider(of: Dim4.sliderLength, at: pivotD, rotatedBy: -fortyFive)

        // draw eight pie wedges
        for i in 0..<8 {
            let angle = fortyFive * (0.5 + Double(i))
            drawPieSection(rotatedBy: angle)
        }
        
        // draw bar
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
        
        // draw pivots and handle
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
