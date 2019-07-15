//
//  GameScene.swift
//  Game1024
//
//  Created by Erland Isaksson on 2019-07-13.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import SpriteKit
import GameplayKit

class SingleGameScene: SKScene, BoardObserver {
    var boardView: BoardView?
    var gameDelegate: GameDelegate?
    var timeText : SKLabelNode?
    var scoreText : SKLabelNode?
    var recordLabel : SKLabelNode?
    var recordText : SKLabelNode?
    var quitButton : SKLabelNode?
    var timeCounter : Int = 0
    var recordScore : Int?
    var recordTime : Int?
    var score : Int = 0
    let swipeRightRec = UISwipeGestureRecognizer()
    let swipeLeftRec = UISwipeGestureRecognizer()
    let swipeUpRec = UISwipeGestureRecognizer()
    let swipeDownRec = UISwipeGestureRecognizer()
    
    func setup(delegate: GameDelegate, board: Board, score: Int, startTime: Int) {
        self.gameDelegate = delegate
        
        self.boardView = childNode(withName: "board") as? BoardView
        
        let boardNameLabel = childNode(withName: "boardName") as? SKLabelNode
        if board.goal>0 {
            boardNameLabel?.text = "\(board.name) (reach a \(board.goal) tile)"
        }else {
            boardNameLabel?.text = "\(board.name) (get as high score as possible)"
        }
        self.boardView?.setup(board: board)
        self.quitButton = childNode(withName: "quit") as? SKLabelNode
        self.scoreText = childNode(withName: "score") as? SKLabelNode
        self.score = score
        displayScore()
        self.recordText = childNode(withName: "record") as? SKLabelNode
        self.recordLabel = childNode(withName: "recordLabel") as? SKLabelNode
        if let recordData = LevelStorage().getRecord(type: board.name) {
            if board.goal<=0 {
                self.recordScore = recordData.score
                self.recordText?.text = "\(recordData.score)"
            }else {
                self.recordTime = recordData.seconds
                self.recordText?.text = "\(timeAsString(recordData.seconds))"
            }
        }else {
            self.recordText?.isHidden = true
            self.recordLabel?.isHidden = true
        }
        
        
        self.timeText = childNode(withName: "time") as? SKLabelNode
        timeCounter = startTime
        displayTime()
        
        boardView?.board?.attachObserver(self)
    }
    deinit {
        boardView?.board?.detachObserver(self)
    }
    
    func setupGestureRecognizers() {
        swipeRightRec.addTarget(self, action: #selector(SingleGameScene.swipedRight) )
        swipeRightRec.direction = .right
        self.view?.addGestureRecognizer(swipeRightRec)
       
        swipeLeftRec.addTarget(self, action: #selector(SingleGameScene.swipedLeft) )
        swipeLeftRec.direction = .left
        self.view?.addGestureRecognizer(swipeLeftRec)
        
        swipeUpRec.addTarget(self, action: #selector(SingleGameScene.swipedUp) )
        swipeUpRec.direction = .up
        self.view?.addGestureRecognizer(swipeUpRec)
        
        swipeDownRec.addTarget(self, action: #selector(SingleGameScene.swipedDown) )
        swipeDownRec.direction = .down
        self.view?.addGestureRecognizer(swipeDownRec)
    }
    override func didMove(to view: SKView) {
        print("Moved to game scene")
        setupGestureRecognizers()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateTimer() {
        timeCounter = timeCounter + 1
        displayTime()
    }
    
    func timeAsString(_ seconds: Int) -> String {
        let hours = Int(seconds/3600)
        let minutes = String(format: "%02d",Int((seconds%3600)/60))
        let seconds = String(format: "%02d",Int(seconds%60))
        if hours == 0 {
            return  "\(minutes):\(seconds)"
        }else {
            return "\(hours):\(minutes):\(seconds)"
        }
    }
    
    func displayTime() {
        if recordTime != nil && timeCounter>recordTime! {
            timeText?.fontColor = .red
        }
        timeText?.text = "\(timeAsString(timeCounter))"
    }
    func displayScore() {
        if recordScore != nil && score>recordScore! {
            scoreText?.fontColor = .green
        }
        scoreText?.text = "Score: \(score)"
    }

    
    func numberAdded(_ number: Number) {
        //TODO: Implement
    }
    
    func numberRemoved(_ number: Number) {
        score = score + (number.number * 2)
        displayScore()
    }
    
    @objc func swipedLeft() {
        _ = boardView!.board!.moveLeft()
        checkIfComplete()
    }
    @objc func swipedRight() {
        _ = boardView!.board!.moveRight()
        checkIfComplete()
    }
    @objc func swipedUp() {
        _ = boardView!.board!.moveUp()
        checkIfComplete()
    }
    @objc func swipedDown() {
        _ = boardView!.board!.moveDown()
        checkIfComplete()
    }
    
    func checkIfComplete() {
        if boardView!.board!.isCompleted() {
            gameDelegate?.gameCompleted(board: boardView!.board!, score: score, seconds: timeCounter)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        if quitButton!.contains(touchLocation) {
            gameDelegate?.gameCompleted(board: boardView!.board!, score: score, seconds: timeCounter)
        }

    }
}

