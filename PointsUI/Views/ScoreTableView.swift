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
    @ObservedObject var history: History
    var viewMode: HistoryViewMode
            
    var body: some View {
        VStack {
            namesView.flow(withColumns: playerNames.count)
                .font(.headline)
                .frame(maxHeight: sumHeight)
            
            ScrollView {
                tableMatrix.flow(withColumns: playerNames.count)
            }.frame(maxHeight: tableHeight)

            if viewMode == .diff {
                Divider()
                sumView.flow(withColumns: playerNames.count)
                    .frame(maxHeight: sumHeight)
            }
        }
    }

    // MARK: function to display nicely in a stack... change?
    private var tableMatrix: [ Text ] {
        var matrix: [Text] = []
        
        switch viewMode {
        case .diff:
            for num in history.risingScores {
                matrix.append(Text("\(num)")
                                .font(.body)
                )
            }
        case .total:
            for num in history.flatScores {
                matrix.append(Text("\(num)").font(.body))
            }
        }
        return matrix
    }
    
    // MARK: private variables
    private let sumHeight: CGFloat = 32
    private let tableHeight: CGFloat = 200
    
    private var playerNames : [ String ] { history.playerNames }
    private var namesView: [ Text ] { playerNames.map { Text($0) } }

    private var sumView: [ Text ] { history.flatSums.map { Text("\($0)") } }

}

extension Array where Element: View {
    func flow(withColumns columns: Int) -> some View {
        FlowStack(columns: columns, numItems: self.count) { index, colWidth in
            self[index]
        }
    }
}


struct ScoreTableView_Previews: PreviewProvider {
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
        let history = History()
        var state = GameState(players: Self.players.data)
        for _ in 0 ..< 10 {
            state = genNewState(from: state)
            history.save(state: state)
        }
        return history
    }
    
    static var previews: some View {
        return  VStack {
            ScoreTableView(history: genHistory(), viewMode: .total)
        }
    }
    
}
