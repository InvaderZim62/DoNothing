//
//  NewtonsCradleViewController.swift
//  DoNothing
//
//  Created by Phil Stern on 6/4/19.
//  Copyright © 2019 Phil Stern. All rights reserved.
//

import UIKit
import AVFoundation  // needed for AVAudioPlayer

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
    private var player: AVAudioPlayer?
    private var collisionTime = 0.0  // used to prevent too many sounds from playing at the same time

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
        updateViewFromModel()
        setupPlayer()
    }
    
    // called first time and each time returning to this tab (memory retained when leaving tab)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isRunning = true
        balls.forEach { $0.reset() }  // set each ball to down and stopped
        balls[0].angle = -30.rads  // start with one ball to left
        startSimulation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        simulationTimer.invalidate()  // stop timer
    }

    // setup cradleView balls and ballViews (with swipe gestures)
    private func updateViewFromModel() {
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
        // determine index of swiped ballView
        if let ballView = recognizer.view as? BallView, let index = cradleView.ballViews.firstIndex(of: ballView) {
            Ball.swipedAt(index: index, of: cradleView.balls, to: recognizer.direction)
            cradleView.time += Constants.frameTime  // this causes cradleView to re-draw
        }
    }

    private func startSimulation() {
        cradleView.time = 0.0
        collisionTime = 0.0
        simulationTimer = Timer.scheduledTimer(timeInterval: Constants.frameTime, target: self,
                                               selector: #selector(updateSimulation),
                                               userInfo: nil, repeats: true)
    }
    
    // execute one simulation step for each ball
    // make click sound for significant collisions
    @objc func updateSimulation() {
        balls.forEach { $0.simulate() }
        if isRunning && Ball.isCollisionBetween(balls) {
            if cradleView.time > collisionTime + 0.05 {  // limit time for starting new sound, to avoid crashing
                DispatchQueue.global(qos: .userInitiated).async {  // use background task, to avoid slowing simulation
                    self.player?.play()
                }
                collisionTime = cradleView.time
            }
        }
        cradleView.time += Constants.frameTime  // this causes cradleView to re-draw
    }
    
    @IBAction func stopStartPressed(_ sender: UIButton) {
        if isRunning {
            balls.forEach { $0.stop() }  // turn off physics
        } else {
            balls.forEach { $0.go() }  // turn on physics
        }
        isRunning = !isRunning
    }

    func setupPlayer() {
        guard let url = Bundle.main.url(forResource: "click", withExtension: "wav") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
