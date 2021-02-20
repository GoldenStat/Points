//
//  GameState.swift
//  PointsUI
//
//  Created by Alexander Völz on 01.02.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation

/// GameState: a list of the current players and their scores
/// every struct captures a moment in the game
struct GameState : Codable, Hashable, Identifiable, Equatable {
    
    static func == (lhs: GameState, rhs: GameState) -> Bool {
        return lhs.scores == rhs.scores
    }
    var id = UUID()
    private(set) var scores : [Int]
    // Note: add separated buffer? Might make things easier and easier to understand
    // at the moment we only use one Game state, and it requires some calculation to restore player's buffers
    
    var activePlayerIndex = 0
    
    init(players: [Player.Data]) {
        scores = players.map { $0.score.value }
    }
    
    /// initialize from an [Int]
    init(buffer: [Int]?) {
        scores = buffer ?? []
    }
    
    var description: String {
        "Scores: \(scores.map {String($0)}.joined(separator: "-"))"
    }
    
}


/// subtract gamestates
func - (lhs: GameState, rhs: GameState) -> [Int] {
    lhs.scores - rhs.scores
}

func + (lhs: GameState, rhs: GameState) -> [Int] {
    lhs.scores + rhs.scores
}

func + (lhs: GameState, rhs: [Int]?) -> GameState {
    if let rhs = rhs {
        return GameState(buffer: lhs.scores + rhs)
    } else {
        return lhs
    }
}
