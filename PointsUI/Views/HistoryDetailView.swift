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
    @State var settings : GameSettings
    
    var history : History {
        return settings.history
    }

    var body: some View {
        NavigationView {
            VStack {
                TabView {
                    BoardUI()
                        .tabItem({ Image(systemName: "rectangle.grid.2x2")})
                    .tag(0)
                    ScoreTableView(viewMode: .diff)
                        .tabItem({ Image(systemName: "table") })
                    .tag(1)
                    ScoreTableView(viewMode: .total)
                        .tabItem({ Image(systemName: "table.fill") })
                    .tag(2)
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
            let newScore = player.score.value + Int.random(in: 0...EdgeShape.numberOfEdges)
            let newPlayer = PlayerData(name: player.name, points: newScore)
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
