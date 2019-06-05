//
//  BallView.swift
//  DoNothing
//
//  Created by Phil Stern on 6/4/19.
//  Copyright © 2019 Phil Stern. All rights reserved.
//

import UIKit

class BallView: UIView {

    func setup() {
        self.backgroundColor = nil
        self.isOpaque = false
        self.contentMode = .redraw
    }
    
    required init?(coder aDecoder: NSCoder) {      // init when coming from storyboard
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {                 // init from user (frame is zero, if none given)
        super.init(frame: frame)
        setup()
    }

    override func draw(_ rect: CGRect) {
        let circle = UIBezierPath(roundedRect: bounds, cornerRadius: frame.width / 2.0)
        circle.addClip()
        UIColor.gray.setFill()
        UIRectFill(self.bounds)        // fill whole view, limited to clipping path (roundedRect)

        UIColor.black.setStroke()
        circle.lineWidth = 2
        circle.stroke()
    }
}
