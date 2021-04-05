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
    @Published private(set) var savePendingBuffer : GameState?
    var needsSaving : Bool { savePendingBuffer != nil }
    @Published private(set) var undoBuffer: [GameState] = []

    /// the first state in the undo buffer containts our former total
    public var storedTotal : GameState? { undoBuffer.first ?? savePendingBuffer }
    
    /// what scores should our players get if we redo all steps (total scores - current game state)
    public var redoScores: [ Score ]? {
        // subtracts first undoBuffer or last state pending from current state
        if let total = storedTotal?.scores {
            if let values = currentGameState?.scores {
                return zip(values, total - values).map { Score($0, buffer: $1) }
            } else {
                return total.map { Score(0,buffer: $0) }
            }
        } else {
            if let values = currentGameState?.scores {
                return values.map { Score($0) }
            } else {
                return nil
            }
        }
    }
    
    /// what scores should our players get if we redo all steps (total scores - current game state)
    public var tmpScores: [ Score ]? {
        // subtracts first undoBuffer or last state pending from current state
        if let total = savePendingBuffer?.scores {
            if let values = currentGameState?.scores {
                return zip(values, total - values).map { Score($0, buffer: $1) }
            } else {
                return total.map { Score(0,buffer: $0) }
            }
        } else {
            if let values = currentGameState?.scores {
                return values.map { Score($0) }
            } else {
                return nil
            }
        }
    }

    /// the last state in our states stack reflects the current game state
    public var currentGameState: GameState? { states.last }

    var isEmpty: Bool { states.isEmpty && savePendingBuffer != nil && undoBuffer.isEmpty }
    
    /// clear all memory, begin with a clean state
    public func reset() {
        states = []
        savePendingBuffer = nil
        undoBuffer = []
    }
        
    /// stores given state in buffer, temporarily, same principle as with score
    /// overwrites buffer if not empty
    /// call save() to store in states
    public func store(state: GameState) {
        savePendingBuffer = state
    }

    /// appends given state to buffer, temporarily, same principle as with score
    /// call save() to store in states
    
    public func appendBuffer(state: GameState) {
        undoBuffer.append(state)
    }

    /// adds given state to buffer, temporarily, same principle as with score
    /// call save() to store in states
    public func add(state newState: GameState) {
        if let buffer = savePendingBuffer {
            savePendingBuffer = buffer + newState.scores
        } else {
            savePendingBuffer = newState
        }
    }
    
    public func mergeBuffer() {
        /// sums all buffer entries and merges them into one
        /// don't think we need this
        fatalError("not yet implemented")
    }

    /// if the buffer has content, delete it
    /// if not, remove last step and append it to redoStack
    public var canUndo: Bool { states.count > 0 }
    public var canRedo: Bool { undoBuffer.count > 0 }
    
    public var maxUndoSteps: Int { states.count }
    public var maxRedoSteps: Int { undoBuffer.count }
    
    /// removes the last state and puts it to the end of the buffer stack
    public func undo() {
        guard states.count > 0 else { return }
        undoBuffer.append(states.removeLast())
    }
    
    // erase whatever is in the buffer
    public func clearBuffer() {
        undoBuffer = []
    }
    
    /// append last step from redo Stack
    /// if there is no step to 'redo', ignore silently
    public func redo() {
        guard undoBuffer.count > 0  else { return }
        states.append(undoBuffer.removeLast())
    }
    
    /// makes current changes permanent:
    /// saves the buffer if it's not from an undo operation (we know that from the isBuffered value)
    /// deletes buffer - we don't have anything to redo, anymore
    public func save() {
        if let buffer = savePendingBuffer {
            states.append(buffer)
            savePendingBuffer = nil
        }
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
