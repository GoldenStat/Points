//
//  HistoryDetailView.swift
//  PointsUI
//
//  Created by Alexander Völz on 24.11.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI


struct HistoryDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var settings : GameSettings
    
    var history : History {
        return settings.history
    }

    
    var body: some View {
        NavigationView {
            VStack {
                
                TabView {
                    ScoreTableView(settings: settings, viewMode: .total)
                        .tabItem({ Image(systemName: "circle") })
                    .tag(0)
                    ScoreTableView(settings: settings, viewMode: .diff)
                        .tabItem({ Image(systemName: "car") })
                    .tag(1)
                }
                
                Button("Dismiss") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationBarTitle(Text("Game History"))
            .navigationBarItems(trailing: Button("Undo") {
                self.history.undo()
            })
        }
    }
}


struct HistoryDetailView_Previews: PreviewProvider {
    //    static let names = [ "Alexander", "Lili", "Villa" ]
    //    static let players = Players(names: Self.names)
    static var settings = GameSettings()
    static let players = Self.settings.players
    static let names = Self.players.names
    
    static var history: History {
        get { Self.genHistory() }
    }
    
    static func genNewState(from state: GameState) -> GameState {
        var players: [PlayerData] = []
        for player in  state.players {
            let newPlayer = PlayerData(name: player.name, score: player.score + Int.random(in: 0...5))
            players.append(newPlayer)
        }
        return GameState(players: players)
    }
    
    static func genHistory() -> History {
        let history = settings.history
        var state = GameState(players: Self.players.data)
        for _ in 0 ..< 13 {
            state = genNewState(from: state)
            history.save(state: state)
        }
        return history
    }
    
    static var previews: some View {
        let settings = GameSettings()
        settings.history = genHistory()
        return HistoryDetailView(settings: settings)
    }
    
}
