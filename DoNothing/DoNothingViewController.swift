//
//  DoNothingViewController.swift
//  DoNothing
//
//  Created by Phil Stern on 5/31/19.
//  Copyright © 2019 Phil Stern. All rights reserved.
//

import UIKit

class DoNothingViewController: UIViewController {

    static var includeHandle = true  // static, so it's shared between tab views

    @IBOutlet weak var sliderView: SliderView!
    @IBOutlet weak var handleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sliderView.delegate = self
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!], for: .normal)
    }
    
    // called each time a new tab view is loaded
    override func viewWillAppear(_ animated: Bool) {
        updateButtonTitle()
    }

    @IBAction func pressedButton(_ sender: UIButton) {
        DoNothingViewController.includeHandle = !DoNothingViewController.includeHandle
        updateButtonTitle()
    }
    
    private func updateButtonTitle() {
        handleButton.setTitle(DoNothingViewController.includeHandle ? "Hide Handle" : "Show Handle", for: .normal)
    }
}

extension DoNothingViewController: SliderViewDelegate {
    func getHandleState() -> Bool {
        return DoNothingViewController.includeHandle
    }
}

extension Double {
    var rads: Double {
        return self * Double.pi / 180.0
    }
    
    var degs: Double {
        return self * 180.0 / Double.pi
    }
}
