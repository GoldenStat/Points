//
//  HistoryDetailView.swift
//  PointsUI
//
//  Created by Alexander Völz on 24.11.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct HistoryDetailView: View {
    @ObservedObject var history: History
    @ObservedObject var players: Players
    
    /// a computed var that transfers all history states into a list
    var flatHistoryPoints : [Int] {
        var list = [Int]()
        for state in history.states {
            let points : [ Int ] = state.players.map({$0.points})
            list.append(contentsOf: points)
        }
        return list
    }
    
    var playerNames : [ String ] {
        players.items.map {$0.name}
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
                FlowStack(columns: players.items.count, numItems: tableMatrix.count, alignment: .center) { index, colWidth in
                    self.tableMatrix[index]
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
    static let names = [ "Alexander", "Lili", "Villa" ]
    static let players = Players(names: Self.names)
    
    static func genNewState(from state: GameState) -> GameState{
        var players: [Player] = []
        for player in  state.players {
            let newPlayer: Player
            newPlayer = Player(name: player.name, points: player.points + Int.random(in: 0...5))
            players.append(newPlayer)
        }
        return GameState(players: players)
    }
    
    static func genHistory() -> History {
        let history = History()
        var state = GameState(players: Self.players.items)
        for _ in 0 ..< 3 {
            state = genNewState(from: state)
            history.save(state: state)
        }
//        history.undo()
        return history
    }
    
    static var previews: some View {
        HistoryDetailView(history: Self.genHistory(), players: Self.players)
    }
    
}
