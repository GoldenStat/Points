//
//  Player.swift
//  PointsUI
//
//  Created by Alexander Völz on 01.02.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation

struct Player : Codable, Identifiable {
    var id = UUID()
    var name: String
    var points: Score = 0
}
