//
//  Players.swift
//  PointsUI
//
//  Created by Alexander Völz on 01.02.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation


class Players: ObservableObject {
    var items : [Player] = []
    var names: [String] { return items.map {$0.name} }
        
    convenience init(names: [String]) {
        self.init()
        for name in names {
            items.append(Player(name: name))
        }
    }
    
    convenience init(players: [Player]) {
        self.init()
        items = players
    }
}

