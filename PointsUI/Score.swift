//
//  Score.swift
//  PointsUI
//
//  Created by Alexander Völz on 25.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation

struct Score: Codable, Equatable {
    
    var value: Int
    var tmp: Int
    
    var sum: Int { value + tmp }
    
    init(_ value: Int = 0, tmp: Int = 0) {
        self.value = value
        self.tmp = tmp
    }

    mutating func save() {
        guard tmp > 0, sum <= GlobalSettings.scorePerGame else { return }
        value += tmp
        tmp = 0
    }
    
    mutating func add(points: Int = 1) {
        tmp += points
    }
}
