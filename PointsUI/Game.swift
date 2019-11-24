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
}


/// GameState: a list of the current players and their scores
struct GameState : Codable, Identifiable {
    var id = UUID()
    var players : [Player]
}

/// a list of game States
class History : ObservableObject {
    @Published var states = [GameState]()
    
    func undo() {
        _ = states.dropLast()
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
