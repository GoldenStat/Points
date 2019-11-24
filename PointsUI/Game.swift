//
//  Game.swift
//  PointsUI
//
//  Created by Alexander Völz on 30.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//
import SwiftUI

struct Player : Codable, Identifiable {
    var id = UUID()
    var name: String
    var points: Int = 0
}

class Players: ObservableObject {
    @Published var items : [Player] = []
    var names: [String] { return items.map {$0.name} }
    
    convenience init(names: [String]) {
        self.init()
        for name in names {
            items.append(Player(name: name))
        }
    }
    
    convenience init(players: [Player]) {
        self.init()
        items = players
    }
}


/// GameState: a list of the current players and their scores
struct GameState : Codable, Identifiable {
    var id = UUID()
    var players : [Player]
}

func == (lhs: Player, rhs: Player) -> Bool {
    return lhs.name == rhs.name && lhs.points == rhs.points
}

func == (lhs: [Player], rhs: [Player]) -> Bool {
    guard lhs.count == rhs.count else { return false }
    for index in (0..<lhs.count) {
        if !(lhs[index] == rhs[index]) {
            return false
        }
    }
    return true
}

/// a list of game States
class History : ObservableObject {
    @Published var states = [GameState]()
    
    func undo() {
        guard states.count > 0 else { return }
        _ = states.removeLast()
    }
    
    var currentPlayers : [Player] {
        if let lastState = states.last {
            return lastState.players
        }
        return []
    }
    
    func save(state: GameState) {
        states.append(state)
    }
}

/// Default values
struct Default {
    static let names = [ "Alexander", "Lili", "Villa" ]
    static var maxGames = 3
    static var pointsPerGame = 24
}
