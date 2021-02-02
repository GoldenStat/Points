//
//  HistoryScoresTable.swift
//  PointsUI
//
//  Created by Alexander Völz on 30.01.21.
//  Copyright © 2021 Alexander Völz. All rights reserved.
//

import Foundation

/// stores gameStates or ScoreRows and facitlitates output
/// * as sums
/// * differences
/// * zeroRow
/// * a flat list of Int by appending all rows onto each other
struct HistoryScoresTable {
    
    private var scoreRows: [ScoreRowData]
    
    init(columns: Int, states: [GameState]) {
        ScoreRowData.columns = columns
        self.scoreRows = states.map { ScoreRowData(from: $0) }
    }
    
    init(columns: Int, scores: [ScoreRowData]) {
        ScoreRowData.columns = columns
        self.scoreRows = scores
    }
    
    static var zero: ScoreRowData {
        ScoreRowData.zero
    }
    
    public var differences: [ScoreRowData] {
        
        guard let firstScoreRow = scoreRows.first else { return [.zero] }
        
        let remainingScoreRows = Array<ScoreRowData>(scoreRows.dropFirst())
        
        guard remainingScoreRows.count > 0 else { return [firstScoreRow] }
        
        var resultingScores: [ScoreRowData]
        
        // Overwrite scores, so we don't count 0-0-0
        resultingScores = [firstScoreRow]
        
        var lastScoreRow = firstScoreRow // initialize last State
        
        for scoreRow in remainingScoreRows {
            resultingScores.append(scoreRow - lastScoreRow)
            // remember this result
            lastScoreRow = scoreRow
        }
        
        return resultingScores
    }
    
    public var totals: [ScoreRowData] { scoreRows }
    public var sums: ScoreRowData { scoreRows.last ?? .zero }
    
    public var flat : [Int] {
        var flatList = [Int]()
        
        for scoreRow in scoreRows {
            flatList.append(contentsOf: scoreRow.values)
        }
        
        return flatList
    }
}
