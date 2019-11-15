//
//  Game.swift
//  PointsUI
//
//  Created by Alexander Völz on 30.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//
import SwiftUI

/// Player, as data and as object
class Player: ObservableObject {
    var name: String
    var points: Int
    
    init(name: String, points: Int = 0) {
        self.name = name
        self.points = points
        print("created player <\(self.name)> with \(points) points")
    }
    
    func encode() -> PlayerData {
        print("encoded a player name \(name)")
        return PlayerData(name: name, points: points)
    }
}

struct PlayerData : Codable {
    var name: String
    var points: Int = 0
    
    func object() -> Player {
        print("created a player object")
        return Player(name: name, points: points)
    }
}

/// Default values
struct Default {
    static let names = [ "Alexander", "Lili", "Villa" ]
}

/// GameState: a list of the current players and their scores
struct GameState : Codable {
    var players : [PlayerData]
}

/// a list of game States
struct History : Codable {
    var states = [GameState]()
}

/// where we save the data in userdefaults
enum SettingsVariables : String {
    case saveData = "saveData"
}

/// what we save
struct SaveData : Codable {
    var maxGames = 3
    var pointsPerGame = 24
    var history = History()
    var state = GameState(players: [])
}

/// Game has all the data that should be saved
class Game : ObservableObject {
    
    @Published var players: [Player] = [] {
        didSet {
            saveData.state.players = self.players.map { $0.encode() }
        }
    }
    
    public func addPlayer(player: Player) {
        players.append(player)
    }
    
    public var names : [String] {
        get {
            return players.map {$0.name}
        }
    }
    
    public func addToHistory(state: GameState) {
        saveData.history.states.append(state)
    }
    
    public func undo() {
        if let lastState = saveData.history.states.popLast() {
            saveData.state = lastState
        }
    }
    
    @Published var saveData : SaveData = SaveData() {
        didSet {
            // check if saveData has sensible information
            if saveData.state.players.count > 0 {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(saveData) {
                    UserDefaults.standard.set(encoded, forKey: SettingsVariables.saveData.rawValue)
                }
                print("saved data")
            }
        }
    }
    
    init() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: SettingsVariables.saveData.rawValue) {
            print("loading data found in UserDefaults...")
            if let decodedData = try? decoder.decode(SaveData.self, from: data) {
                self.saveData = decodedData
                self.players = decodedData.state.players.map { $0.object() }
            }
            print("data loaded")
            return
        } else {
            self.players = Default.names.map { Player(name: $0) }
            self.addToHistory(state: GameState(players: self.players.map {$0.encode()}))
        }
    }
}


