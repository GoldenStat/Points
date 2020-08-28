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
    @UserDefault(key: "UpdateTime", defaultValue: 3) static var updateTimeInterval: TimeInterval
    @UserDefault(key: "MaxGames", defaultValue: 3) static var maxGames: Int
    @UserDefault(key: "MaxScore", defaultValue: 24) static var scorePerGame: Int
    @UserDefault(key: "PlayerNumber", defaultValue: 2) static var chosenNumberOfPlayers: Int
    @UserDefault(key: "PlayerNames", defaultValue: [ "Nosotros", "Ustedes", "Ellos" ])
    static var playerNames : [String]

    static let trucoArgentino = Reglas(puntos: 30, manos: 3, jugadores: 2, annotacion: [.boxes, .table])
    static let trucoVenezolano = Reglas(puntos: 24, manos: 3, jugadores: 2, annotacion: [.splitBoxes, .table])
    static let doppelKopf = Reglas(puntos: 1000, manos: 100, jugadores: 4, annotacion: [])
}

extension Color {
    static let background  = Color("background")
    static let text  = Color("text")
    static let points  = Color("points")
    static let inactive  = Color("inactive")
    static let pointbuffer  = Color("buffer")
    static let pointsTop = Color("points-top")
    static let boardbgColor = Color.background
}

extension CGFloat {
    static let lineWidth : Self = 1.0
}

enum UpdateTimes : Int, CaseIterable, StringExpressable {
    static var saveTime = 20
    case short = 1, medium = 3, long = 5
    var double: Double { Double(rawValue) }
    var description: String {
        switch self {
        case .short: return "short"
        case .medium: return "medium"
        case .long: return "long"
        }
    }
    init(value: Double) {
        switch value.rounded() {
        case 1:
            self = .short
        case 3:
            self = .medium
        case 5:
            self = .long
        default:
            self = .medium
        }
    }
    init(value: Int) {
        self.init(value: Double(value))
    }
}
