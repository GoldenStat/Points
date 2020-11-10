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
    @EnvironmentObject var settings: GameSettings
    var history: History { settings.history }
    var players: Players { settings.players }
    var viewMode: HistoryViewMode
            
    var body: some View {
        VStack {
            namesView.flow(withColumns: numberOfColumms)
                .font(.headline)
                .frame(maxHeight: sumHeight)

            Divider()
            
            ScrollView {
                tableMatrix.flow(withColumns: numberOfColumms)
            }.frame(maxHeight: tableHeight)

            if viewMode == .diff {
                Divider()
                sumView.flow(withColumns: numberOfColumms)
                    .font(.headline)
                    .frame(maxHeight: sumHeight)
            }
            
        }
    }

    // MARK: function to display nicely in a stack... change?
    private var tableMatrix: [ Text ] {
        if history.states.isEmpty { // return lines with only zeroes in case we don't have any states
            return(Array<Text>.init(repeating: Text("0"), count: numberOfColumms))
        }
        
        switch viewMode {
        case .diff:
            return history.risingScores.map { Text($0.description) }
        case .total:
            return history.flatScores.map { Text($0.description) }
        }
    }
    
    // MARK: private variables
    private let sumHeight: CGFloat = 32
    private let tableHeight: CGFloat = 200
    
    var numberOfColumms: Int { players.count }
    private var playerNames : [ String ] { players.names }
    private var namesView: [ Text ] {
        players.items.map {
            Text("\($0.name)" + string(for: $0.games))
        }
    }
    
    func string(for games: Int) -> String {
        games > 1 ? " - \(games)" : ""
    }

    private var sumView: [ Text ] { history.flatSums.map { Text("\($0)") } }

}


extension Array where Element: View {
    func flow(withColumns columns: Int) -> some View {
        FlowStack(columns: columns, numItems: self.count) { index, colWidth in
            self[index]
        }
    }
}


struct SampleTableView: View {
    
    @State var settings = GameSettings()
    
    
    var body: some View {
        ScoreTableView(viewMode: .diff)
            .environmentObject(settings)
    }
}

struct ScoreTableView_Previews: PreviewProvider {

    static var previews: some View {
        return  VStack {
            SampleTableView()
        }
    }
}
