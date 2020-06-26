//
//  GameBoardView.swift
//  PointsUI
//
//  Created by Alexander Völz on 25.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct GameBoardView: View {
    @EnvironmentObject var settings: GameSettings
    
    var body: some View {
        TabView {
            
            BoardUI(players: settings.players)
                .tabItem({ Image(systemName: "rectangle.grid.2x2")})
                .tag(0)
            
            ScoreTableView(history: settings.history, viewMode: .diff)
                .tabItem({ Image(systemName: "table") })
                .tag(1)
            
            ScoreTableView(history: settings.history, viewMode: .total)
                .tabItem({ Image(systemName: "table.fill") })
                .tag(2)
        }
        .environmentObject(settings)

    }
}


struct GameBoardView_Previews: PreviewProvider {
    static var previews: some View {
        GameBoardView()
    }
}
