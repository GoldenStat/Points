//
//  History.swift
//  PointsUI
//
//  Created by Alexander Völz on 01.02.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation
import SwiftUI

/// a list of game States
/// used to record the progression of the entries
/// every state has the individual score of that round
/// e.g. History.states[0] is the first round, History.state[5] are the scores of round 5
class History : ObservableObject {
    
    // only varialbe, get all information from here
    @Published var states = [GameState]() {
        didSet {
            canUndo = states.count > 0
            canRedo = redoStack.count > 0
            self.objectWillChange.send()
        }
    }
    
    @Published var buffer: GameState?
    
    struct Sample {
        static let names = [ "Alexander", "Sebastian", "Lilibeth", "Villamizar" ]
        static var points : [[Int]] { names.map { _ in
            [ Int.random(in: 0...40),
              Int.random(in: 0...40),
              Int.random(in: 0...40),
              Int.random(in: 0...40) ]
        } }
    }
    
    var playerNames: [String]
    var numOfPlayers: Int { currentPlayers.count }
    
    init(names: [String]) {
        playerNames = names
    }
    
    var redoStack : [GameState] = []
    
    func reset() {
        states = []
    }
    
    /// returns last Entry of game states
    var currentPlayers : [PlayerData] {
        return playerNames.map { PlayerData(name: $0, points: 0, games: 0)}
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
    private func save(state: GameState) {
        if let lastState = states.last {
            if lastState != state // if it's a new state
            {
                redoStack = []
                states.append(state)
            }
        } else {
            redoStack = []
            states = [state]
        }
        objectWillChange.send()
    }
    
    /// add the buffer to the last state's scores
    /// reset the buffer
    func sumBufferToState() {
        guard let buffer = buffer else { return }
        if states.count > 0 {
            let lastState = states.removeLast()
            for index in 0 ..< lastState.scores.count {
                let sumState = GameState(buffer: [ lastState.scores[index] + buffer.scores[index] ] )
                states.append(sumState)
            }
        } else {
            states = [buffer]
            redoStack = []
        }
        self.buffer = nil
        objectWillChange.send()
    }
    
    func addBuffer() {
        if let buffer = buffer {
            if buffer != states.last {
                states.append(buffer)
            }
        }
        
        redoStack = []
        buffer = nil
        
        objectWillChange.send()
    }
    
    /// stores given state in buffer, temporarily
    /// if buffer is not empty, overwrite
    /// call save() to store in states
    func store(state: GameState) {
        buffer = state
    }
    
    /// save game state that was buffered, if any
    /// returns quietly if buffer is not set
    func save() {
        guard let buffer = buffer else { return }
        if let lastState = states.last {
            if lastState != buffer // if it's a new state
            {
                redoStack = []
                states.append(buffer)
            }
        } else {
            redoStack = []
            states = [buffer]
        }
        self.buffer = nil

        objectWillChange.send()
    }
    
    /// a computed var that transfers all history states into a list
    var flatScores : [Int] {
        var list = [Int]()
        
        for state in states {
            list.append(contentsOf: state.scores)
        }
        
        return list
    }
    
    var playerSumScores : [[ Int ]] {
        var scoresArray = [[Int]]()
        
        for state in states {
            let thisRoundScores = state.scores
            if let lastRoundScores = scoresArray.last {
                var newRow : [Int] = []
                for index in 0 ..< state.scores.count {
                    newRow.append(lastRoundScores[index] + state.scores[index])
                }
                scoresArray.append(newRow)
            } else {
                scoresArray.append(thisRoundScores)
            }
        }
        return scoresArray
    }
    
    var differentialScores : [[ Int ]] {
        return states.map { $0.scores }
    }
    
    var flatSums: [Int] {
        states.last?.scores.map { $0 } ?? [Int].init(repeating: 0, count: numOfPlayers)
    }

    var risingScores: [Int] {
        var list = [Int]()
        var lastScore: [Int]?
        
        for state in states {
            let currentScore : [Int] = state.scores
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

