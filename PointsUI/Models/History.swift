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
    
    @Published var states = [GameState]()
    
    /// a buffer for the history for points that will be assigned, but aren't, yet
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
    
    @Published var redoStack : [GameState] = []
    
    func reset() {
        states = []
        redoStack = []
    }
    
    /// returns last Entry of game states
    var currentPlayers : [Player.Data] {
        return playerNames.map { Player(name: $0).data }
    }
        
    /// if the buffer has content, delete it
    /// if not, remove last step and append it to redoStack
    var canUndo: Bool { states.count > 0 }
    
    func undo() {
        guard canUndo else { return }
        if buffer !=  nil {
            // first invalidate the buffer (not redoable)
            buffer = nil
        } else {
            // only undo if buffer is empty
            // and there is something on the states stack
            redoStack.append(states.removeLast())
        }
    }
    
    /// append last step from redo Stack
    /// if there is no step to 'redo', ignore silently
    var canRedo: Bool { redoStack.count > 0 }
    func redo() {
        guard canRedo else { return }
        states.append(redoStack.removeLast())
    }

    /// clear the buffer
    /// use if actions get's interupted (e.g. we have some action stored, and we undo)
    func clearBuffer() {
        buffer = nil
    }
    
    /// stores given state in buffer, temporarily
    /// if buffer is not empty, overwrite
    /// call save() to store in states
    func store(state: GameState) {
        buffer = state
    }
     
    /// after using 'store' to put a game state into the buffer we can use this function
    /// to make the change permanent and add it to the history's states
    func save() {
        guard let buffer = buffer else { return }
        
        states.append(buffer)
        redoStack = []

        clearBuffer()
        
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

