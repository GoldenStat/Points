//
//  ReglasTrucoArgentino.swift
//  PointsUI
//
//  Created by Alexander Völz on 15.08.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation

struct Rules {
    enum PlayerCount {
        case fixed(Int), selection([Int])
    }
    
    private(set) var maxPoints : Int?
    var players: PlayerCount
    
    static let trucoArgentino = Rules(maxPoints: 30, players: .selection([2,3,4,6]))
    static let trucoVenezolano = Rules(maxPoints: 24, players: .selection([2,3,4,6]))
    static let caida = Rules(maxPoints: 24, players: .selection([2,3,4]))
    static let doppelkopf = Rules(players: .fixed(4))
    static let skat = Rules(players: .fixed(3))
    static let shitzu = Rules(maxPoints: 1001, players: .fixed(4))
    static let romme = Rules(maxPoints: 1000, players: .selection([2,3,4,5,6]))
    static let scopa = Rules(maxPoints: 15, players: .selection([2,3,4]))
}


