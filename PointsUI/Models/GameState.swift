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
    var scores : [Int]
    
    var activePlayerIndex = 0
    
    init(players: [Player.Data]) {
        scores = players.map { $0.score.value }
    }
    
    init(buffer: [Int]?) {
        scores = buffer ?? []
    }
    
    
}

/// the difference between two states would be the difference of the scores between two states
func - (lhs: [Int], rhs: [Int]) -> [Int] {
    var diffScores = [Int]()
    
    /// only substract from what we have
    let minElements = min(rhs.count,lhs.count)
    for index in 0 ..< minElements {
        diffScores.append(lhs[index] - rhs[index])
    }
    if minElements < lhs.count {
        diffScores.append(contentsOf: lhs[minElements-1..<lhs.count-1])
    }
    return diffScores
}


func - (lhs: GameState, rhs: GameState) -> [Int] {
    return lhs.scores - rhs.scores
}
