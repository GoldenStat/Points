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
    private var historyTable: HistoryScoresTable {
        HistoryScoresTable(columns: numberOfColumns,
                           states: history.states) }
    private var historyTableBuffer: HistoryScoresTable {
        HistoryScoresTable(columns: numberOfColumns,
                           states: history.buffer) }
    private var sumLine: ScoreRowData { historyTable.sums }
    
    private var gridColumns : [GridItem] { [GridItem](repeating: GridItem(), count: numberOfColumns) }
    
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
                        ForEach(scores) { dataRow in
                            
                            // one row of scores for one round
                            LazyVGrid(columns: gridColumns) {
                                ForEach(dataRow.scores) { score in
                                    Text(score.value.description)
                                }
                            }
                        }
                        
                        ForEach(buffer) { dataRow in
                            // one row of scores for one round
                            LazyVGrid(columns: gridColumns) {
                                ForEach(dataRow.scores) { score in
                                    Text(score.value.description)
                                }
                                .foregroundColor(Color.white.opacity((0.6)))
                            }
                        }
                        
                        if history.isBuffered {
                            ForEach(historyTableBuffer.totals + historyTable.totals) { scoreRow in
                                LazyVGrid(columns: gridColumns) {
                                    ForEach(scoreRow.scores) { score in
                                        Text(score.prefix + score.description)
                                    }
                                    .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    
                    if showSums {
                        
                        BoldDivider()
                        
                        LazyVGrid(columns: gridColumns) {
                            ForEach(historyTable.sums.scores) { score in
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
        if history.buffer.isEmpty {
            return Color.text
        } else {
            return Color.pointbuffer
        }
    }
        
    private var scores: [ ScoreRowData ] {
        showSums ? historyTable.totals : historyTable.differences
    }
    
    private var buffer: [ ScoreRowData ] {
        showSums ? historyTableBuffer.totals : historyTableBuffer.differences
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
