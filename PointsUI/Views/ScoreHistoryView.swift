//
//  ScoreHistoryView.swift
//  PointsUI
//
//  Created by Alexander Völz on 28.08.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

extension Array where Element: StringExpressable {
    func stringElements() -> Array<String> {
        self.map { $0.description }
    }
}

struct CellData: Identifiable {
    var id = UUID()
    var value: Int
}

func += ( lhs: inout CellData, rhs: CellData) {
    lhs.value += rhs.value
}

func += ( lhs: inout CellData, rhs: Int) {
    lhs.value += rhs
}

/// store Values for the table in a row
/// being identifiable it's easier to use them in a ForEach
struct ScoreRowData : Identifiable {
    var id = UUID()
    var scores: [CellData] = []
    
    static var columns: Int = 4
    static var zero: ScoreRowData {
        ScoreRowData(scores: [CellData](repeating: CellData(value:0),
                                        count: Self.columns))
    }
    
    init(scores: [CellData]) {
        self.scores = scores
    }
    
    init(values: [Int]) {
        scores = values.map { CellData(value: $0) }
    }
    
    /// add values to this row
    mutating func changeRow(addValues values: [CellData]) {
        for index in 0 ..< scores.count {
            scores[index] += values[index]
        }
    }
}

/// store all Values for the table in another table
struct HistoryScoreTableData : Identifiable {
    var id = UUID()
    var data: [ScoreRowData] = []

    var buffer: ScoreRowData?

    init(from history: History) {
        for historyState in history.states {
            data.append(ScoreRowData(values: historyState.scores))
            ScoreRowData.columns = historyState.scores.count
        }
        
        if let historyBuffer = history.buffer {
            self.buffer = ScoreRowData(values: historyBuffer.scores)
        }
    }
    
    var incrementingData: [ ScoreRowData ] {
        var sums: [ScoreRowData] = []
        var previousScores: ScoreRowData?
        
        for row in data {
            if var buffer = previousScores {
                buffer.changeRow(addValues: row.scores)
                previousScores = buffer
                sums.append(buffer)
            } else {
                previousScores = row
                sums.append(row)
            }
        }
        return sums
    }
    
    var sumRow: ScoreRowData {
        incrementingData.last ?? ScoreRowData.zero
    }

}


func +<Element> (lhs: Array<Element>, rhs: Array<Element>) -> Array<Element> where Element: Numeric {
    guard lhs.count == rhs.count else { return lhs }
    var sum : Array<Element> = lhs
    for index in (0 ..< lhs.count) {
        sum[index] += rhs[index]
    }
    return sum
}

struct ScoreHistoryView: View {
    @EnvironmentObject var settings: GameSettings
    
    @State var showSums = false
    @State var showIndices = false

    private var header: [ String ] { settings.playerNames }
    private var numberOfColumns: Int { header.count }
    private var history: History { settings.history }
    
    private var sumLine: ScoreRowData {
        historyData.sumRow
    }
   
    private var gridColumns : [GridItem] { [GridItem](repeating: GridItem(), count: numberOfColumns) }
    
    var body: some View {
        VStack() {
            
            // Sum toggle button
            HStack {
                Spacer()
            
                Button() {
                    showSums.toggle()
                } label: {
                    Image(systemName: "sum")
                }
                .disabled(isHistoryEmpty)
            }
            .padding()

            // headline row
            LazyVGrid(columns: gridColumns) {
                ForEach(settings.playerNames, id: \.self) { name in
                    Text(name)
                }
            }
            
            Divider()
            
            if isHistoryEmpty {

                LazyVGrid(columns: gridColumns) {
                    ForEach(0 ..< numberOfColumns) { _ in
                        Text("0")
                    }
                }

            } else {
                
                
                ScrollView(.vertical) {
                    
                    // all scores
                    VStack {
                        ForEach(scoresForHistory) { dataRow in
                            
                            // one row of scores for one round
                            LazyVGrid(columns: gridColumns) {
                                ForEach(dataRow.scores) { score in
                                    Text(score.value.description)
                                }
                            }
                        }
                    }
                    
                    if showSums {
                        
                        BoldDivider()
                        
                        LazyVGrid(columns: gridColumns) {
                            ForEach(historyData.sumRow.scores) { score in
                                Text(score.value.description)
                                    .fontWeight(.bold)
                                    .foregroundColor(history.buffer == nil ? .black : .blue)
                            }
                        }
                        
                    } else if let buffer = historyData.buffer {

                        // Buffer Row
                        LazyVGrid(columns: gridColumns) {
                            ForEach(buffer.scores) { cellData in
                                if cellData.value > 0 {
                                    Text("+\(cellData.value)")
                                } else {
                                    // for negative numbers and 0
                                    Text("\(cellData.value)")
                                }
                            }
                            .foregroundColor(.gray)
                        }
                    }
                }
            }
            Spacer()
        }
        .padding(.bottom)
    }
    
    /// all states' scores that are recorded for every round
    private var simpleScores: [ ScoreRowData ] {
        var historyScores = history.states.map { $0.scores }
        if let buffer = history.buffer {
            historyScores.append(buffer.scores)
        }
        return historyScores.map { ScoreRowData(values: $0) }
    }
            
    private var historyData: HistoryScoreTableData {
        HistoryScoreTableData(from: settings.history)
    }
    
    private var scoresForHistory: [ ScoreRowData ] {
        showSums ? historyData.data : historyData.incrementingData
    }

    /// all Values in this Row are Zero
    private var zeroRow : ScoreRowData {
        ScoreRowData.zero
    }

    private var isHistoryEmpty: Bool { history.states.isEmpty && history.buffer == nil }
 

}


fileprivate struct BoldDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
    }
}

fileprivate struct SampleButton: View {
    @EnvironmentObject var settings: GameSettings
    var body: some View {
        Button() {
            addScoresToHistory()
        } label: {
            Text("Add New Round")
                .fontWeight(.bold)
        }
        .padding()
        .background(Color(red: 180/255, green: 180/255, blue: 200/255, opacity: 0.8)
                        .cornerRadius(20)
        )
        .padding()
    }
    
    private func addScoresToHistory() {
        
        let players = settings.players
        
        for player in players.items {
            let sampleScore = Int.random(in: 0 ... 6)
            print ("Adding score \(sampleScore) to Player <\(player.name)>")
            player.add(score: sampleScore)
            player.saveScore()
        }
        
        if settings.history.buffer != nil {
            settings.history.save()
        } else {
            settings.history.store(state: GameState(players: players.data))
        }
        settings.objectWillChange.send()
    }
}

fileprivate struct HistorySampleView : View {
    
    var body: some View {
        ZStack {
            SampleButton()
                .position(x: 200, y: 10)
            ScoreHistoryView()
        }
    }
}

struct ScoreHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistorySampleView()
            .padding()
            .environmentObject(GameSettings())
    }
}
