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
                    save()
                }
//                Button("Save Round") { save() }
            }
                VStack {
                Button("Undo") { undo () }
                Button("Redo") { redo() }
                }
            }
            
            Divider()
            if showBuffers {
                PlayerBuffers(items: players.items)                
                Divider()
            }
            
            /// rewrite History Body
            HistoryView(history: history)

            if showLogs {
                Divider()
                VStack {
                    Section(header: Text("Player Log")) {
                        DebugView()
                    }
                    .environmentObject(playerLogger)
                    
                    Divider()
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 40)
                    
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
    var items: [Player]
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
    var columns : Int = 2
    
    var totals : [CellData] {
        /// need to make a copy so we have different data in the lazygrids
        HistoryScoresTable(columns: 2, states: history.states).sums.scores
    }

    var stateTotals: [ScoreRowData] {
        HistoryScoresTable(columns: columns, states: history.states).totals
    }
    
    var bufferTotals: [ScoreRowData] {
        HistoryScoresTable(columns: columns, states: history.buffer).totals
    }

    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem(), GridItem()]) {
                HistoryView_Head()
            }
            LazyVGrid(columns: [GridItem(), GridItem()]) {
                HistoryView_Body(scoreRows: stateTotals)
                HistoryView_Body(scoreRows: bufferTotals)
                    .foregroundColor(.gray)
                HistoryView_Body(scoreRows: [bufferTotals.last?.copy ?? .zero.copy])
                    .foregroundColor(.red)
            }
            BoldDivider()
            HistoryView_Tail(totals: totals)
        }
    }
}

struct HistoryView_Head: View {
    var names = [ "Yo", "Tu" ]
    var body: some View {
        ForEach(names, id: \.self) { name in
            Text(name)
        }
    }
}

struct HistoryView_Body: View {
    var scoreRows: [ScoreRowData]
    var body: some View {
        ForEach(scoreRows) { row in
            row.rowView()
        }
    }
}

struct HistoryView_Tail: View {
    var totals: [CellData]
    var body: some View {
        LazyVGrid(columns: [GridItem(), GridItem()]) {
            ForEach(totals) { data in
                Text(data.description)
            }
        }
    }
}

struct HistoryTestView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryTestView()
    }
}
