//
//  HistoryDetailView.swift
//  PointsUI
//
//  Created by Alexander Völz on 24.11.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct HistoryDetailView: View {
    @ObservedObject var settings : GameSettings
    
    var players : Players {
        return settings.players
    }
    
    var history : History {
        return settings.history
    }
    
    /// a computed var that transfers all history states into a list
    var flatHistoryPoints : [Int] {
        var list = [Int]()
        for state in history.states {
            let points : [ Int ] = state.players.map({$0.score})
            list.append(contentsOf: points)
        }
        return list
    }
    
    var playerNames : [ String ] {
        history.currentPlayers.map {$0.name}
    }
    
    var tableMatrix: [ Text ] {
        var matrix: [Text] = []
        for name in players.names {
            matrix.append(Text(name).font(.headline))
        }
        for num in self.flatHistoryPoints {
            matrix.append(Text("\(num)").font(.body))
        }
        return matrix
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                
                ScrollView {
                    FlowStack(columns: players.items.count, numItems: tableMatrix.count, alignment: .center) { index, colWidth in
                        self.tableMatrix[index]
                    }
                }
                .padding(.vertical, 20.0)
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
        var players: [Player] = []
        for player in  state.players {
            let newPlayer = Player(name: player.name, score: player.score + Int.random(in: 0...5))
            players.append(newPlayer)
        }
        return GameState(players: players)
    }
    
    static func genHistory() -> History {
        let history = settings.history
        var state = GameState(players: Self.players.items)
        for _ in 0 ..< 3 {
            state = genNewState(from: state)
            history.save(state: state)
        }
        return history
    }
    
    static var previews: some View {
        let settings = GameSettings()
        settings.history = Self.history
        return HistoryDetailView(settings: settings)
    }
    
}
