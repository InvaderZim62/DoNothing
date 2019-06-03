//
//  SliderView.swift
//  DoNothing
//
//  Created by Phil Stern on 5/31/19.
//  Copyright © 2019 Phil Stern. All rights reserved.
//

import UIKit

protocol SliderViewDelegate: class {
    func getHandleState() -> Bool  // get handle state (hide/show) from DoNothingViewController
}

struct Dim0 {
    static let pivotRadius = 4.0
    static let handleRadius = 6.0
    static let sliderCornerRadius = 4.0
    static let barWidth = 10.0
}

class SliderView: UIView {
    
    weak var delegate: SliderViewDelegate?
    
    var includeHandle = true
    
    var firstTouchAngle = 0.0
    var barAngle = -1.05 { didSet { setNeedsDisplay() } }  // 0 to right, positive clockwise in radians

    lazy var viewCenter = convert(center, from: superview)
    lazy var viewCenterX = Double(viewCenter.x)
    lazy var viewCenterY = Double(viewCenter.y)
    
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
                                    Double(firstTouch.x - viewCenter.x))
            firstTouchAngle += includeHandle ? -barAngle : barAngle
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentTouch = touch.location(in: self)
            let currentTouchAngle = atan2(Double(currentTouch.y - viewCenter.y),
                                          Double(currentTouch.x - viewCenter.x))
            barAngle = currentTouchAngle - firstTouchAngle
            barAngle *= includeHandle ? 1.0 : -1.0
        }
    }
    
    func drawGameBackingFor(numberOfSliders: Int, with radius: Double) {
        let box = UIBezierPath()
        box.move(to: CGPoint(x: viewCenterX + radius, y: viewCenterY))
        for i in 1..<2*numberOfSliders {
            let angle = Double(i) * 180.rads / Double(numberOfSliders)
            box.addLine(to: CGPoint(x: viewCenterX + radius * cos(angle),
                                    y: viewCenterY - radius * sin(angle)))
        }
        UIColor.gray.setFill()
        box.fill()
    }

    func drawSliderOf(length: Double, andWidth width: Double, at center: CGPoint, rotatedBy angle: Double) {
        let sizeSlider = CGSize(width: length, height: width)
        let originSlider = CGPoint(x: Double(center.x) - length / 2.0,  // origin is top left corner
                                   y: Double(center.y) - width / 2.0)
        let slider = UIBezierPath(roundedRect: CGRect(origin: originSlider, size: sizeSlider),
                                  cornerRadius: CGFloat(Dim0.sliderCornerRadius))
        
        // rotate (move to view origin, rotate about view origin, move back out)
        slider.apply(CGAffineTransform(translationX: center.x, y: center.y).inverted())
        slider.apply(CGAffineTransform(rotationAngle: CGFloat(angle)))
        slider.apply(CGAffineTransform(translationX: center.x, y: center.y))
        
        UIColor.brown.setFill()
        slider.lineWidth = 2
        slider.stroke()
        slider.fill()
    }

    func drawPieSectionWith(radius: Double, pointAngle: Double, sliderWidth: Double, rotatedBy angle: Double) {
        let halfPt = pointAngle / 2.0
        let pieLength = radius - sliderWidth / (2.0 * sin(halfPt) * cos(halfPt))
        
        let pie = UIBezierPath()
        pie.move(to: CGPoint(x: viewCenterX, y: viewCenterY))
        pie.addLine(to: CGPoint(x: viewCenterX + pieLength * cos(halfPt), y: viewCenterY + pieLength * sin(halfPt)))
        pie.addLine(to: CGPoint(x: viewCenterX + pieLength * cos(halfPt), y: viewCenterY + pieLength * sin(-halfPt)))
        pie.addLine(to: CGPoint(x: viewCenterX, y: viewCenterY))
        
        pie.apply(CGAffineTransform(translationX: CGFloat(viewCenterX), y: CGFloat(viewCenterY)).inverted())
        pie.apply(CGAffineTransform(rotationAngle: CGFloat(angle)))
        pie.apply(CGAffineTransform(translationX: CGFloat(viewCenterX + 0.5 * sliderWidth / sin(halfPt) * cos(angle)),
                                               y: CGFloat(viewCenterY + 0.5 * sliderWidth / sin(halfPt) * sin(angle))))
        UIColor.black.setStroke()
        UIColor.lightGray.setFill()
        
        pie.lineWidth = 2
        pie.stroke()
        pie.fill()
    }
}

extension Double {
    var rads: Double {
        return self * Double.pi / 180.0
    }
}
