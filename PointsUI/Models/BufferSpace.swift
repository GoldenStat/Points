//
//  BufferSpace.swift
//  PointsUI
//
//  Created by Alexander Völz on 03.12.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

/// BufferSpace
///
/// in some playerUIs it makes sense to have copy the tmp-points from this round to another player as teams are dynamic
/// for this we use a separate Class: BufferSpace
class BufferSpace : ObservableObject {
    @Published var position: CGPoint // position in global coordinates
    @Published var points: Int // the actual amount we move around
    
    init(position: CGPoint, points: Int) {
        self.position = position
        self.points = points
    }
    
    @Published var wasDropped = false
}
