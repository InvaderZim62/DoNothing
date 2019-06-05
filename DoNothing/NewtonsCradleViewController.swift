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
        updateViewWithModel()
        
        balls[0].angle = -30.rads  // start with one ball to left
        startSimulation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        simulationTimer.invalidate()
    }

    private func updateViewWithModel() {
        cradleView.ballViews.removeAll()
        cradleView.subviews.filter( { $0.isKind(of: BallView.self) }).forEach( { $0.removeFromSuperview() })
        
        cradleView.balls = balls
        for _ in 0..<balls.count {
            let ballView = BallView(frame: CGRect(x: 0.0, y: 0.0, width: 2.0 * BallDims.radius, height: 2.0 * BallDims.radius))
            
            // add two swipe gestures to ballView
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ballSwiped))
            swipeLeft.direction = .left
            ballView.addGestureRecognizer(swipeLeft)
            
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ballSwiped))
            swipeRight.direction = .right
            ballView.addGestureRecognizer(swipeRight)
            
            cradleView.ballViews.append(ballView)
            cradleView.addSubview(ballView)
        }
    }
    
    @objc private func ballSwiped(recognizer: UISwipeGestureRecognizer) {
        if let ballView = recognizer.view as? BallView, let index = cradleView.ballViews.firstIndex(of: ballView) {
            Ball.swipedAt(index: index, of: cradleView.balls, to: recognizer.direction)
            updateSimulation()
        }
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
            startSimulation()
        }
        isRunning = !isRunning
    }
}
