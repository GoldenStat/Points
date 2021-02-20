//
//  HistoryView.swift
//  PointsUI
//
//  Created by Alexander Völz on 08.02.21.
//  Copyright © 2021 Alexander Völz. All rights reserved.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var history: History

    var playerNames : [String]
    var columns : Int { playerNames.count }

    /// variable to show the buffer. In undo-operations, for instance
    var showHistoryBuffer = false

    // MARK: many variables...
    // TODO: see if this can be refactored in model
    
    enum Mode {
        case perRow, total
    }
    
    var mode : Mode = .total
    
    var rowsInHistory: [ScoreRowData] {
        switch mode {
        case .perRow:
            return historyTable.differences.map {$0.copy}
        case .total:
            return historyTable.totals
        }
    }
    
    var historyTable : HistoryScoresTable {
        table(for: history.states)
    }
    
    func table(for states: [GameState]) -> HistoryScoresTable {
        HistoryScoresTable(columns: columns,
                           states: states)
    }
    
    var bufferTable : HistoryScoresTable {
        table(for: history.undoBuffer)
    }
    
    var rowsInBuffer: [ScoreRowData] {
        switch mode {
        case .perRow:
            return bufferTable.differences.map {$0.copy}
        case .total:
            return bufferTable.totals
        }

    }
  
    var totalsRow : ScoreRowData {
        historyTable.sums
    }

    var bufferHighestRow: ScoreRowData {
        rowsInBuffer.first?.copy ?? .zero.copy
    }

    var bufferDifference: ScoreRowData {
        bufferHighestRow - totalsRow
    }

    // MARK: view body

    var body: some View {
        VStack {
            
            // show the player names
            ScoreHistoryHeadline(uniqueItems: playerNames)

            Divider()

             Group {
                ForEach(rowsInHistory) { row in
                    row.rowView()
                }
                
                bufferView(showBuffers: showHistoryBuffer)
                
                if !history.undoBuffer.isEmpty {
                    bufferDifference.rowView()
                        .foregroundColor(.pointbuffer)
                }
            }
            .asGrid(columns: playerNames.count)

            // show results if we show addition
            if mode == .perRow {
                BoldDivider()
                
                Group {
                    if !history.undoBuffer.isEmpty {
                        (totalsRow + bufferDifference)
                            .rowView()
                            .foregroundColor(.gray)
                    } else {
                        totalsRow.rowView()
                    }
                }
                .asGrid(columns: columns)
            }
        }
    }
    
    @ViewBuilder func bufferView(showBuffers: Bool) -> some View {
        if showHistoryBuffer {
            ForEach(rowsInBuffer.reversed()) { row in
                row.rowView()
            }
            .opacity(0.3)
            
//            bufferHighestRow.rowView()
//                .foregroundColor(.red)
        }
    }
    
}

fileprivate struct ScoreHistoryHeadline: View {
    let uniqueItems: [String]
    
    private var gridColumns : [GridItem] { [GridItem](repeating: GridItem(), count: uniqueItems.count) }
    
    var body: some View {
        LazyVGrid(columns: gridColumns) {
            ForEach(uniqueItems, id: \.self) { name in
                Text(name)
            }
        }
    }
}


// - MARK: view extensions ScoreRowData.rowView and View.asGrid

/// row Data extension for refactoring
extension ScoreRowData {
    @ViewBuilder func rowView(showPrefix: Bool = false) -> some View {
        ForEach(self.scores) { cellData in
            Text(cellData.description)
        }
    }
}

/// grid display for a view, for better comparmentilization
extension View {
    func asGrid(columns: Int) -> some View {
        LazyVGrid(columns: Array<GridItem>(repeating: GridItem(), count: columns)) {
            self
        }
    }
}


// MARK: - preview
struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(history: History(), playerNames: ["yo", "tu"])
    }
}
