//
//  ReglasTrucoArgentino.swift
//  PointsUI
//
//  Created by Alexander Völz on 15.08.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

enum PlayerCount : Hashable { case fixed(Int), selection([Int])} // maybe make this global enum
enum PlayerUIType : Hashable { case lines, numberBox, selectionBox }

struct Rule : Identifiable, Hashable {

    var id = UUID()
    
    var name: String
    private(set) var maxPoints : Int?
    var players: PlayerCount
    var playerUI: PlayerUIType = .lines
    
    static let trucoArgentino = Rule(name: "Truco Argentino", maxPoints: 30, players: .selection([2,3,4,6]), playerUI: .lines)
    static let trucoVenezolano = Rule(name: "Truco Venezolano", maxPoints: 24, players: .selection([2,3,4,6]), playerUI: .lines)
    static let caida = Rule(name: "Caida", maxPoints: 24, players: .selection([2,3,4]), playerUI: .lines)
    static let doppelkopf = Rule(name: "Doppelkopf", players: .fixed(4), playerUI: .numberBox)
    static let skat = Rule(name: "Skat", players: .fixed(3), playerUI: .selectionBox)
    static let shitzu = Rule(name: "Shitzu", maxPoints: 1001, players: .fixed(4), playerUI: .selectionBox)
    static let romme = Rule(name: "Rommé", maxPoints: 1000, players: .selection([2,3,4,5,6]), playerUI: .numberBox)
    static let scopa = Rule(name: "Scopa", maxPoints: 15, players: .selection([2,3,4]), playerUI: .lines)

}

extension Rule : StringExpressable {
    var description: String { name }
}

