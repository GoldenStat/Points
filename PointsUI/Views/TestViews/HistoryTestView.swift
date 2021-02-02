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

    var body: some View {
        VStack {
            HStack {
                Button("Add") { addRound() }
                Button("Save") { saveRound() }
                Button("Undo") { undo () }
                Button("Redo") { redo() }
                Button("History") { save() }
            }
            
            Divider()
            
            VStack {
                ForEach(players.items) { player in
                    HStack {
                        Text(player.name)
                        Text("\(player.score.value)")
                        Text("\(player.score.buffer)")
                            .foregroundColor(.red)
                    }
                }
            }
            
            Divider()
            
            ScoreHistoryView()

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
        
    }
    
    @State private var showLogs : Bool = false
    
    var playersDescription: String {
        players.items.map {$0.description}.joined(separator: " ")
    }
    
    var stateDescription: String {
        GameState(players: settings.players.data).description
    }
    
    func addRound() {
        /// adds a line to history with player's scores (as in first trigger - GameSettings.updatePoints())
        _ = settings.players.items.map { $0.add(score: Int.random(in: 0 ... 2)) }

        playerLogger.err(msg: playersDescription)
        stateLogger.err(msg: stateDescription)

        settings.objectWillChange.send()
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
        settings.objectWillChange.send()

    }
    
    func redo() {
        /// redoes last history action (as in History.redo())
        history.redo()
        settings.objectWillChange.send()

    }
    
    func save() {
        /// saves history states (as in History.save())
        history.save()
        settings.objectWillChange.send()
    }
}

struct HistoryTestView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryTestView()
    }
}
