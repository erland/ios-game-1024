//
//  Car.swift
//  RushHour
//
//  Created by Erland Isaksson on 2019-07-07.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import SpriteKit

protocol NumberObserver {
    func numberUpdated(_ number: Number)
}
class Number : Hashable, NSCopying {
    var observers: [NumberObserver] = []
    
    init(number: Int, x: Int, y: Int) {
        self.x = x
        self.y = y
        self.number = number
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Number(number: self.number, x: self.x,y: self.y)
        return copy
    }
    
    func attachObserver(observer: NumberObserver) {
        observers.append(observer)
    }
    
    private func notifyObservers() {
        for observer in observers {
            observer.numberUpdated(self)
        }
    }
    var x: Int {
        didSet {
            notifyObservers()
        }
    }
    var y: Int {
        didSet {
            notifyObservers()
        }
    }
    var number: Int {
        didSet {
            notifyObservers()
        }
    }
    
    static func == (lhs: Number, rhs: Number) -> Bool {
        return lhs === rhs
    }
    var hashValue: Int {
        return 0
    }
}

