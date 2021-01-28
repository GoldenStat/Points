//
//  Score.swift
//  PointsUI
//
//  Created by Alexander Völz on 25.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation


/// game score - holds a players score, manipulation should only happen through internal functions
///
/// - value: holds the acutal points of the player at any given time
/// - buffer: a temporary storage
/// - sum: the total of value and buffer
/// - maxPoints: a value determined by the game that can not be exceeded by sum
///
/// methods:
///
/// add(points:) - stores the points to later be saved
///
/// save() - moves the buffer into permanent storage
///
/// reset(value:) - clears buffer, resets value if given
struct Score: Codable, Equatable {
    
    private(set) var value: Int
    private(set) var buffer: Int
    
    var sum: Int { value + buffer }
    
    var maxPoints: Int { GlobalSettings.scorePerGame }
    
    init(_ value: Int = 0, buffer: Int = 0) {
        self.value = value
        self.buffer = buffer
    }

    // add buffer to value if final value is below game total
    // clear buffer
    mutating func save() {
        value = min(sum,maxPoints)
        buffer = 0
    }
    
    mutating func add(points: Int = 1) {
        buffer += points
        buffer = min(maxPoints,buffer)
    }
    
    mutating func reset(_ newValue: Int? = nil) {
        if let newValue = newValue {
            value = newValue
        }
        buffer = 0
    }
}
