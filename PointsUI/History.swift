//
//  History.swift
//  PointsUI
//
//  Created by Alexander Völz on 01.02.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation

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
    
    /// only save if the state is different from the last saved state
    func save(state: GameState) {
        if let lastSaved = states.last {
            if lastSaved != state {
                states.append(state)
                return
            }
        }
        states.append(state)
    }
}
