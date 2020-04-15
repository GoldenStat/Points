//
//  ScoreTableView.swift
//  PointsUI
//
//  Created by Alexander Völz on 15.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

extension Array where Element: View {
    func flow(withColumns columns: Int) -> some View {
        FlowStack(columns: columns, numItems: self.count) { index, colWidth in
            self[index]
        }
    }
}

enum HistoryViewMode { case diff, total }

struct ScoreTableView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var settings : GameSettings
    
    var history : History { settings.history }
    var players : Players { settings.players }
    var columns : Int { players.items.count }
    
    /// a computed var that transfers all history states into a list
    var flatHistoryScore : [Int] {
        var list = [Int]()
        
        for state in history.states {
            let points : [ Int ] = state.players.map({$0.score})
            list.append(contentsOf: points)
        }
        
        return list
    }
    
    var flatRisingScore : [Score] {
        var list = [Score]()
        var lastScore: [Score]?
        
        for state in history.states {
            let currentScore : [ Score ] = state.players.map({$0.score})
            if let lastScore = lastScore {
                var diffScore = [Int]()
                for index in 0 ..< lastScore.count {
                    diffScore.append(currentScore[index]-lastScore[index])
                }
                list.append(contentsOf: diffScore)
            } else {
                list.append(contentsOf: currentScore)
            }
            lastScore = currentScore
        }
        
        return list
    }
    
    var flatSum: [Score] {
        history.states.last?.scores ?? [Int].init(repeating: Score(0), count: columns)
    }
    var sumView: [ Text ] { flatSum.map { Text("\($0)") } }
    
    var playerNames : [ String ] { history.playerNames }
    var namesView: [ Text ] { playerNames.map { Text($0) } }
    
    @State var viewMode: HistoryViewMode

    var tableMatrix: [ Text ] {
        var matrix: [Text] = []
        
        switch viewMode {
        case .diff:
            for num in self.flatRisingScore {
                matrix.append(Text("\(num)").font(.body))
            }
        case .total:
            for num in self.flatHistoryScore {
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
        for player in  state.players {
            let newPlayer = PlayerData(name: player.name, score: player.score + Int.random(in: 0...5))
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
            ScoreTableView(settings: settings, viewMode: .total)
        }
    }
    
}
