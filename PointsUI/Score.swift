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
    var buffer: Int
    
    var sum: Int { value + buffer }
    
    init(_ value: Int = 0, buffer: Int = 0) {
        self.value = value
        self.buffer = buffer
    }

    mutating func save() {
        guard buffer > 0, sum <= GlobalSettings.scorePerGame else { return }
        value += buffer
        buffer = 0
    }
    
    mutating func add(points: Int = 1) {
        buffer += points
    }
}
