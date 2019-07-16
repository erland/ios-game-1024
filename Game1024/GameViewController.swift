//
//  GameViewController.swift
//  Game1024
//
//  Created by Erland Isaksson on 2019-07-13.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, GameDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        selectDifficulty()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func selectDifficulty() {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "SelectDifficultyScene") as? SelectDifficultyScene {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
                
                scene.setup(delegate: self)
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
        }
    }
    
    func gameCompleted(board: Board, score: Int, seconds: Int) {
        if board.isCompleted() {
            let boardString = board.asString()
            if board.goal>0 {
                if board.isSuccessfullyCompleted() {
                    LevelStorage().registerRecord(type: board.name, current: boardString, score: score, seconds: seconds)
                    LevelStorage().registerRecord(type: board.name+" unlimited", current: boardString, score: score, seconds: seconds)
                }else {
                    LevelStorage().registerRecord(type: board.name+" unlimited", current: boardString, score: score, seconds: seconds)
                }
            }else {
                LevelStorage().registerRecord(type: board.name, current: boardString, score: score, seconds: seconds)
            }

            LevelStorage().removeBoardInProgress(type: board.name)
            if let view = self.view as! SKView? {
                // Load the SKScene from 'GameScene.sks'
                if let scene = SKScene(fileNamed: "SingleGameOverScene") as? SingleGameOverScene {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFit
                    
                    scene.setup(delegate: self, board: board, score: score, seconds: seconds)
                    
                    // Present the scene
                    view.presentScene(scene)
                }
                
                view.ignoresSiblingOrder = true
            }
        }else {
            LevelStorage().storeBoardInProgress(board: board, score: score, seconds: seconds)
            selectDifficulty()
        }

    }
    
    func restartGame() {
        viewDidLoad()
    }
    
    func backToMenu(board: Board, score: Int, seconds: Int) {
        LevelStorage().removeBoardInProgress(type: board.name)
        viewDidLoad()
    }
    
    func selectedDifficulty(type: String) {
        var board: Board
        var boardString: String?
        var goal = 0
        var startTime = 0
        var score = 0
        var primaryFeed = 1
        var secondaryFeed = 1
        if let state = LevelStorage().getInProgress(type: type) {
            score = state.score
            startTime = state.seconds
            boardString = state.current
        }
        switch type {
        case "1024":
            goal = 1024
            primaryFeed = 1
            secondaryFeed = 1
        case "2048":
            goal = 2048
            primaryFeed = 2
            secondaryFeed = 4
        case "4096":
            goal = 4096
            primaryFeed = 2
            secondaryFeed = 4
        case "1024 unlimited":
            goal = 0
            primaryFeed = 1
            secondaryFeed = 1
        case "2048 unlimited":
            goal = 0
            primaryFeed = 2
            secondaryFeed = 4
        default:
            goal = 1024
            primaryFeed = 1
            secondaryFeed = 1
        }
        if let boardString = boardString {
            board = Board(name: type, width: 4, height: 4, goal: goal, primaryFeed: primaryFeed, secondaryFeed: secondaryFeed, boardString: boardString)
        }else {
            board = Board(name: type, width: 4, height: 4, goal: goal, primaryFeed: primaryFeed, secondaryFeed: secondaryFeed)
            board.addRandomOnEmpty()
            board.addRandomOnEmpty()
        }

        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "SingleGameScene") as? SingleGameScene {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
                scene.setup(delegate: self, board: board, score: score, startTime: startTime)
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
        }
    }
    

}
