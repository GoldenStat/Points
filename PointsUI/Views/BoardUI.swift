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
    
    var numberOfPlayers : Int { settings.players.items.count }
    
    var body: some View {
        FlowStack(columns: columns,
                  numItems: numberOfPlayers,
                  alignment: .center) { index, colWidth in
            PlayerView(player: settings.players.items[index])
        }
    }
    
    // MARK: local variables
    private var maxGames : Int { GlobalSettings.maxGames }
    private let columns = 2

}

struct BoardUI_Previews: PreviewProvider {
	static var previews: some View {
        BoardUI()
    }
}

