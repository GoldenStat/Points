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
enum PlayerCount : Hashable { case fixed(Int), selection([Int])
    /// maximum number of Points you can have, depending on which selection mechanism is used
    var maximumSelectable : Int {
        switch self {
        case .selection(let array):
            return array.count
        case .fixed(let number):
            return number
        }
    }
}

extension Int {
    static let highestGamePointsEverPossilbe = 1001
}

/// possible points for a game
/// can be:
/// - *fixed*: a fixed number of points the game has, can't be changed
/// - *free*: any number can be set (probably changed using a textfield)
/// - *none*: the game is freestyle and won't end automatically
/// - *selection*: there are fixed possibilities how far the game can go
enum PointsSelection: Hashable { case fixed(Int), none, free(Int), selection([Int])
    
    /// maximum number of Points you can have, depending on which selection mechanism is used
    var maximumSelectable : Int {
        switch self {
        case .selection(let array):
            return array.count
        case .fixed(let number):
            return number
        case .none:
            return Int.highestGamePointsEverPossilbe
        case .free(let value):
            return value
        }
    }
}

/// how many rounds should be counted
/// some games take a long time, so several rounds don't make sense, and maybe you want a fixed total
/// also, maybe you want to let the user choose for certain games
///
/// can be:
/// - *round*: a fixed number of points the game has, can't be changed
/// - *rounds*: the user can choose between options
/// - *one*: after one game the team with the most points wins.
/// - *win*: after how many wins (e.g. 2 (out of three))
/// - *wins*: let the user choose
enum GamesCount: Hashable { case round(Int), rounds([Int]), one, win(Int),  wins([Int]) }

/// selection for different playerUIs
///
/// can be:
/// - *checkbox(Int)*: draws lines in a checkbox form... sensible values are 4 (just the box), 5 (box with a line), 6 (box with an 'x')
/// - *numberBox*: a number that counts up (like a button)
/// - *selectionBox*: a number where you can select points - (tbd - could have a number array with points to select)
/// - *matches*: like counting with matches, five lines are drawn vertically and a fifth horizontally (tbd)
enum PlayerUIType : Hashable { case checkbox(Int), numberBox, selectionBox([Int]), matches }

struct Rule : Identifiable, Hashable {

    var id: Int
    
    static var count = 0
    
    var name: String
    private(set) var maxPoints : PointsSelection
    
    var players: PlayerCount
    var playerUI: PlayerUIType
    var rounds: GamesCount
    var maxPlayers: Int { players.maximumSelectable }
    static let trucoArgentino = Rule(name: "Truco Argentino",
                                     maxPoints: .selection([15,24,30]),
                                     players: .selection([2,3,4,6]),
                                     playerUI: .checkbox(5),
                                     rounds: .wins([3,5])
    )
    static let trucoVenezolano = Rule(name: "Truco Venezolano",
                                      maxPoints: .fixed(24),
                                      players: .selection([2,3,4,6]),
                                      playerUI: .checkbox(5),
                                      rounds: .wins([3,5])
    )
    static let caida = Rule(name: "Caida",
                            maxPoints: .fixed(24),
                            players: .selection([2,3,4]),
                            playerUI: .checkbox(5),
                            rounds: .rounds([3,5])
    )
    static let doppelkopf = Rule(name: "Doppelkopf",
                                 maxPoints: .none,
                                 players: .fixed(4),
                                 playerUI: .numberBox,
                                 rounds: .one
    )
    static let skat = Rule(name: "Skat",
                           maxPoints: .none,
                           players: .fixed(3),
                           playerUI: .selectionBox([9,10,11,12,23,24]), // selection with multiplier? keypad?
                           rounds: .one
    )
    static let shitzu = Rule(name: "Shitzu",
                             maxPoints: .fixed(1001),
                             players: .fixed(4),
                             playerUI: .selectionBox([-25,5,10,25]), // keypad?
                             rounds: .wins([1,2,3])
    )
    static let romme = Rule(name: "Rommé",
                            maxPoints: .fixed(1000),
                            players: .selection([2,3,4,5,6]),
                            playerUI: .numberBox,
                            rounds: .rounds([1,2,3,5])
    )
    static let scopa = Rule(name: "Scopa",
                            maxPoints: .fixed(15),
                            players: .selection([2,3,4]),
                            playerUI: .matches,
                            rounds: .wins([1,2,3,5])
    )

    init(name: String, maxPoints: PointsSelection = .none, players: PlayerCount, playerUI: PlayerUIType, rounds: GamesCount) {
        self.id = Self.count
        Self.count += 1
        self.name = name
        self.maxPoints = maxPoints
        self.players = players
        self.playerUI = playerUI
        self.rounds = rounds
    }
    
}

extension Rule : StringExpressable {
    var description: String { name }
}

