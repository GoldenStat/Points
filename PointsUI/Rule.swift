//
//  ReglasTrucoArgentino.swift
//  PointsUI
//
//  Created by Alexander Völz on 15.08.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

/// possible number of players for a game
/// can be:
/// - *fixed*: a fixed number of points the game has, can't be changed
/// - *selection*: there are fixed possibilities how far the game can go
enum PlayerCount : Hashable { case fixed(Int), selection([Int])}

/// possible points for a game
/// can be:
/// - *fixed*: a fixed number of points the game has, can't be changed
/// - *free*: any number can be set (probably changed using a textfield)
/// - *none*: the game is freestyle and won't end automatically
/// - *selection*: there are fixed possibilities how far the game can go

enum PointsSelection: Hashable { case fixed(Int), none, free(Int), selection( [Int]) }

enum PlayerUIType : Hashable { case lines, numberBox, selectionBox }

struct Rule : Identifiable, Hashable {

    var id: Int
    
    static var count = 0
    
    var name: String
    private(set) var maxPoints : PointsSelection
    var players: PlayerCount
    var playerUI: PlayerUIType = .lines
    
    static let trucoArgentino = Rule(name: "Truco Argentino", maxPoints: .selection([15,24,30]), players: .selection([2,3,4,6]), playerUI: .lines)
    static let trucoVenezolano = Rule(name: "Truco Venezolano", maxPoints: .fixed(24), players: .selection([2,3,4,6]), playerUI: .lines)
    static let caida = Rule(name: "Caida", maxPoints: .fixed(24), players: .selection([2,3,4]), playerUI: .lines)
    static let doppelkopf = Rule(name: "Doppelkopf", maxPoints: .none, players: .fixed(4), playerUI: .numberBox)
    static let skat = Rule(name: "Skat", maxPoints: .none, players: .fixed(3), playerUI: .selectionBox)
    static let shitzu = Rule(name: "Shitzu", maxPoints: .fixed(1001), players: .fixed(4), playerUI: .selectionBox)
    static let romme = Rule(name: "Rommé", maxPoints: .fixed(1000), players: .selection([2,3,4,5,6]), playerUI: .numberBox)
    static let scopa = Rule(name: "Scopa", maxPoints: .fixed(15), players: .selection([2,3,4]), playerUI: .lines)

    init(name: String, maxPoints: PointsSelection = .none, players: PlayerCount, playerUI: PlayerUIType) {
        self.id = Self.count
        Self.count += 1
        self.name = name
        self.maxPoints = maxPoints
        self.players = players
        self.playerUI = playerUI
    }
    
}

extension Rule : StringExpressable {
    var description: String { name }
}

