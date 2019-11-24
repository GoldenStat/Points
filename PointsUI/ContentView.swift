//
//  ContentView.swift
//  PointsUI
//
//  Created by Alexander Völz on 23.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var players = Players(names: Default.names)
    @ObservedObject var history = History()
    
    
    @State private var isPresented = false
    
    @State var historyTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @State var timerHasFired = false
    
    func saveHistory() {
        // save the history if something has changed
        // get last history step
        if let lastSaved = history.states.last {
            if !(lastSaved.players == players.items) {
                if (!timerHasFired) {
                    self.timerHasFired = true
                    _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) {_ in
                        self.saveHistory()
                    }
                } else {
                    history.save(state: GameState(players: self.players.items))
                    self.timerHasFired = false
                }
            }
        } else {
            history.save(state: GameState(players: self.players.items))
        }
    }
    
    func undo() {
        history.undo()
        for (index, player) in history.currentPlayers.enumerated() {
            players.items[index].points = player.points
        }
    }
    
    var body: some View {
        NavigationView {
            BoardUI(players: players, history: history)
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
                    HistoryDetailView(history: self.history, players: self.players)
            }
            .onReceive(self.historyTimer) { input in
                self.saveHistory()
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
