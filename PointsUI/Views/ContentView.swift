//
//  ContentView.swift
//  PointsUI
//
//  Created by Alexander Völz on 23.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var settings : GameSettings
    
    var players : Players {
        return settings.players
    }
    var history : History {
        get {
            return settings.history
        }
    }
    
    @State private var isPresented = false
    
    @State var historyTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    func resetTimer() {
        historyTimer.upstream.connect().cancel()
        historyTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    }
    
    let boardUI: BoardUI
    
    init() {
        let settings = GameSettings()
        self.settings = settings
        boardUI = BoardUI(settings: settings)
    }
    
    func triggerHistorySave() {
        // update all Views tmpPoints
        boardUI.saveScores()
        
        // send the history a signal that it should be saved
        history.save(state: GameState(players: players.items))
        //        historyTimer.upstream.connect().cancel()
    }
    
    func updatePoints() {
        for (index, player) in history.currentPlayers.enumerated() {
            players.items[index].score = player.score
        }
        
    }
    
    func undo() {
        history.undo()
        updatePoints()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.boardbgColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    boardUI
                        .navigationBarTitle(Text("Truco Venezolano").font(.caption))
                        .navigationBarItems(
                            leading: Button("History") {
                                self.isPresented.toggle()
                            },
                            trailing: HStack {
                                Button("Undo") {
                                    self.undo()
                                }
                                EditButton()
                        })
                        .sheet(isPresented: $isPresented) {
                            HistoryDetailView(settings: self.settings)
                    }
//                    .onReceive(self.historyTimer) { input in
//                        self.triggerHistorySave()
//                    }
                    Button("Save") {
                        self.triggerHistorySave()
                    }
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
