//
//  CarView.swift
//  RushHour
//
//  Created by Erland Isaksson on 2019-07-07.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import SpriteKit

class NumberView : SKSpriteNode, NumberObserver {
    let cellSize: CGFloat
    let number : Number
    let numberLabel : SKLabelNode = SKLabelNode(fontNamed: "ArialRoundedMTBold")
    
    init(number: Number, cellSize: CGFloat) {
        self.cellSize = cellSize
        self.number = number
        super.init(texture: nil, color: UIColor.black, size: CGSize(width: cellSize-1, height: cellSize-1))
        number.attachObserver(observer: self)
        anchorPoint = CGPoint(x: 0, y: 1)
        numberLabel.fontColor = .black
        numberLabel.zPosition = 10
        numberLabel.fontSize = cellSize/3.5
        numberLabel.horizontalAlignmentMode = .center
        numberLabel.verticalAlignmentMode = .center
        numberLabel.position = CGPoint(x: 0, y: 0)
        addChild(numberLabel)
        numberUpdated(number)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberUpdated(_ number: Number) {
        let posX = CGFloat(number.x)*cellSize+cellSize/2.0
        let posY = -CGFloat(number.y)*cellSize-cellSize/2.0
        if texture == nil {
            self.position = CGPoint(x: posX, y: posY)
            if self.numberLabel.text != "\(number.number)" {
                self.numberLabel.text = "\(number.number)"
                self.texture = SKTexture(imageNamed: "block\(number.number)")
            }
        }else {
            self.run(SKAction.sequence([
                SKAction.move(to: CGPoint(x: posX, y: posY), duration: 0.1),
                SKAction.run( {
                    if self.numberLabel.text != "\(number.number)" {
                        self.numberLabel.text = "\(number.number)"
                        self.texture = SKTexture(imageNamed: "block\(number.number)")
                    }
                })])
            )
        }
    }
    
    
}

