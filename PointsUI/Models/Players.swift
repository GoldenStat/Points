//
//  Players.swift
//  PointsUI
//
//  Created by Alexander Völz on 01.02.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI


// MARK: - single Player
func == (lhs: Player?, rhs: Player?) -> Bool {
    guard let lhs = lhs, let rhs = rhs else { return false }
    return lhs.id == rhs.id
}

class Player: ObservableObject, Identifiable, Equatable {

    let id = UUID()
    @Namespace var nspace
    @Published var name: String
    @Published var games: Int = 0
    @Published var score = Score(0)
    
    func saveScore() {
        score.save()
    }
        
    var description : String { "\(name): (\(score.value)/\(score.buffer))" }
    
    func add(score newScore: Int) {
        score.add(points: newScore)
    }
    
    // MARK: initializers and converters
    
    init(from data: Data) {
        self.name = data.name
        self.score = data.score
        self.games = data.gamesWon
    }
    
    init(name: String) {
        self.name = name
    }
    
    struct Data {
        var name: String
        var score: Score
        var gamesWon: Int
        
        // when initializing a player his score has no buffer
        init(name: String, score: Score = Score(0), games: Int = 0) {
            self.name = name
            self.score = Score(score.value)
            self.gamesWon = games
        }
    }
    
    var data: Data {
        Data(name: name, score: score, games: games)
    }
    
}

// MARK: - Players - a collection of players
/// the observable object to de- and encode the `Player` struct
class Players: ObservableObject {
    
    /// - Parameters:
    ///   - items: an array of <Player>-objects
    ///   - names: a convenience variable that returns only the names as strings from above array
    @Published var items : [Player] = []
    
    var count: Int { items.count }
    
    static var sample = Players(names: ["Alexander", "Lili"])
    
    func add(name: String) {
        let player = Player(name: name)
        items.append(player)
        objectWillChange.send()
        player.objectWillChange.send()
    }

    func remove(name: String) -> Player? {
        var removedPlayer: Player?
        if let firstIndex = items.firstIndex(where: {$0.name == name} ) {
            let set = IndexSet(integer: firstIndex)
            removedPlayer = items[firstIndex]
            items.remove(atOffsets: set)
            removedPlayer?.objectWillChange.send()
        }
        objectWillChange.send()
        return removedPlayer
    }
    
    func removeLast() -> Player {
        let oldPlayer = items.removeLast()
        objectWillChange.send()
        return oldPlayer
    }
    
    /// TODO: implement Property wrappers to simplify this
    var names: [String] { items.map {$0.name} }
    var scores: [Score] { items.map {$0.score} }
    
    // MARK: conversion
    var data: [Player.Data] {
        get { items.map {$0.data} }
        set { // updates the players with the given data
            items = newValue.map { Player(from: $0)}
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
    
    public func clearBuffers() -> Bool {
        let playersWithBuffer = items.filter { $0.score.buffer > 0 }
        _ = playersWithBuffer.map { $0.score.reset() }
        return playersWithBuffer.count > 0
    }
    
    /// convenience initiallizer - replaces all players with new structs with given players with their current score
    convenience init(players: [Player]) {
        self.init()
        items = players
    }
    
    // set the scores to match a game state
    func setScores(to values: [Int]) {
        guard items.count == values.count else { fatalError("saved state doesn't match players count") }
        
        for (player, newValue) in zip(items, values) {
            player.score.reset(newValue)
        }
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
