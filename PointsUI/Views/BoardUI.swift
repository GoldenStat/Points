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

struct BoardUI: View {
	
    @ObservedObject var settings : GameSettings
    
    var players : Players {
        return settings.players
    }
    var history : History {
        return settings.history
    }

    @State private var games : Int = 0
	
    static let maxGames = Default.maxGames
	static let columns = 2
	
	var numberOfPlayers : Int { get {
        players.names.count
		} }
	
	private func name(at row: Int, column: Int) -> String {
		let index = row * Self.columns + column
        return players.names[index]
	}
	
    func saveScores() {
        for player in players.items {
            let view = PlayerView(settings: settings, player: player)
            view.saveScore()
        }
    }
    
	var body: some View {
			FlowStack(columns: Self.columns, numItems: numberOfPlayers, alignment: .center) { index, colWidth in
                PlayerView(settings: self.settings, player: self.players.items[index])
				.padding(5)
			}
	}
}

struct BoardUI_Previews: PreviewProvider {
	static var previews: some View {
        BoardUI(settings: GameSettings())
	}
}
