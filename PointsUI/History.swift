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
    
    // only varialbe, get all information from here
    @Published var states = [GameState]() {
        didSet {
            canUndo = states.count > 0
            canRedo = redoStack.count > 0
        }
    }

    var playerNames: [String] { currentPlayers.map {$0.name} }
    var numOfPlayers: Int { currentPlayers.count }

    var redoStack : [GameState] = []
    
    func reset() {
        states = []
    }
    
    /// returns last Entry of game states
    var currentPlayers : [PlayerData] {
        if let lastState = states.last {
            return lastState.players
        }
        return []
    }
        
    /// go back one step, if there is one
    @Published var canUndo: Bool = false
    func undo() {
        guard canUndo else { return }
        redoStack.append(states.removeLast())
        canRedo = true
    }
    
    @Published var canRedo: Bool = false
    func redo() {
        guard canRedo else { return }
        states.append(redoStack.removeLast())
    }

    /// add game state to the history
    /// only save if the state is different from the last saved state
    func save(state: GameState) {
        if let lastState = states.last {
            if lastState != state {
                redoStack = []
                states.append(state)
            }
        } else {
            redoStack = []
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
