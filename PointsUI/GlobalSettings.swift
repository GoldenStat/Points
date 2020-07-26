//
//  Game.swift
//  PointsUI
//
//  Created by Alexander Völz on 30.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//
import SwiftUI

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
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
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
    @UserDefault(key: "UpdateTime", defaultValue: 5) static var updateTime: TimeInterval
    @UserDefault(key: "MaxGames", defaultValue: 3) static var maxGames: Int
    @UserDefault(key: "MaxScore", defaultValue: 24) static var scorePerGame: Int
    @UserDefault(key: "PlayerNumber", defaultValue: 2) static var chosenNumberOfPlayers: Int
    @UserDefault(key: "PlayerNames", defaultValue: [ "Nosotros", "Ustedes", "Ellos" ])
    static var playerNames : [String]

}

extension Color {
    static let background  = Color("background")
    static let text  = Color("text")
//    static let points  = Color("points").accentColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
    static let points = Color.accentColor
    static let inactive  = Color("inactive")
    static let pointbuffer  = Color("buffer")
}
