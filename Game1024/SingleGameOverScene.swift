//
//  SingleGameOverScene.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-14.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import SpriteKit
import GameplayKit

class SingleGameOverScene: SKScene {
    var gameDelegate: GameDelegate?
    var boardView: BoardView?
    var openedTime: TimeInterval?
    var status: SKLabelNode?
    var completedIn: SKLabelNode?
    var scoreText: SKLabelNode?
    var boardName: SKLabelNode?
    var score: Int = 0
    var seconds: Int = 0
    
    override func sceneDidLoad() {
        localize()
    }

    func setup(delegate: GameDelegate, board: Board, score: Int, seconds: Int) {
        self.gameDelegate = delegate
        self.score = score
        self.seconds = seconds
        self.boardView = childNode(withName:"board") as? BoardView
        self.status = childNode(withName:"status") as? SKLabelNode
        self.boardName = childNode(withName:"boardName") as? SKLabelNode
        if board.goal>0 {
            boardName?.text = "\(board.name) (\(NSLocalizedString("reachATileWith", comment: "reachATileWith")) \(board.goal))"
        }else {
            boardName?.text = "\(board.name) (\(NSLocalizedString("asHighScoreAsPossible", comment: "asHighScoreAsPossible")))"
        }
        self.completedIn = childNode(withName:"completedIn") as? SKLabelNode
        self.scoreText = childNode(withName:"score") as? SKLabelNode
        self.boardView?.setup(board: board)
        if boardView!.board!.isSuccessfullyCompleted() {
            status?.text = "\(NSLocalizedString("congratulations", comment: "congratulations"))!"
            displayCompletionTime(prefix: "\(NSLocalizedString("completedIn", comment: "completedIn"))", seconds: seconds)
            scoreText?.text = "\(NSLocalizedString("score", comment: "score")): \(score)"
        }else {
            status?.text = "\(NSLocalizedString("gameOver", comment: "gameOver"))"
            displayCompletionTime(prefix: "\(NSLocalizedString("timeSpent", comment: "timeSpent"))", seconds: seconds)
            scoreText?.text = "\(NSLocalizedString("score", comment: "score")): \(score)"
        }
        
    }
    func displayCompletionTime(prefix: String, seconds: Int) {
        let hours = Int(seconds/3600)
        let minutes = String(format: "%02d",Int((seconds%3600)/60))
        let seconds = String(format: "%02d",Int(seconds%60))
        if hours == 0 {
            completedIn?.text = "\(prefix): \(minutes):\(seconds)"
        }else {
            completedIn?.text = "\(prefix): \(hours):\(minutes):\(seconds)"
        }
    }
    
    override func didMove(to view: SKView) {
        openedTime = NSDate().timeIntervalSince1970
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // We need to ensure the sceen is shown for 2 seconds before we allow player to continue
        if openedTime!<NSDate().timeIntervalSince1970-2 {
            gameDelegate?.backToMenu(board: boardView!.board!, score: score, seconds: seconds)
        }
    }
}
