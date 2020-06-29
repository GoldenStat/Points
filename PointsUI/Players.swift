//
//  Players.swift
//  PointsUI
//
//  Created by Alexander Völz on 01.02.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation

/// Data representation of a player as a struct
struct PlayerData: Codable, Identifiable, Equatable {
    
    var id = UUID()
    var name: String
    var score: Score
    
    // when initializing a player his score has no buffer
    init(name: String, points: Int) {
        self.name = name
        self.score = Score(points)
    }
}

class Player: ObservableObject, Identifiable {

    var id = UUID()
    var name: String
    
    @Published var score = Score(0) // this is why this needs to be a class
    
    func saveScore() {
        score.save()
    }
    
    func add(score newScore: Int) {
        score.add(points: newScore)
    }

    // MARK: initializers and converters
    
    init(from data: PlayerData) {
        self.name = data.name
        self.score = data.score
    }
    
    init(name: String) {
        self.name = name
    }
    
    var data: PlayerData {
        PlayerData(name: name, points: score.value)
    }
    
}

/// the observable object to de- and encode the `Player` struct
class Players: ObservableObject {
    
    /// - Parameters:
    ///   - items: an array of <Player>-objects
    ///   - names: a convenience variable that returns only the names as strings from above array
    var items : [Player] = []
    
    /// TODO: implement Property wrappers to simplify this
    var names: [String] { items.map {$0.name} }
    var scores: [Score] { items.map {$0.score} }
    
    // MARK: conversion
    var data: [PlayerData] {
        get { items.map {$0.data} }
        set { // updates the players with the given data
            let maxIndex = Swift.min(names.count, newValue.count)
            for i in 0 ..< maxIndex {
                items[i].score = newValue[i].score
            }
        }
    }
    
    // MARK: update score for all players
    func saveScore() { _ = items.map { $0.score.save() } }
    
    subscript(index: Int) -> Player { items[index] }
    
    // MARK: convenience functions
    /// convenience initiallizer - replaces all players with new structs with new names
    /// - Parameters:
    ///   - names: each name must be unique
    convenience init(names: [String]) {
        self.init()
        for name in names {
            items.append(Player(name: name))
        }
    }
    
    /// convenience initiallizer - replaces all players with new structs with given players with their current score
    convenience init(players: [Player]) {
        self.init()
        items = players
    }
}

// MARK: Player equality functions 
func == (lhs: Player, rhs: Player) -> Bool {
    return lhs.name == rhs.name && lhs.score == rhs.score
}

func == (lhs: [Player], rhs: [Player]) -> Bool {
    guard lhs.count == rhs.count else { return false }
    for index in (0..<lhs.count) {
        if !(lhs[index] == rhs[index]) {
            return false
        }
    }
    return true
}
