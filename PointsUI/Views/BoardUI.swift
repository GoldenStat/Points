//
//  BoardUI.swift
//  Points
//
//  Created by Alexander Völz on 20.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct BoardUI: View {
	
	@State private var games : Int = 0	
	@ObservedObject var players : Players
    @ObservedObject var history : History
    
	var names : [ String ] { get {
        return players.names
		}
	}
	
	private let bgColor = Color(red: 200 / 255.0, green: 200 / 255.0, blue: 255 / 255.0)
        .opacity(50.0)

    static let maxGames = Default.maxGames
	static let columns = 2
	
	var numberOfPlayers : Int { get {
		names.count
		} }
	
	private func name(at row: Int, column: Int) -> String {
		let index = row * Self.columns + column
		return names[index]
	}
	
	var body: some View {
		ZStack {
			bgColor
				.edgesIgnoringSafeArea(.all)

			FlowStack(columns: Self.columns, numItems: numberOfPlayers, alignment: .center) { index, colWidth in
                PlayerView(players: self.players, player: self.players.items[index])
				.padding(5)
			}
		}
	}
}

struct BoardUI_Previews: PreviewProvider {
	static var previews: some View {
        BoardUI(players: Players(), history: History())
	}
}
