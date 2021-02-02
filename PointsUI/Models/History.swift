//
//  History.swift
//  PointsUI
//
//  Created by Alexander Völz on 01.02.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

/// a list of game States
/// used to record the progression of the entries
/// every state has the individual score of that round
/// e.g. History.states[0] is the first round, History.state[4] are the scores of round 5
class History : ObservableObject {
    
    /// we need three versions for states and buffer :
    /// 1. current scores of every round (e.g. [0,0,0]->[2,1,0]->[3,8,2]
    /// 2. score changes of every round (e.g. [0,0,0]->[+2,+1,0]->[+1,+7,+2]
    /// 3. sum of scores
    
    /// stack of all game states that happened
    @Published private(set) var states : [GameState] = []
    
    /// stack of states we need to store temporary
    @Published private(set) var buffer : [GameState] = []
    
    /// last state might be buffered
    @Published private(set) var isBuffered: Bool = false
    
    var isEmpty: Bool { states.isEmpty && buffer.isEmpty }
    
    /// clear all memory, begin with a clean state
    public func reset() {
        states = []
        buffer = []
        isBuffered = false
    }
        
    /// stores given state in buffer, temporarily, same principle as with score
    /// overwrites buffer if not empty
    /// call save() to store in states
    public func store(state: GameState) {
        buffer = [state]
    }

    /// appends given state to buffer, temporarily, same principle as with score
    /// call save() to store in states
    
    public func append(state: GameState) {
        buffer.append(state)
    }

    /// adds given state to buffer, temporarily, same principle as with score
    /// call save() to store in states
    public func add(state newState: GameState) {
        if buffer.last != nil {
            let lastElement = buffer.removeLast()
            let combinedState = GameState(buffer: lastElement + newState)
            buffer.append(combinedState)
        } else {
            buffer.append(newState)
        }
    }
    
    public func mergeBuffer() {
        /// sums all buffer entries and merges them into one
        fatalError("not yet implemented")
    }

    /// if the buffer has content, delete it
    /// if not, remove last step and append it to redoStack
    public var canUndo: Bool { states.count > 0 }
    public var canRedo: Bool { buffer.count > 0 }
    
    public var maxUndoSteps: Int { states.count }
    public var maxRedoSteps: Int { buffer.count }
    
    /// removes the last state and puts it to the end of the buffer stack
    public func undo() {
        guard canUndo else { return }
        buffer.append(states.removeLast())
        isBuffered = false
    }
    
    /// append last step from redo Stack
    /// if there is no step to 'redo', ignore silently
    public func redo() {
        guard canRedo else { return }
        states.append(buffer.removeLast())
    }
    
    /// makes current changes permanent:
    /// deletes buffer - we don't have anything to redo, anymore
    public func save() {
        buffer = []
        isBuffered = false
    }
}

extension History {
    static var sample : History {
        let h = History()
    
        h.add(state: GameState(buffer: [1,0]))
        h.add(state: GameState(buffer: [2,3]))
        h.add(state: GameState(buffer: [1,4]))
        h.add(state: GameState(buffer: [1,0]))
        
        h.save()
        
        return h
    }
}
