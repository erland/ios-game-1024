//
//  SelectDifficultyScene.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-22.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import SpriteKit

class SelectDifficultyScene: SKScene {
    var gameDelegate: GameDelegate?
    var button1024: SKLabelNode?
    var button2048: SKLabelNode?
    var button4096: SKLabelNode?
    var button1024unlimited: SKLabelNode?
    var button2048unlimited: SKLabelNode?

    func setup(delegate: GameDelegate) {
        self.gameDelegate = delegate
        
        self.button1024 = childNode(withName:"1024") as? SKLabelNode
        self.button2048 = childNode(withName:"2048") as? SKLabelNode
        self.button4096 = childNode(withName:"4096") as? SKLabelNode
        self.button1024unlimited = childNode(withName:"1024unlimited") as? SKLabelNode
        self.button2048unlimited = childNode(withName:"2048unlimited") as? SKLabelNode
    }
    
    override func didMove(to view: SKView) {
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        if button1024!.contains(touchLocation) {
            gameDelegate?.selectedDifficulty(type: "1024")
        }else if button2048!.contains(touchLocation) {
            gameDelegate?.selectedDifficulty(type: "2048")
        }else if button4096!.contains(touchLocation) {
            gameDelegate?.selectedDifficulty(type: "4096")
        }else if button1024unlimited!.contains(touchLocation) {
            gameDelegate?.selectedDifficulty(type: "1024 unlimited")
        }else if button2048unlimited!.contains(touchLocation) {
            gameDelegate?.selectedDifficulty(type: "2048 unlimited")
        }
    }
}
