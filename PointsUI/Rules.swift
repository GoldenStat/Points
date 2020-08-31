//
//  ReglasTrucoArgentino.swift
//  PointsUI
//
//  Created by Alexander Völz on 15.08.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct Rules {

    enum PlayerCount { case fixed(Int), selection([Int])} // maybe make this global enum
    enum PlayerUIType { case lines, numberBox, selectionBox }
    
    var name: String
    private(set) var maxPoints : Int?
    var players: PlayerCount
    var playerUI: PlayerUIType = .lines
    static let trucoArgentino = Rules(name: "Truco Argentino", maxPoints: 30, players: .selection([2,3,4,6]), playerUI: .lines)
    static let trucoVenezolano = Rules(name: "Truco Venezolano", maxPoints: 24, players: .selection([2,3,4,6]), playerUI: .lines)
    static let caida = Rules(name: "Caida", maxPoints: 24, players: .selection([2,3,4]), playerUI: .lines)
    static let doppelkopf = Rules(name: "Doppelkopf", players: .fixed(4), playerUI: .numberBox)
    static let skat = Rules(name: "Skat", players: .fixed(3), playerUI: .selectionBox)
    static let shitzu = Rules(name: "Shitzu", maxPoints: 1001, players: .fixed(4), playerUI: .selectionBox)
    static let romme = Rules(name: "Rommé", maxPoints: 1000, players: .selection([2,3,4,5,6]), playerUI: .numberBox)
    static let scopa = Rules(name: "Scopa", maxPoints: 15, players: .selection([2,3,4]), playerUI: .lines)

}


