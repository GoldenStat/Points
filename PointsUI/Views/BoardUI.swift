//
//  BoardUI.swift
//  Points
//
//  Created by Alexander Völz on 20.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

extension Color {
    static let boardbgColor = Color(red: 200 / 255.0, green: 200 / 255.0, blue: 255 / 255.0)
        .opacity(50.0)
}

/// the whole board, all player's points are seen here
struct BoardUI: View {
	
    @ObservedObject var players: Players
    @State private var games : Int = 0
	
    static let maxGames = GlobalSettings.maxGames
	static let columns = 2

	var numberOfPlayers : Int { get {
        players.items.count
		} }
	            
	var body: some View {
        VStack {
			FlowStack(columns: Self.columns, numItems: numberOfPlayers, alignment: .center) {
                index, colWidth in
                PlayerView(player: self.players.items[index])
			}
        }
	}
}

struct BoardUI_Previews: PreviewProvider {
    
    static var defaultPlayers = Players(names: GlobalSettings.playerNames)

	static var previews: some View {
            BoardUI(players: defaultPlayers)
    }
}

