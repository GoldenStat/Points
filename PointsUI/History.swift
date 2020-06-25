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

    var playerNames: [String] { currentPlayers.map {$0.name} }
    var numOfPlayers: Int { currentPlayers.count }
    
    /// returns last Entry of game states
    var currentPlayers : [PlayerData] {
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
        if let lastState = states.last {
            if lastState != state {
                states.append(state)
            }
        } else {
            states.append(state)
        }
    }
    
    /// a computed var that transfers all history states into a list
    var flatScores : [Int] {
        var list = [Int]()
        
        for state in states {
            let points : [ Int ] = state.players.map({$0.score.value})
            list.append(contentsOf: points)
        }
        
        return list
    }
    
    var flatSums: [Int] {
        states.last?.scores.map { $0.value } ?? [Int].init(repeating: 0, count: numOfPlayers)
    }

    var risingScores: [Int] {
        var list = [Int]()
        var lastScore: [Int]?
        
        for state in states {
            let currentScore : [Int] = state.players.map({$0.score.value})
            if let lastScore = lastScore {
                var diffScore = [Int]()
                for index in 0 ..< lastScore.count {
                    diffScore.append(currentScore[index] - lastScore[index])
                }
                list.append(contentsOf: diffScore)
            } else {
                list.append(contentsOf: currentScore.map { $0 } )
            }
            lastScore = currentScore
        }
        
        return list
    }
}
