//
//  HistoryTestView.swift
//  PointsUI
//
//  Created by Alexander Völz on 01.02.21.
//  Copyright © 2021 Alexander Völz. All rights reserved.
//

import SwiftUI

struct HistoryTestView: View {
    @ObservedObject var settings = GameSettings()
    var history : History { settings.history }
    var players : Players { settings.players }
    @ObservedObject var stateLogger: DebugLog = DebugLog()
    @ObservedObject var playerLogger: DebugLog = DebugLog()

    @State var showBuffers = false
    
    var body: some View {
        VStack {
            Button(showBuffers ? "Players Off" : "Players On") {
                showBuffers.toggle()
            }
            
            HStack {
                VStack {
                Button("Add Round") {
                    addRound()
                    saveRound()
//                    save()
                }
                Button("Save Round") { save() }
            }
                VStack {
                Button("Undo") { undo () }
                Button("Redo") { redo() }
                }
            }
            
            Divider()
            if showBuffers {
                PlayerBuffers(players: players)
                Divider()
            }
            
            /// rewrite History Body
            HistoryView(history: history, playerNames: players.names)

            if showLogs {
                Divider()
                VStack {
                    Section(header: Text("Player Log")) {
                        DebugView()
                    }
                    .environmentObject(playerLogger)
                    
                    Divider()
                        .border(Color.black, width: 40)
                    
                    Section(header: Text("State Log")) {
                        DebugView()
                            .environmentObject(stateLogger)
                    }
                }
                .frame(width: 600, height: 200)
            }
            
        }
        .environmentObject(settings)
        .buttonStyle(DefaultButtonStyle())
    }
    
    // MARK: - debug logging
    
    @State private var showLogs : Bool = false
    
    var playersDescription: String {
        players.items.map {$0.description}.joined(separator: " ")
    }
    
    var stateDescription: String {
        GameState(players: settings.players.data).description
    }
    
    // MARK: history functions
    func addRound() {
        /// adds a line to history with player's scores (as in first trigger - GameSettings.updatePoints())
        _ = settings.players.items.map { $0.add(score: Int.random(in: 0 ... 2)) }

        playerLogger.err(msg: playersDescription)
        stateLogger.err(msg: stateDescription)
        
    }
    
    func saveRound() {
        /// makes the round permament (as in GameSettings.updateRound())

        settings.players.saveScore() // saves players score
        
        let newState = GameState(players: settings.players.data)

        history.store(state: newState)
        settings.objectWillChange.send()
        settings.players.objectWillChange.send()

        playerLogger.log(msg: players.items.map {$0.description}.joined(separator: " "))
        stateLogger.log(msg: newState.description)
    }
    
    func undo() {
        /// undoes last history action (as in History.undo())
        history.undo()
    }
    
    func redo() {
        /// redoes last history action (as in History.redo())
        history.redo()
    }
    
    func save() {
        /// saves history states (as in History.save())
        history.save()
    }
}

struct PlayerBuffers: View {
    @ObservedObject var players: Players
    var items: [Player] { players.items }
    var body: some View {
        VStack {
            ForEach(items) { player in
                HStack {
                    Text(player.name)
                    Text("\(player.score.value)")
                    Text("\(player.score.buffer)")
                        .foregroundColor(.red)
                }
            }
        }
    }
}

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
                if debugBuffers {
                    ForEach(rowsInBuffer) { row in
                        row.rowView()
                    }
                    .foregroundColor(.gray)
                    
                    bufferHighestRow.rowView()
                        .foregroundColor(.red)
                }
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
    
}

extension View {
    func asGrid(columns: Int) -> some View {
        LazyVGrid(columns: Array<GridItem>(repeating: GridItem(), count: columns)) {
            self
        }
    }
}


struct HistoryTestView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryTestView()
    }
}
