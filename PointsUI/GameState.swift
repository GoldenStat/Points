//
//  GameState.swift
//  PointsUI
//
//  Created by Alexander Völz on 01.02.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation

/// GameState: a list of the current players and their scores
struct GameState : Codable, Identifiable, Equatable {
    static func == (lhs: GameState, rhs: GameState) -> Bool {
        return lhs.scores == rhs.scores
    }
    
    var id = UUID()
    var players : [PlayerData] // TODO: is players needed in the game state?
    var scores : [Score]
    
    init(players: [PlayerData]) {
        self.players = players
        self.scores = players.map { $0.score }
    }
    
}
