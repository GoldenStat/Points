//
//  History.swift
//  PointsUI
//
//  Created by Alexander Völz on 01.02.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation

/// a list of game States
/// used to record the progression of the entries
class History : ObservableObject {
    @Published var states = [GameState]()
        
    /// returns last Entry of game states
    var currentPlayers : [Player] {
        if let lastState = states.last {
            return lastState.players
        }
        return []
    }
    
    /// go back one step, if there is one
    func undo() {
        guard states.count > 0 else { return }
        _ = states.removeLast()
    }

    /// add game state to the history
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
