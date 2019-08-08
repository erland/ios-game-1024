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
    var button8x8unlimited: SKLabelNode?
    var button1024InProgress: SKLabelNode?
    var button2048InProgress: SKLabelNode?
    var button4096InProgress: SKLabelNode?
    var button1024unlimitedInProgress: SKLabelNode?
    var button2048unlimitedInProgress: SKLabelNode?
    var button8x8unlimitedInProgress: SKLabelNode?

    override func sceneDidLoad() {
        localize()
    }
    
    func setup(delegate: GameDelegate) {
        self.gameDelegate = delegate
        
        self.button1024 = childNode(withName:"1024") as? SKLabelNode
        self.button2048 = childNode(withName:"2048") as? SKLabelNode
        self.button4096 = childNode(withName:"4096") as? SKLabelNode
        self.button1024unlimited = childNode(withName:"1024unlimited") as? SKLabelNode
        self.button2048unlimited = childNode(withName:"2048unlimited") as? SKLabelNode
        self.button8x8unlimited = childNode(withName:"8x8unlimited") as? SKLabelNode
        self.button1024InProgress = childNode(withName:"1024InProgress") as? SKLabelNode
        self.button2048InProgress = childNode(withName:"2048InProgress") as? SKLabelNode
        self.button4096InProgress = childNode(withName:"4096InProgress") as? SKLabelNode
        self.button1024unlimitedInProgress = childNode(withName:"1024unlimitedInProgress") as? SKLabelNode
        self.button2048unlimitedInProgress = childNode(withName:"2048unlimitedInProgress") as? SKLabelNode
        self.button8x8unlimitedInProgress = childNode(withName:"8x8unlimitedInProgress") as? SKLabelNode

        showHideInProgress(type: "1024", button: self.button1024InProgress!)
        showHideInProgress(type: "2048", button: self.button2048InProgress!)
        showHideInProgress(type: "4096", button: self.button4096InProgress!)
        showHideInProgress(type: "1024 unlimited", button: self.button1024unlimitedInProgress!)
        showHideInProgress(type: "2048 unlimited", button: self.button2048unlimitedInProgress!)
        showHideInProgress(type: "8x8 unlimited", button: self.button8x8unlimitedInProgress!)
    }
    
    override func didMove(to view: SKView) {
        
    }
    func showHideInProgress(type: String, button: SKLabelNode) {
        if LevelStorage().getInProgress(type: type) != nil {
            button.isHidden = false
        }else {
            button.isHidden = true
        }
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
        }else if button8x8unlimited!.contains(touchLocation) {
            gameDelegate?.selectedDifficulty(type: "8x8 unlimited")
        }
    }
}
