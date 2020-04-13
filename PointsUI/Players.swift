//
//  Players.swift
//  PointsUI
//
//  Created by Alexander Völz on 01.02.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation


struct Player : Codable, Identifiable {
    // name, points
    var id = UUID()
    var name: String
    var score: Score = 0
}

/// the observable object to de- and encode the `Player` struct
class Players: ObservableObject {

    /// - Parameters:
    ///   - items: an array of <Player>-structs
    ///   - names: a convenience variable that returns only the names as strings from above array
    var items : [Player] = []
    var names: [String] { return items.map {$0.name} }
    
    /// convenience initiallizer - replaces all players with new structs with new names
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

