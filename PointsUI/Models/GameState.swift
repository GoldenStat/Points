//
//  GameState.swift
//  PointsUI
//
//  Created by Alexander Völz on 01.02.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation

/// GameState: a list of the current players and their scores
struct GameState : Codable, Hashable, Identifiable, Equatable {
    
    static func == (lhs: GameState, rhs: GameState) -> Bool {
        return lhs.scores == rhs.scores
    }
    
    var id = UUID()
    var scores : [Int]
    
    var activePlayerIndex = 0
    
    init(players: [Player.Data]) {
        scores = players.map { $0.score.value }
    }
    
    init(buffer: [Int]?) {
        scores = buffer ?? []
    }
    
    
}
