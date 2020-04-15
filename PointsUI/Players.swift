//
//  Players.swift
//  PointsUI
//
//  Created by Alexander Völz on 01.02.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation


struct PlayerData: Codable, Identifiable, Equatable {
    var id = UUID()
    var name: String
    var score: Score
    
}

class Player: ObservableObject {
    // name, points
//    var id = \Player.name // MARK: check whether we should exchange this with a counter to allow equal names
    var id = UUID()
    
    var name: String
    @Published var score: Score = 0
    @Published var tmpScore: Score = 0
    
    func saveScore() {
        if tmpScore>0 {
            score += tmpScore
            tmpScore = 0
        }
    }
    
    func add(score newScore: Score) {
        if newScore + tmpScore < GlobalSettings.scorePerGame {
            tmpScore += 1
        }
    }
    
    init(from data: PlayerData) {
        self.name = data.name
        self.score = data.score
    }
    
    init(name: String) {
        self.name = name
    }
    
    var data: PlayerData {
        PlayerData(name: name, score: score)
    }
    
}

/// the observable object to de- and encode the `Player` struct
class Players: ObservableObject {

    /// - Parameters:
    ///   - items: an array of <Player>-objects
    ///   - names: a convenience variable that returns only the names as strings from above array
    var items : [Player] = []
    var names: [String] { return items.map {$0.name} }
    var data: [PlayerData] { return items.map {$0.data} }
    
    func saveScore() {
        _ = items.map { $0.saveScore() }
    }
    
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

