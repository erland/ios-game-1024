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
            LevelStorage().registerRecord(board: board, score: score, seconds: seconds)
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
            selectDifficulty()
        }

    }
    
    func restartGame() {
        viewDidLoad()
    }
    
    func backToMenu() {
        viewDidLoad()
    }
    
    func selectedDifficulty(type: String) {
        var board: Board
        switch type {
        case "1024":
            board = Board(name: "1024", width: 4, height: 4, goal: 1024, primaryFeed: 1, secondaryFeed: 1)
        case "2048":
            board = Board(name: "2048", width: 4, height: 4, goal: 2048, primaryFeed: 2, secondaryFeed: 4)
        case "5x5":
            board = Board(name: "5x5", width: 5, height: 5, goal: 65536, primaryFeed: 2, secondaryFeed: 4)
        case "8x8":
            board = Board(name: "8x8", width: 8, height: 8, goal: 16384, primaryFeed: 2, secondaryFeed: 4)
            board.addRandomOnEmpty()
            board.addRandomOnEmpty()
        case "2048 unlimited":
            board = Board(name: "2048 unlimited", width: 4, height: 4, goal: 0, primaryFeed: 2, secondaryFeed: 4)
        default:
            board = Board(name: "1024", width: 4, height: 4, goal: 1024, primaryFeed: 1, secondaryFeed: 1)
        }
        board.addRandomOnEmpty()
        board.addRandomOnEmpty()

        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "SingleGameScene") as? SingleGameScene {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
                scene.setup(delegate: self, board: board, score: 0, startTime: 0)
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
        }
    }
    

}
