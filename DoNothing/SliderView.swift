//
//  SliderView.swift
//  DoNothing
//
//  Created by Phil Stern on 5/31/19.
//  Copyright © 2019 Phil Stern. All rights reserved.
//

import UIKit

class SliderView: UIView {

    let thirty = 30.0 * Double.pi / 180.0  // radians
    let sixty = 60.0 * Double.pi / 180.0
    let ninty = 90.0 * Double.pi / 180.0

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
}
