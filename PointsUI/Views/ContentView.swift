//
//  ContentView.swift
//  PointsUI
//
//  Created by Alexander Völz on 23.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var settings = GameSettings()
    
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
    
    func triggerHistorySave() {
        // send the history a signal that it should be saved
        players.saveScore()
        history.save(state: GameState(players: players.data))
        //        historyTimer.upstream.connect().cancel()
    }
    
    func undo() {
        history.undo()
    }
    
    var body: some View {
        //        NavigationView {
        ZStack {
            Color.boardbgColor
                .edgesIgnoringSafeArea(.all)
            //            VStack {
            VStack {
                TabView {
                    BoardUI(settings: $settings)
                        .tabItem({ Image(systemName: "rectangle.grid.2x2")})
                    .tag(0)
                    ScoreTableView(settings: $settings, viewMode: .diff)
                        .tabItem({ Image(systemName: "table") })
                    .tag(1)
                    ScoreTableView(settings: $settings, viewMode: .total)
                        .tabItem({ Image(systemName: "table.fill") })
                    .tag(2)
                }
            }
            .onReceive(self.historyTimer) { input in
                self.triggerHistorySave()
                    
                    //                        Button("Save") {
                    //                            self.triggerHistorySave()
                    //                        }
            }
            //            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
