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
        static let boxRadius = 100.0
    }

    private func drawPieSection(rotatedBy angle: Double) {
        let pieLength = Dim3.boxRadius - Dim0.sliderWidth / (2.0 * sin(thirty) * cos(thirty))
        
        let pie = UIBezierPath()
        pie.move(to: CGPoint(x: viewCenterX, y: viewCenterY))
        pie.addLine(to: CGPoint(x: viewCenterX + pieLength * cos(thirty), y: viewCenterY + pieLength * sin(thirty)))
        pie.addLine(to: CGPoint(x: viewCenterX + pieLength * cos(thirty), y: viewCenterY + pieLength * sin(-thirty)))
        pie.addLine(to: CGPoint(x: viewCenterX, y: viewCenterY))

        pie.apply(CGAffineTransform(translationX: CGFloat(viewCenterX), y: CGFloat(viewCenterY)).inverted())
        pie.apply(CGAffineTransform(rotationAngle: CGFloat(angle)))
        pie.apply(CGAffineTransform(translationX: CGFloat(viewCenterX + 0.5 * Dim0.sliderWidth / sin(thirty) * cos(angle)),
                                               y: CGFloat(viewCenterY + 0.5 * Dim0.sliderWidth / sin(thirty) * sin(angle))))
        UIColor.black.setStroke()
        UIColor.lightGray.setFill()
        
        pie.lineWidth = 2
        pie.stroke()
        pie.fill()
    }
    
    override func draw(_ rect: CGRect) {
        drawGameBackingFor(numberOfSliders: 3, with: Dim3.boxRadius)
        
        // compute pivot and handle locations
        let pivotA = CGPoint(x: viewCenterX + Dim3.abLength * (cos(sixty - barAngle) / tan(sixty) + sin(sixty - barAngle)),
                             y: viewCenterY)
        let pivotB = CGPoint(x: Double(pivotA.x) - Dim3.abLength * cos(barAngle - thirty),
                             y: Double(pivotA.y) - Dim3.abLength * sin(barAngle - thirty))
        let pivotC = CGPoint(x: Double(pivotA.x) - Dim3.abLength * sin(sixty - barAngle),
                             y: Double(pivotA.y) - Dim3.abLength * cos(sixty - barAngle))
        let pivotH = CGPoint(x: Double(pivotA.x) + Dim3.handleLength * cos(barAngle),
                             y: Double(pivotA.y) + Dim3.handleLength * sin(barAngle))
        
        // draw sliders
        drawSlider(of: Dim3.sliderLength, at: pivotA, rotatedBy: 0.0)
        drawSlider(of: Dim3.sliderLength, at: pivotB, rotatedBy: sixty)
        drawSlider(of: Dim3.sliderLength, at: pivotC, rotatedBy: -sixty)
        
        // draw six pie wedges
        for i in 0..<6 {
            let angle = sixty * (0.5 + Double(i))
            drawPieSection(rotatedBy: angle)
        }
        
        // draw bar
        UIColor.black.setStroke()
        let barOutline = UIBezierPath()
        barOutline.move(to: pivotA)
        barOutline.addLine(to: pivotB)
        barOutline.addLine(to: pivotC)
        barOutline.addLine(to: pivotA)
        barOutline.addLine(to: pivotH)
        barOutline.lineWidth = CGFloat(Dim0.barWidth)
        barOutline.stroke()

        UIColor.brown.setStroke()
        let bar = UIBezierPath()
        bar.move(to: pivotA)
        bar.addLine(to: pivotB)
        bar.addLine(to: pivotC)
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

        UIColor.cyan.setFill()
        circleH.lineWidth = 2
        circleH.stroke()
        circleH.fill()
    }
}
