//
//  BoardStorage.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-23.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import Foundation

struct StoredLevel : Codable {
    let type : String
    let current : String
    let score : Int
    let seconds : Int

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case current = "current"
        case score = "score"
        case seconds = "seconds"
    }
    
    init(type: String, current: String, score: Int, seconds: Int) {
        self.type = type
        self.current = current
        self.score = score
        self.seconds = seconds
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decode(String.self, forKey: .type)
        current = try values.decode(String.self, forKey: .current)
        score = try values.decode(Int.self, forKey: .score)
        seconds = try values.decode(Int.self, forKey: .seconds)
    }
    
}

struct LevelRecord : Codable {
    let type : String
    let current : String
    let score : Int
    let seconds : Int

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case current = "current"
        case score = "score"
        case seconds = "seconds"
    }
    init(type: String, current: String, score: Int, seconds: Int) {
        self.type = type
        self.seconds = seconds
        self.current = current
        self.score = score
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decode(String.self, forKey: .type)
        current = try values.decode(String.self, forKey: .current)
        score = try values.decode(Int.self, forKey: .score)
        seconds = try values.decode(Int.self, forKey: .seconds)
    }
}

class LevelStorage {

    func initializeBoard(_ storedLevel: StoredLevel) -> Board {
        var board: Board
        switch storedLevel.type {
        case "1024":
            board = Board(name: "1024", width: 4, height: 4, goal: 1024, primaryFeed: 1, secondaryFeed: 1, boardString: storedLevel.current)
        case "2048":
            board = Board(name: "2048", width: 4, height: 4, goal: 2048, primaryFeed: 2, secondaryFeed: 4, boardString: storedLevel.current)
        case "4096":
            board = Board(name: "4096", width: 4, height: 4, goal: 4096, primaryFeed: 2, secondaryFeed: 4, boardString: storedLevel.current)
        case "1024 unlimited":
            board = Board(name: "1024 unlimited", width: 4, height: 4, goal: 0, primaryFeed: 1, secondaryFeed: 1, boardString: storedLevel.current)
        case "2048 unlimited":
            board = Board(name: "2048 unlimited", width: 4, height: 4, goal: 0, primaryFeed: 2, secondaryFeed: 4, boardString: storedLevel.current)
        default:
            board = Board(name: "1024", width: 4, height: 4, goal: 1024, primaryFeed: 1, secondaryFeed: 1, boardString: storedLevel.current)
        }
        return board

    }

    func storeBoardInProgress(board: Board, score: Int, seconds: Int) {
        let storedLevel = serializeBoard(board: board, score: score, seconds: seconds)
        var boards = loadData(StoredLevel.self, forKey: "inProgress")
        for (i,b) in boards.enumerated() {
            if b.type == storedLevel.type {
                boards.remove(at: i)
                break
            }
        }
        boards.insert(storedLevel, at: 0)
        storeData(boards, forKey: "inProgress")
    }
    
    func removeBoardInProgress(type: String) {
        var boards = loadData(StoredLevel.self, forKey: "inProgress")
        var removed = false
        for (i,b) in boards.enumerated() {
            if b.type == type {
                boards.remove(at: i)
                removed = true
                break
            }
        }
        if removed {
            storeData(boards, forKey: "inProgress")
        }
    }
    
    func serializeBoard(board: Board, score: Int, seconds: Int) -> StoredLevel {
        let current = board.asString()
        return StoredLevel.init(type: board.name, current: current, score: score, seconds: seconds)
    }
    
    func registerRecord(type: String, current: String, score: Int, seconds: Int) {
        var records = loadData(LevelRecord.self, forKey: "records")
        var shouldBeAdded = true
        for (i,r) in records.enumerated() {
            if r.type == type {
                if r.type.contains("unlimited") {
                    if r.score > score {
                        shouldBeAdded = false
                    }else {
                        records.remove(at: i)
                    }
                }else {
                    if r.seconds < seconds {
                        shouldBeAdded = false
                    }else {
                        records.remove(at: i)
                    }
                }
                break
            }
        }
        if shouldBeAdded {
            records.append(LevelRecord.init(type: type, current: current, score: score, seconds: seconds))
        }
        storeData(records, forKey: "records")
    }

    struct LevelState {
        let current : String
        let score : Int
        let seconds : Int
    }
    
    func getRecord(type: String) -> LevelState? {
        
        let records = loadData(LevelRecord.self, forKey: "records")
        for r in records {
            if r.type == type {
                return LevelState(current: r.current, score: r.score, seconds: r.seconds)
            }
        }
        return nil
    }

    func getInProgress(type: String) -> LevelState? {
        
        let started = loadData(StoredLevel.self, forKey: "inProgress")
        for b in started {
            if b.type == type {
                return LevelState(current: b.current, score: b.score, seconds: b.seconds)
            }
        }
        return nil
    }

    func storeData<T: Codable>(_ value: [T], forKey defaultName: String){
        let data = value.map { try? JSONEncoder().encode($0) }
        
        UserDefaults.standard.set(data, forKey: defaultName)
    }
    
    func loadData<T>(_ type: T.Type, forKey defaultName: String) -> [T] where T : Decodable {
        guard let encodedData = UserDefaults.standard.array(forKey: defaultName) as? [Data] else {
            return []
        }
        
        return encodedData.map { try! JSONDecoder().decode(type, from: $0) }
    }
    
}
