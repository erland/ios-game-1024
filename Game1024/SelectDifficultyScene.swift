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
    var button5x5: SKLabelNode?
    var button8x8: SKLabelNode?
    var button2048unlimited: SKLabelNode?

    func setup(delegate: GameDelegate) {
        self.gameDelegate = delegate
        
        self.button1024 = childNode(withName:"1024") as? SKLabelNode
        self.button2048 = childNode(withName:"2048") as? SKLabelNode
        self.button5x5 = childNode(withName:"5x5") as? SKLabelNode
        self.button8x8 = childNode(withName:"8x8") as? SKLabelNode
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
        }else if button5x5!.contains(touchLocation) {
            gameDelegate?.selectedDifficulty(type: "5x5")
        }else if button8x8!.contains(touchLocation) {
            gameDelegate?.selectedDifficulty(type: "8x8")
        }else if button2048unlimited!.contains(touchLocation) {
            gameDelegate?.selectedDifficulty(type: "2048 unlimited")
        }
    }
}
