//
//  PlayerGrid.swift
//  PointsUI
//
//  Created by Alexander Völz on 29.03.21.
//  Copyright © 2021 Alexander Völz. All rights reserved.
//

import Foundation
/// to make the code a little clearer
///
/// PlayerGrid(0,0).index == 0
///
/// PlayerGrid.rows == 2, PlayerGrid.cols == 2 means a 2x2-Grid

struct PlayerGrid {
    static let rows = 2
    static let cols = 2
    
    /// how many objects the Grid can hold
    static var maxObjects: Int { rows * cols }
    
    var row: Int
    var col: Int
    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
    
    // initialize row and col from index
    init(index: Int) {
        self.init(row: index / Self.cols,
                  col: index % Self.cols)
        // - Test Cases
        //
        // PlayerGrid(0,0) -> 0
        // PlayerGrid(0,1) -> 1
        // PlayerGrid(0,2) -> 2
        // PlayerGrid(1,0) -> 3 : Self.cols * 1 + 0
        // PlayerGrid(1,1) -> 4 : Self.cols * 1 + 1
        // PlayerGrid(2,0) -> 6 : Self.cols * 2 + 0
        // PlayerGrid[6] -> PlayerGrid(2,0) : 6 / 3 = (2), 6 % 3 = (0)
    }
    
    /// calculated index for this row and column
    var index: Int {
        get {
            row * Self.cols + col
        }
        
        // not really needed in this example, but since we are already at it...
        set {
            self = .init(index: newValue)
        }
    }
    
    static subscript(_ index: Int) -> PlayerGrid {
        PlayerGrid(index: index)
    }
    
}

import SwiftUI

extension PlayerGrid {
    
    /// if it's at the grid's border, return that edge, if not return nil
    /// prioritize vertical borders
    var tokenEdge: Edge.Set? {
        if row == 0 {
            return .top
        }
        if row == Self.rows - 1 {
            return .bottom
        }
        if col == 0 {
            return Edge.Set.leading
        }
        if col == Self.cols - 1{
            return Edge.Set.trailing
        }
        return nil
    }

}
