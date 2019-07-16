//
//  Board.swift
//  RushHour
//
//  Created by Erland Isaksson on 2019-07-07.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import SpriteKit

protocol BoardObserver : class {
    func numberAdded(_ number: Number)
    func numberRemoved(_ number: Number)
}
class Board {
    let name: String
    let width: Int
    let height: Int
    let board: Array2D<Number>
    var numbers: Set<Number> = Set()
    var observers: [BoardObserver] = []
    let debug = false
    let goal: Int
    let primaryFeed: Int
    let secondaryFeed: Int
    
    init(name: String, width: Int, height: Int, goal: Int, primaryFeed: Int, secondaryFeed: Int) {
        self.name = name
        self.width = width
        self.height = height
        self.goal = goal
        self.primaryFeed = primaryFeed
        self.secondaryFeed = secondaryFeed
        self.board = Array2D<Number>(columns: self.width, rows: self.height)
    }
    
    convenience init(name: String, width: Int, height: Int, goal: Int, primaryFeed: Int, secondaryFeed: Int, boardString: String) {
        self.init(name: name, width: width, height: height, goal: goal, primaryFeed: primaryFeed, secondaryFeed: secondaryFeed)
        initializeFromString(boardString: boardString)
    }
    
    
    func attachObserver(_ observer: BoardObserver) {
        for num in numbers {
            observer.numberAdded(num)
        }
        observers.append(observer)
    }
    
    func detachObserver(_ observer: BoardObserver) {
        if let index = (self.observers.firstIndex(where: { $0 === observer })) {
            self.observers.remove(at: index)
        }
    }
    
    func initializeFromString(boardString: String) {
        for n in numbers {
            board[n.x,n.y] = nil
            for observer in observers {
                observer.numberRemoved(n)
            }
        }
        numbers.removeAll()

        for y in 0..<height {
            for x in 0..<width {
                let i = width*y+x
                if boardString.count > i {
                    let ch = boardString[boardString.index(boardString.startIndex, offsetBy: i)]
                    if let number = characterToNumber(String(ch)) {
                        let n = Number(number: number, x: x, y: y)
                        board[x,y] = n
                        numbers.insert(n)
                    }
                }
            }
        }
    }
    
    subscript(x: Int, y: Int) -> Number? {
        get {
            return board[x,y]
        }
    }

    private func isInsideBoard(_ x: Int, _ y: Int) -> Bool {
        if x<0 || x >= width || y<0 || y >= height {
            // Outside board
            if debug {
                print("Outside board")
            }
            return false
        }
        return true
    }
    
    func isCompleted() -> Bool {
        if isSuccessfullyCompleted() {
            return true
        }
        for y in 0..<height {
            for x in 0..<width {
                if board[x,y] == nil {
                    return false
                }
            }
        }
        for y in 0..<height {
            for x in 1..<(width-1) {
                if board[x,y]!.number == board[x-1,y]!.number || board[x,y]!.number == board[x+1,y]!.number {
                    return false
                }
            }
        }
        for x in 0..<width {
            for y in 1..<(height-1) {
                if board[x,y]!.number == board[x,y-1]!.number || board[x,y]!.number == board[x,y+1]!.number {
                    return false
                }
            }
        }

        return true
    }

    func isSuccessfullyCompleted() -> Bool {
        if goal<=0 {
            return false
        }
        for y in 0..<height {
            for x in 0..<width {
                if let n = board[x,y] {
                    if n.number >= goal {
                        return true
                    }
                }
            }
        }
        return false
    }


    func leftToEmpty() -> Bool {
        var moved : Bool = false
        for y in 0..<height {
            for x in 1..<width {
                if let num = board[x,y] {
                    for offset in (1...x) {
                        if board[x-offset,y] == nil {
                            num.x = x-offset
                            board[x-offset+1,y] = nil
                            board[x-offset,y] = num
                            moved = true
                        }
                    }
                }
            }
        }
        if moved {
            _ = leftToEmpty()
        }
        return moved
    }
    func rightToEmpty() -> Bool {
        var moved : Bool = false
        for y in 0..<height {
            for x in (0..<(width-1)).reversed() {
                if let num = board[x,y] {
                    for offset in (1..<(width-x)) {
                        if board[x+offset,y] == nil {
                            num.x = x+offset
                            board[x+offset-1,y] = nil
                            board[x+offset,y] = num
                            moved = true
                        }
                    }
                }
            }
        }
        if moved {
            _ = rightToEmpty()
        }
        return moved
    }
    func upToEmpty() -> Bool {
        var moved : Bool = false
        for x in 0..<width {
            for y in 1..<height {
                if let num = board[x,y] {
                    for offset in (1...y) {
                        if board[x,y-offset] == nil {
                            num.y = y-offset
                            board[x,y-offset+1] = nil
                            board[x,y-offset] = num
                            moved = true
                        }
                    }
                }
            }
        }
        if moved {
            _ = upToEmpty()
        }
        return moved
    }
    func downToEmpty() -> Bool {
        var moved : Bool = false
        for x in 0..<width {
            for y in (0..<(height-1)).reversed() {
                if let num = board[x,y] {
                    for offset in (1..<(height-y)) {
                        if board[x,y+offset] == nil {
                            num.y = y+offset
                            board[x,y+offset-1] = nil
                            board[x,y+offset] = num
                            moved = true
                        }
                    }
                }
            }
        }
        if moved {
            _ = downToEmpty()
        }
        return moved
    }
    func moveLeft() -> Bool {
        var moved = leftToEmpty()
        for y in 0..<height {
            for x in 1..<width {
                if let num = board[x,y] {
                    if let numCombined = board[x-1,y] {
                        if numCombined.number == num.number {
                            numCombined.number = numCombined.number * 2
                            numbers.remove(num)
                            num.x = x-1
                            board[x,y] = nil
                            for observer in observers {
                                observer.numberRemoved(num)
                            }
                            moved = true
                        }
                    }
                }
            }
        }
        if moved {
            _ = leftToEmpty()
            addRandomOnEmpty()
        }
        return moved
    }
    func moveRight() -> Bool {
        var moved = rightToEmpty()
        for y in 0..<height {
            for x in (0..<(width-1)).reversed() {
                if let num = board[x,y] {
                    if let numCombined = board[x+1,y] {
                        if numCombined.number == num.number {
                            numCombined.number = numCombined.number * 2
                            numbers.remove(num)
                            num.x = x+1
                            board[x,y] = nil
                            for observer in observers {
                                observer.numberRemoved(num)
                            }
                            moved = true
                        }
                    }
                }
            }
        }
        if moved {
            _ = rightToEmpty()
            addRandomOnEmpty()
        }
        return moved
    }

    func moveDown() -> Bool {
        var moved = downToEmpty()
        for x in 0..<width {
            for y in (0..<(height-1)).reversed() {
                if let num = board[x,y] {
                    if let numCombined = board[x,y+1] {
                        if numCombined.number == num.number {
                            numCombined.number = numCombined.number * 2
                            numbers.remove(num)
                            num.y = y+1
                            board[x,y] = nil
                            for observer in observers {
                                observer.numberRemoved(num)
                            }
                            moved = true
                        }
                    }
                }
            }
        }
        if moved {
            _ = downToEmpty()
            addRandomOnEmpty()
        }
        return moved
    }
    func moveUp() -> Bool {
        var moved = upToEmpty()
        for x in 0..<width {
            for y in 1..<height {
                if let num = board[x,y] {
                    if let numCombined = board[x,y-1] {
                        if numCombined.number == num.number {
                            numCombined.number = numCombined.number * 2
                            numbers.remove(num)
                            num.y = y-1
                            board[x,y] = nil
                            for observer in observers {
                                observer.numberRemoved(num)
                            }
                            moved = true
                        }
                    }
                }
            }
        }
        if moved {
            _ = upToEmpty()
            addRandomOnEmpty()
        }
        return moved
    }
    
    func addRandomOnEmpty() {
        var freePositions : [Int] = []
        for y in 0..<height {
            for x in 0..<width {
                if board[x,y] == nil {
                    freePositions.append(y*width+x)
                }
            }
        }
        if freePositions.count>0 {
            let index = Int.random(in: 0..<freePositions.count)
            let pos = freePositions[index]
            let y = Int(pos/width)
            let x = pos % width
            let number = Int.random(in: 0..<100)<90 ? primaryFeed : secondaryFeed
            let num = Number(number: number, x: x, y: y)
            numbers.insert(num)
            board[x,y] = num
            for observer in observers {
                observer.numberAdded(num)
            }
        }
    }

    private func characterToNumber(_ character: String) -> Int? {
        if let num = Int(String(character)) {
            return Int(pow(Double(2),Double(num)))
        }else {
            switch character {
            case "a":
                return 1024
            case "b":
                return 2048
            case "c":
                return 4096
            case "d":
                return 8192
            case "e":
                return 16384
            case "f":
                return 32768
            case "g":
                return 65536
            case "h":
                return 131072
            case "i":
                return 262144
            case "j":
                return 524288
            default:
                return nil
            }
        }
    }
    private func numberToCharacter(_ num: Int) -> String {
        switch num {
        case 1:
            return "0"
        case 2:
            return "1"
        case 4:
            return "2"
        case 8:
            return "3"
        case 16:
            return "4"
        case 32:
            return "5"
        case 64:
            return "6"
        case 128:
            return "7"
        case 256:
            return "8"
        case 512:
            return "9"
        case 1024:
            return "a"
        case 2048:
            return "b"
        case 4096:
            return "c"
        case 8192:
            return "d"
        case 16384:
            return "e"
        case 32768:
            return "e"
        case 65536:
            return "f"
        case 131072:
            return "g"
        case 262144:
            return "h"
        case 524288:
            return "i"
        default:
            return "o"
        }
    }
    func asString() -> String {
        var result = ""
        for y in 0..<height {
            for x in 0..<width {
                if board[x,y] != nil {
                    let n = board[x,y]
                    result = result + "\(numberToCharacter(n!.number))"
                }else {
                    result = result + "o"
                }
            }
        }
        return result
    }
    
    func debugBoard(debug: Bool? = nil) {
        if self.debug || (debug != nil && debug!) {
            
            print("Board contents")
            for y in 0..<height {
                for x in 0..<width {
                    if board[x,y] != nil {
                        let n = board[x,y]
                        print("\(numberToCharacter(n!.number))", terminator: "")
                    }else {
                        print("o", terminator: "")
                    }
                }
                print()
            }
        }
    }
    
}
