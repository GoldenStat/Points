//
//  Game.swift
//  PointsUI
//
//  Created by Alexander Völz on 30.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//
import SwiftUI

typealias Score = Int


/// UserDefault property wrapper:
/// define a default, and store the variable in UserDefaults whenever it is set
///
/// example:
///
///     enum GlobalSettings {
///         @UserDefault(key: "MaxGames", defaultValue: 3) static var maxGames: Int
///     }
///
@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

/// all our default values stored in UserDefaults as enum
///
/// - Parameters
/// - Parameter maxGames: how many games does a player have to win
/// - scorePerGame: how much can a player score before he wins a game
/// - playerNames: Who is playing
///
enum GlobalSettings {
    @UserDefault(key: "MaxGames", defaultValue: 3) static var maxGames: Int
    @UserDefault(key: "MaxScore", defaultValue: 24) static var scorePerGame: Int
    @UserDefault(key: "PlayerNames", defaultValue: [ "Alexander", "Lili", "Villa", "Sebastian" ])
        static var playerNames: [ String ]
}

class GameSettings: ObservableObject {
    @Published var players = Players(names: GlobalSettings.playerNames)
    @Published var history = History()
}

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
