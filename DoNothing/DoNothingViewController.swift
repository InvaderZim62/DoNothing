//
//  DoNothingViewController.swift
//  DoNothing
//
//  Created by Phil Stern on 5/31/19.
//  Copyright © 2019 Phil Stern. All rights reserved.
//

import UIKit

class DoNothingViewController: UIViewController {

    var includeHandle = true {
        didSet {
            updateButtonTitle()
        }
    }
    
    private func updateButtonTitle() {
        handleButton.setTitle(includeHandle ? "Hide Handle" : "Show Handle", for: .normal)
    }

    @IBOutlet weak var sliderView: SliderView!
    
    @IBOutlet weak var handleButton: UIButton! {
        didSet {
            updateButtonTitle()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sliderView.delegate = self
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!], for: .normal)
    }

    @IBAction func pressedButton(_ sender: UIButton) {
        includeHandle = !includeHandle
    }
}

extension DoNothingViewController: SliderViewDelegate {
    func getHandleState() -> Bool {
        return includeHandle
    }
}
