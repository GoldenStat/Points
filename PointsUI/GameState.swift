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
        return lhs.players == rhs.players
    }
    
    var id = UUID()
    var players : [Player]
}
