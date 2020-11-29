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
        redoStack = []
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

