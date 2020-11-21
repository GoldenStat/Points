//
//  EdgeShapeSamples.swift
//  PointsUI
//
//  Created by Alexander Völz on 21.11.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

extension UnitPoint {
    static let boxA = UnitPoint(x: 0.0, y: 1.0)
    static let boxB = UnitPoint(x: 0.0, y: 0.0)
    static let boxC = UnitPoint(x: 1.0, y: 0.0)
    static let boxD = UnitPoint(x: 1.0, y: 1.0)

    static let houseA = UnitPoint(x: 0.0, y: 0.3)
    static let houseB = UnitPoint(x: 1.0, y: 0.3)
    static let houseC = UnitPoint(x: 0.0, y: 1.0)
    static let houseD = UnitPoint(x: 1.0, y: 1.0)
    static let houseE = UnitPoint(x: 0.5, y: 0.0)
}

struct EdgePoint {
    var start: UnitPoint
    var end: UnitPoint
}

struct EdgeShapeSample {
    
    var edges: [ EdgePoint ]

    static let box = EdgeShapeSample(edges: [
        EdgePoint(start: .boxA, end: .boxB),
        EdgePoint(start: .boxA, end: .boxD),
        EdgePoint(start: .boxB, end: .boxC),
        EdgePoint(start: .boxC, end: .boxD),
        EdgePoint(start: .boxA, end: .boxC),
        EdgePoint(start: .boxB, end: .boxD),
    ])
    
    
    var maxNumberOfEdges : Int { edges.count }
    
    // ...this one is bigger
    static let house = EdgeShapeSample(edges: [
        EdgePoint(start: .houseA, end: .houseC),
        EdgePoint(start: .houseA, end: .houseB),
        EdgePoint(start: .houseC, end: .houseD),
        EdgePoint(start: .houseD, end: .houseB),
        EdgePoint(start: .houseA, end: .houseE),
        EdgePoint(start: .houseE, end: .houseC),
        EdgePoint(start: .houseA, end: .houseD),
        EdgePoint(start: .houseB, end: .houseC)
    ])

    func numberOfEdges() -> Int { edges.count }
}
