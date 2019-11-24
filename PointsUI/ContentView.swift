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
    
    var historyTimer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    func saveHistory() {
        // save the history if something has changed
        // get last history step
        if let lastSaved = history.states.last {
            if !(lastSaved.players == players.items) {
                history.save(state: GameState(players: self.players.items))
            }
        } else {
            history.save(state: GameState(players: self.players.items))
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
                            self.history.undo()
                            print("%d steps saved", self.history.states.count)
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
