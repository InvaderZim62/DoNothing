//
//  NewtonsCradleViewController.swift
//  DoNothing
//
//  Created by Phil Stern on 6/4/19.
//  Copyright © 2019 Phil Stern. All rights reserved.
//

import UIKit

struct CradleDims {
    static let numberOfBalls = 5
    static let frameTime = 0.01  // sec
    static let length = 1.0      // ft
    static let G = 32.179        // ft/s2
}

class NewtonsCradleViewController: UIViewController {

    private var simulationTimer = Timer()
    private var balls = [Ball]()
    
    private var isRunning = true {
        didSet {
            stopStartButton.setTitle(isRunning ? "Stop" : "Start", for: .normal)
        }
    }
    
    @IBOutlet weak var cradleView: CradleView!
    @IBOutlet weak var stopStartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0..<CradleDims.numberOfBalls {
            let ball = Ball(angle: 0.rads)
            balls.append(ball)
        }
        cradleView.setBalls(balls: balls)
        
        balls[0].angle = -30.rads
        balls[1].angle = -30.rads
        balls[2].angle = -30.rads
//        balls[CradleDims.numberOfBalls-1].angle = 30.rads
        
        startSimulation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        simulationTimer.invalidate()
    }

    private func startSimulation() {
        simulationTimer = Timer.scheduledTimer(timeInterval: CradleDims.frameTime, target: self,
                                               selector: #selector(updateSimulation),
                                               userInfo: nil, repeats: true)
    }
    
    @objc func updateSimulation() {
        _ = balls.map { $0.simulate() }
        Ball.handleCollisionsBetween(balls: balls)
        cradleView.time += CradleDims.frameTime
    }
    
    @IBAction func stopStartPressed(_ sender: UIButton) {
        if isRunning {
            _ = balls.map { $0.stop() }
            simulationTimer.invalidate()
            updateSimulation()
        } else {
            balls[0].angle = -30.rads
            startSimulation()
        }
        isRunning = !isRunning
    }
}
