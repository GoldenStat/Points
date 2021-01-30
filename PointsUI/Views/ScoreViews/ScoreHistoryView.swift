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
    
    init(state: GameState) {
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

/// store all Values for the table in another table
struct HistoryScoreTableData : Identifiable {
    var id = UUID()
    var data: [ScoreRowData] = []
    
    var buffer: ScoreRowData?
    
    init(from history: History) {
        // just convert history states into data
        // which should be the individual scores of that round?
        data = history.states.map { ScoreRowData(state: $0) }
        
        if let historyBuffer = history.buffer {
            self.buffer = ScoreRowData(state: historyBuffer)
        }
    }
    
    init(from state: GameState) {
        data = [ ScoreRowData(state: state) ]
    }

    init(from gameStates: [GameState]) {
        // just convert history states into data
        // which should be the individual scores of that round?
        data = gameStates.map { ScoreRowData(state: $0) }
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
    var showRedoStack = true
    
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
                        
                        if showRedoStack {
                            ForEach(scoreRedoStack) { dataRow in
                                
                                // one row of scores for one round
                                LazyVGrid(columns: gridColumns) {
                                    ForEach(dataRow.scores) { score in
                                        Text(score.value.description)
                                    }
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
        HistoryScoreTableData(from: history)
    }
    
    private var redoData: HistoryScoreTableData {
        HistoryScoreTableData(from: history.redoStack)
    }
    
    private var scoresForHistory: [ ScoreRowData ] {
        showSums ? historyData.data : historyData.incrementingData
    }
    
    private var scoreRedoStack: [ ScoreRowData ] {
        showSums ? redoData.data : redoData.incrementingData
    }
        
    func extractScores(from state: GameState) -> [Int] {
        state.scores
    }
    
    /// all Values in this Row are Zero
    private var zeroRow : ScoreRowData {
        ScoreRowData.zero
    }
    
    private var isHistoryEmpty: Bool { history.states.isEmpty && history.buffer == nil }
    
}


 struct BoldDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
    }
}

struct HistoryScoreGeneratorButton: View {
    @EnvironmentObject var settings: GameSettings
    
    var startScore: Int = 0
    var endScore: Int = 3
    
    var body: some View {
        HStack {
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
            .onAppear {
                addScoresToHistory()
                addScoresToHistory()
            }
        }
    }

    @State var playerDebugStorage: [[String]] = []
    
    @EnvironmentObject var logger: DebugLog
    
    var history: History { settings.history }
    private func addScoresToHistory() {
        
        if history.buffer != nil {
            history.save()
        } else {
            let players = settings.players
            
            var messages : [String] = []
            for player in players.items {
                let sampleScore = Int.random(in: startScore ... endScore)
                
                player.add(score: sampleScore)
                player.saveScore()
                
                messages.append(player.description)
            }

            logger.log(msg: messages.joined(separator: " | "))

            let newState = GameState(players: players.data)
            logger.log(msg: newState.description)
            history.store(state: newState)
        }
        
        settings.objectWillChange.send()
    }
}

struct HistoryDebugView : View {
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                HStack {
                    HistoryScoreGeneratorButton()
                    HistorySymbolRow()
                }
                ScoreHistoryView()
                    .emphasizeShape(cornerRadius: 16.0)
                    .transition(.opacity)
                    .padding()
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
        HistoryDebugView()
            .padding()
            .environmentObject(GameSettings())
            .environmentObject(DebugLog())
            .colorScheme(.dark)
    }
}
