//
//  ScoreTableView.swift
//  PointsUI
//
//  Created by Alexander Völz on 15.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

enum HistoryViewMode { case diff, total }

/// show the history for evey player
struct ScoreTableView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var settings : GameSettings
    @State var viewMode: HistoryViewMode

    var columns : Int { settings.players.items.count }
        
    
    var playerNames : [ String ] { settings.history.playerNames }
    var namesView: [ Text ] { playerNames.map { Text($0) } }
    
    var tableMatrix: [ Text ] {
        var matrix: [Text] = []
        
        switch viewMode {
        case .diff:
            for num in settings.history.risingScores {
                matrix.append(Text("\(num)")
                                .font(.body)
                )
            }
        case .total:
            for num in settings.history.flatScores {
                matrix.append(Text("\(num)").font(.body))
            }
        }
        return matrix
    }
            
    var body: some View {
        VStack {
            namesView.flow(withColumns: columns)
                .font(.headline)
                .frame(maxHeight: 32.0)
            
            ScrollView {
                tableMatrix.flow(withColumns: columns)
            }.frame(maxHeight: 200.0)

            if viewMode == .diff {
                Divider()
                sumView.flow(withColumns: columns)
                    .frame(maxHeight: 32.0)
            }
        }
    }
    
    var sumView: [ Text ] { settings.history.flatSums.map { Text("\($0)") } }

}

extension Array where Element: View {
    func flow(withColumns columns: Int) -> some View {
        FlowStack(columns: columns, numItems: self.count) { index, colWidth in
            self[index]
        }
    }
}


struct ScoreTableView_Previews: PreviewProvider {
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
        
        // add randonm points for every player
        for player in  state.players {
            let newScore = player.score.value + Int.random(in: 0...5)
            let newPlayer = PlayerData(name: player.name, points: newScore)
            players.append(newPlayer)
        }
        return GameState(players: players)
    }
    
    static func genHistory() -> History {
        let history = settings.history
        var state = GameState(players: Self.players.data)
        for _ in 0 ..< 10 {
            state = genNewState(from: state)
            history.save(state: state)
        }
        return history
    }
    
    static var previews: some View {
        settings = GameSettings()
        settings.history = genHistory()
        return  VStack {
            ScoreTableView(viewMode: .total)
        }
    }
    
}
