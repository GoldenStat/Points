//
//  Game.swift
//  PointsUI
//
//  Created by Alexander Völz on 30.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//
import SwiftUI

typealias Score = Int

class GameSettings: ObservableObject {
    @Published var players = Players(names: Default.names)
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


/// Default values
struct Default {
    static let names = [ "Alexander", "Lili", "Villa", "Sebastian" ]
    static var maxGames = 3
    static var pointsPerGame = 24
}
