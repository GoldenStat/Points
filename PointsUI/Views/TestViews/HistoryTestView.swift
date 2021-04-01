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
        GameState(players: players.data).description
    }
    
    // MARK: history functions
    func addRound() {
        /// adds a line to history with player's scores (as in first trigger - GameSettings.updatePoints())
        _ = players.items.map { $0.add(score: Int.random(in: 0 ... 2)) }

        playerLogger.err(msg: playersDescription)
        stateLogger.err(msg: stateDescription)
        
    }
    
    func saveRound() {
        /// makes the round permament (as in GameSettings.updateRound())

        players.saveScores() // saves players score
        
        let newState = GameState(players: players.data)

        history.store(state: newState)
        settings.objectWillChange.send()
        players.objectWillChange.send()

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

struct HistoryTestView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryTestView()
    }
}
