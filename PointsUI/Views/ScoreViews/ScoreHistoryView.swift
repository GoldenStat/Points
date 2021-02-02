//
//  ScoreHistoryView.swift
//  PointsUI
//
//  Created by Alexander Völz on 28.08.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI


struct ScoreHistoryView: View {
    @EnvironmentObject var settings: GameSettings
    
    @State var showSums = false
    
    private var header: [ String ] { settings.playerNames }
    private var numberOfColumns: Int { header.count }
    private var history: History { settings.history }
    
    private var gridColumns : [GridItem] { [GridItem](repeating: GridItem(), count: numberOfColumns) }
        
    // MARK: - score and buffer
    private var scoreBuffer: HistoryScoresTable {
        HistoryScoresTable(columns: numberOfColumns,
                           states: history.buffer) }
    private var buffer: [ ScoreRowData ] {
        !showSums ? scoreBuffer.totals : scoreBuffer.differences
    }

    private var scoreTable: HistoryScoresTable {
        HistoryScoresTable(columns: numberOfColumns,
                           states: history.states) }
    private var scores: [ ScoreRowData ] {
        !showSums ? scoreTable.totals : scoreTable.differences
    }
    
    private var bufferLine: ScoreRowData {
        scoreBuffer.sums - scoreTable.sums
    }
    
    @State var showBuffer: Bool = false

    // MARK: - sums
    private var sumLine: ScoreRowData { scoreTable.sums + scoreBuffer.sums }

    var body: some View {
        VStack() {
            
            // Sum toggle button
            SumButton(toggle: $showSums)
                .disabled(history.isEmpty)
                .padding()
            
            // headline row
            ScoreHistoryHeadline(playerNames: settings.playerNames)
            
            Divider()
            
            if history.isEmpty {
                
                LazyVGrid(columns: gridColumns) {
                    ForEach(0 ..< numberOfColumns) { _ in
                        Text("0")
                    }
                }
                
            } else {
                                
                ScrollView(.vertical) {
                    
                    // all scores
                    VStack {
                        
                        /// show the scores
                        ForEach(scores) { dataRow in
                            
                            // one row of scores for one round
                            // LazyVGrid(columns: gridColumns) {
                            HStack {
                                ForEach(dataRow.scores) {
                                    score in
                                    Text(score.description)
                                }
                            }
                        }
                        
                        
                        /// show the buffer - just for debugging
                        if showBuffer {
                            ForEach(buffer) { dataRow in
                                // one row of scores for one round
                                // LazyVGrid(columns: gridColumns) {
                                HStack {
                                    ForEach(dataRow.scores) { score in
                                        Text(score.description)
                                    }
                                    .foregroundColor(Color.red.opacity((0.6)))
                                }
                            }
                        }
                        
                        // show what would be added
                        if history.isBuffered {
                                // LazyVGrid(columns: gridColumns) {
                                HStack {
                                    ForEach(bufferLine.scores) { score in
                                        Text(score.prefix + score.description)
                                    }
                                    .foregroundColor(.gray)
                                
                            }
                        }
                    }
                    
                    if showSums {
                        
                        BoldDivider()
                        
//                        LazyVGrid(columns: gridColumns) {
                        HStack {
                            ForEach(sumLine.scores) { cellData in
                                Text(cellData.description)
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
        if history.buffer.isEmpty {
            return Color.text
        } else {
            return Color.pointbuffer
        }
    }
    
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
            }
        }
    }
    
    @EnvironmentObject var logger: DebugLog
    
    var history: History { settings.history }
    
    private func addScoresToHistory() {
        
        if history.isBuffered {
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
            
            history.add(state: newState)
        }
        
        settings.objectWillChange.send()
    }
}

struct HistoryDebugView : View {
    @EnvironmentObject var settings: GameSettings
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                HStack {
                    HistoryScoreGeneratorButton()
                    Button(action: { settings.history.undo()
                        settings.objectWillChange.send()
                    }, label: {
                        Image(systemName: "arrow.left")
                    })
                    Button(action: { settings.history.redo()
                        settings.objectWillChange.send()
                    }, label: {
                        Image(systemName: "arrow.right")
                    })
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

struct ScoreHistoryHeadline: View {

    let playerNames: [String]
    
    private var gridColumns : [GridItem] { [GridItem](repeating: GridItem(), count: playerNames.count) }

    var body: some View {
        LazyVGrid(columns: gridColumns) {
            ForEach(playerNames, id: \.self) { name in
                Text(name)
            }
        }
    }
}
