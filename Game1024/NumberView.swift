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
    
    init(number: Number, cellSize: CGFloat) {
        self.cellSize = cellSize
        self.number = number
        super.init(texture: nil, color: UIColor.black, size: CGSize(width: cellSize, height: cellSize))
        number.attachObserver(observer: self)
        anchorPoint = CGPoint(x: 0, y: 1)
        numberUpdated(number)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createCarTexture(number: Int, cellSize: CGFloat, borderColor: UIColor, fillColor: UIColor, alpha: CGFloat) -> SKTexture? {
        let cornerRadius = CGFloat(0.0)
        let shape = SKShapeNode.init(rectOf: CGSize(width: cellSize,
                                                    height: cellSize), cornerRadius: cornerRadius)
        shape.fillColor = fillColor
        if fillColor == .white {
            shape.strokeColor = fillColor
        }else {
            shape.strokeColor = borderColor
        }
        shape.alpha = alpha
        let numberLabel = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        numberLabel.fontColor = .black
        numberLabel.text = "\(number)"
        numberLabel.fontSize = cellSize/3.5
        numberLabel.horizontalAlignmentMode = .center
        numberLabel.verticalAlignmentMode = .center
        numberLabel.position = CGPoint(x: 0, y: 0)
        shape.addChild(numberLabel)
        let view = SKView(frame: CGRect(x: 0, y: 0, width: cellSize, height: cellSize))
        return view.texture(from: shape)
    }
    
    func colorForNumber(_ number: Int) -> UIColor {
        switch number {
        case 1:
            return hexStringToUIColor("#3333ff")
        case 2:
            return hexStringToUIColor("#3366ff")
        case 4:
            return hexStringToUIColor("#6699ff")
        case 8:
            return hexStringToUIColor("#99ccff")
        case 16:
            return hexStringToUIColor("#cce6ff")
        case 32:
            return hexStringToUIColor("#e6f2ff")
        case 64:
            return hexStringToUIColor("#ffffcc")
        case 128:
            return hexStringToUIColor("#ffff99")
        case 256:
            return hexStringToUIColor("#ffff00")
        case 512:
            return hexStringToUIColor("#ccff33")
        case 1024:
            return hexStringToUIColor("#99ff33")
        case 2048:
            return hexStringToUIColor("#66ff33")
        case 4096:
            return hexStringToUIColor("#33cc33")
        case 8192:
            return hexStringToUIColor("#99cc00")
        case 16384:
            return hexStringToUIColor("#ff9933")
        case 32768:
            return hexStringToUIColor("#ff9999")
        case 65536:
            return hexStringToUIColor("#ff99ff")
        case 131072:
            return hexStringToUIColor("#ff00ff")
        case 262144:
            return hexStringToUIColor("#ffccff")
        case 524288:
            return hexStringToUIColor("#ffffff")
        default:
            return .white
        }
    }
    func hexStringToUIColor(_ hex : String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func numberUpdated(_ number: Number) {
        let posX = CGFloat(number.x)*cellSize+cellSize/2.0
        let posY = -CGFloat(number.y)*cellSize-cellSize/2.0
        let color = colorForNumber(number.number)
        let newTexture = self.createCarTexture(number: number.number, cellSize: self.cellSize, borderColor: color, fillColor: color, alpha: 1.0)
        if texture == nil {
            self.position = CGPoint(x: posX, y: posY)
            self.texture = newTexture
        }else {
            self.run(SKAction.sequence([
                SKAction.move(to: CGPoint(x: posX, y: posY), duration: 0.1),
                SKAction.run( {
                    self.texture = newTexture
                })])
            )
        }
    }
    
    
}

