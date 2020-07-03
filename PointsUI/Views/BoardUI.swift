//
//  BoardUI.swift
//  Points
//
//  Created by Alexander Völz on 20.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

/// the whole board, all player's points are seen here
struct BoardUI: View {
    @EnvironmentObject var settings: GameSettings
    @ObservedObject var players: Players
    var objects : Int { players.items.count }
    
    // MARK: replace magic numbers!
    var columns = Array<GridItem>.init(repeating: GridItem(.fixed(160)), count: 2)
    var rows = Array<GridItem>.init(repeating: GridItem(.fixed(4*160), alignment: .center), count: 1)

    var body: some View {
        lazyGridView()
    }
    
    var numberOfPlayers : Int { GlobalSettings.playerNames.count }

    @available(iOS 14.0, *)
    func lazyGridView() -> some View {
        LazyHGrid(rows: rows) {
            LazyVGrid(columns: columns) {
                ForEach(players.items) { player in
                    PlayerView(player: player)
                        .frame(minWidth: 180, minHeight: 240, maxHeight: 400)
                }
            }
        }
    }    
}



struct BoardUI_Previews: PreviewProvider {
	static var previews: some View {
        BoardUI(players: GameSettings().players)
    }
}

