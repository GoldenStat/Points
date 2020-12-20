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
    var description: String { value.description }
    var prefix: String { value > 0 ? "+"  : "" }
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
        Self.columns = scores.count
    }
    
    init(values: [Int]) {
        scores = values.map { CellData(value: $0) }
        Self.columns = values.count
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

/// store all Values for the table in another table
struct HistoryScoreTableData : Identifiable {
    var id = UUID()
    var data: [ScoreRowData] = []
    
    var buffer: ScoreRowData?
    
    
    init(from history: History) {
        // just convert history states into data
        // which should be the individual scores of that round?
        data = history.states.map { ScoreRowData(values: $0.scores) }
        
        if let historyBuffer = history.buffer {
            self.buffer = ScoreRowData(values: historyBuffer.scores)
        }
    }
    
    /// add up the score
    var incrementingData: [ ScoreRowData ] {
        var sums: [ScoreRowData] = []
        var previousScores: ScoreRowData?
        
        for row in data {
            if var buffer = previousScores, row.scores.count > 0 {
                buffer.changeRow(addValues: row.scores)
                previousScores = ScoreRowData(scores: buffer.scores)
                sums.append(buffer)
            } else {
                previousScores = ScoreRowData(scores: row.scores)
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
            SumButton(toggle: $showSums)
                .disabled(history.states.isEmpty)
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
                        
                        if let buffer = historyData.buffer {
                            LazyVGrid(columns: gridColumns) {
                                ForEach(buffer.scores) { score in
                                    Text(score.prefix + score.description)
                                }
                                .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    if showSums {
                        
                        BoldDivider()
                        
                        LazyVGrid(columns: gridColumns) {
                            ForEach(historyData.sumRow.scores) { score in
                                Text(score.value.description)
                                    .fontWeight(.bold)
                                    .foregroundColor(sumColor)
                            }
                        }
                        
                    }
                }
            }
            Spacer()
        }
        .foregroundColor(.text)
        .background(Color.boardbgColor)
        .padding(.bottom)
    }
    
    private var sumColor: Color {
        history.buffer != nil ?
            Color.pointbuffer :
            Color.text
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
                .foregroundColor(.text)
        }
        .padding()
        .background(Color.boardbgColor
                        .cornerRadius(20)
        )
        .padding()
    }
    
    private func addScoresToHistory() {
        
        let players = settings.players
        
        for player in players.items {
            let sampleScore = Int.random(in: -6 ... 6)
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
        GeometryReader { geo in
            ZStack {
                ScoreHistoryView()
        //            .frame(width: width,
        //                   height: height)
                    .emphasizeShape(cornerRadius: 16.0)
                    .frame(height: geo.size.height * 0.6)
                    .transition(.opacity)
                    .padding()
                SampleButton()
                    .position(x: geo.size.width / 4, y: 28)
            }
        }
    }
}

struct SumButton: View {
    
    @Binding var toggle: Bool
    
    var body: some View {
        
        HStack {
            Spacer()
            
            Button() {
                toggle.toggle()
            } label: {
                Image(systemName: "sum")
            }
        }
    }
}

struct ScoreHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistorySampleView()
            .padding()
            .environmentObject(GameSettings())
            .colorScheme(.dark)
    }
}
