//
//  ScoreRowData.swift
//  PointsUI
//
//  Created by Alexander Völz on 30.01.21.
//  Copyright © 2021 Alexander Völz. All rights reserved.
//

import Foundation


extension Array where Element: StringExpressable {
    func stringElements() -> Array<String> {
        self.map { $0.description }
    }
}

/// store Values for the table in a row
/// being identifiable it's easier to use them in a ForEach
struct ScoreRowData : Identifiable {
    var id = UUID()
    var scores: [CellData] = []
    var values: [Int] { scores.map {$0.value}}
    
    static var columns: Int = 4
    static var zero: ScoreRowData {
        ScoreRowData(scores: [CellData](repeating: CellData(value:0),
                                        count: Self.columns))
    }
    
    init(scores: [CellData]) {
        self.scores = scores
        Self.columns = scores.count
    }
    
    init(values: [Int]) {
        scores = values.map { CellData(value: $0) }
        Self.columns = values.count
    }
    
    init(from state: GameState) {
        scores = state.scores.map { CellData(value: $0) }
        Self.columns = state.scores.count
    }
    
    /// add values to this row
    mutating func changeRow(addValues values: [CellData]) {
        
        guard values.count == scores.count else {
            assertionFailure("Trying to add \(values.count) values to a row with \(scores.count) values")
            return
        }
        
        for index in 0 ..< values.count {
            scores[index] += values[index]
        }
    }
}

func - (lhs: ScoreRowData, rhs: ScoreRowData) -> ScoreRowData {
    ScoreRowData(values: lhs.values - rhs.values)
}

/// the difference between two states would be the difference of the scores between two states
func - (lhs: [Int], rhs: [Int]) -> [Int] {
    var diffScores = [Int]()
    
    /// only substract from what we have
    let minElements = min(rhs.count,lhs.count)
    for index in 0 ..< minElements {
        diffScores.append(lhs[index] - rhs[index])
    }
    if minElements < lhs.count {
        diffScores.append(contentsOf: lhs[minElements-1..<lhs.count-1])
    }
    return diffScores
}

func -= (lhs: inout [Int], rhs: [Int]) {
    lhs = lhs - rhs
}
