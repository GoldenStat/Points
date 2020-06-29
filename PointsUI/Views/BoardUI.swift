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
        
    var numberOfPlayers : Int { players.items.count }
    
    var body: some View {
        FlowStack(columns: columns,
                  numItems: numberOfPlayers,
                  alignment: .center) { index, colWidth in
            PlayerView(player: players.items[index])
        }
    }
    
    // MARK: local variables -- make columns depend on number of players and device orientation
    // MARK: also inspect new LazyGridView option
    private var maxGames : Int { GlobalSettings.maxGames }
    private let columns = 2

}

struct BoardUI_Previews: PreviewProvider {
	static var previews: some View {
        BoardUI(players: GameSettings().players)
    }
}

