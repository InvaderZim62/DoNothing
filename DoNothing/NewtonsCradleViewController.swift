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
    
    @IBOutlet weak var ballsView: CradleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0..<CradleDims.numberOfBalls {
            let ball = Ball(angle: 0.rads)
            ballsView.balls.append(ball)
        }
        ballsView.balls[0].angle = -30.rads
        ballsView.balls[1].angle = -30.rads
        ballsView.balls[2].angle = -30.rads
//        ballsView.balls[CradleDims.numberOfBalls-1].angle = 30.rads

        simulationTimer = Timer.scheduledTimer(timeInterval: CradleDims.frameTime, target: self,
                                               selector: #selector(updateSimulation),
                                               userInfo: nil, repeats: true)
    }
    
    @objc func updateSimulation() {
        for ball in ballsView.balls {
            ball.simulate()
        }
        Ball.handleCollisionsBetween(balls: ballsView.balls)
        ballsView.time += CradleDims.frameTime
    }
    
    @IBAction func reset(_ sender: UIButton) {
        for ball in ballsView.balls {
            ball.reset()
        }
    }
}
