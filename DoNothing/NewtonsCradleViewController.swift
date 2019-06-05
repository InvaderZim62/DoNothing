//
//  NewtonsCradleViewController.swift
//  DoNothing
//
//  Created by Phil Stern on 6/4/19.
//  Copyright © 2019 Phil Stern. All rights reserved.
//

import UIKit

struct Constants {
    static let numberOfBalls = 5
    static let frameTime = 0.01      // sec
    static let pendulumLength = 1.0  // ft (physics)
    static let G = 32.179            // ft/s2
    static let ballRadius = 20.0     // points
    static let stringLength = 200.0  // points (drawing)
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
        
        for _ in 0..<Constants.numberOfBalls {
            let ball = Ball()
            balls.append(ball)
        }
        updateViewWithModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isRunning = true
        _ = balls.map { $0.stop() }  // set each ball to down and stopped
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
            let ballView = BallView(frame: CGRect(x: 0.0, y: 0.0, width: 2.0 * Constants.ballRadius,
                                                  height: 2.0 * Constants.ballRadius))
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
            cradleView.time += Constants.frameTime  // this causes cradleView to re-draw
        }
    }

    private func startSimulation() {
        simulationTimer = Timer.scheduledTimer(timeInterval: Constants.frameTime, target: self,
                                               selector: #selector(updateSimulation),
                                               userInfo: nil, repeats: true)
    }
    
    @objc func updateSimulation() {
        _ = balls.map { $0.simulate() }  // execute one simulation step for each ball
        Ball.handleCollisionsBetween(balls: balls)
        cradleView.time += Constants.frameTime  // this causes cradleView to re-draw
    }
    
    @IBAction func stopStartPressed(_ sender: UIButton) {
        if isRunning {
            _ = balls.map { $0.stop() }  // reset each ball to down and stopped
            simulationTimer.invalidate()
            cradleView.time = 0.0  // this causes cradleView to re-draw
        } else {
            startSimulation()
        }
        isRunning = !isRunning
    }
}
