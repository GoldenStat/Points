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

    @State var debugBuffers = false

    var playerNames : [String]
    var columns : Int { playerNames.count }
        

    enum HistoryMode {
        case perRow, total
    }
    
    var mode = HistoryMode.total
    
    var rowsInHistory: [ScoreRowData] {
        switch mode {
        case .perRow:
            return historyTable.differences
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
        table(for: history.buffer)
    }
    
    var rowsInBuffer: [ScoreRowData] {
        bufferTable.totals
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


    var body: some View {
        VStack {
            ScoreHistoryHeadline(uniqueItems: playerNames)

            Divider()

            Group {
                ForEach(rowsInHistory) { row in
                    row.rowView()
                }
                
                debugView(showBuffers: debugBuffers)
                
                if history.isBuffered {
                    bufferDifference.rowView()
                        .foregroundColor(.pointbuffer)
                }
            }
            .asGrid(columns: playerNames.count)

            BoldDivider()
            
            Group {
                if history.isBuffered {
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
    
    @ViewBuilder func debugView(showBuffers: Bool) -> some View {
        if debugBuffers {
            ForEach(rowsInBuffer) { row in
                row.rowView()
            }
            .foregroundColor(.gray)
            
            bufferHighestRow.rowView()
                .foregroundColor(.red)
        }
    }
    
}

extension View {
    func asGrid(columns: Int) -> some View {
        LazyVGrid(columns: Array<GridItem>(repeating: GridItem(), count: columns)) {
            self
        }
    }
}


struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(history: History(), playerNames: ["yo", "tu"])
    }
}

struct ScoreHistoryHeadline: View {
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
