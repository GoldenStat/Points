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
	@ObservedObject var game : Game
	var names : [ String ] { get {
		return game.names
		}
	}
	
	private let bgColor = Color(red: 200 / 255.0, green: 200 / 255.0, blue: 255 / 255.0)
	
	static let maxGames = 3
	static let columns = 2
	
	var numberOfPlayers : Int { get {
		names.count
		} }
	
	private func name(at row: Int, column: Int) -> String {
		let index = row * Self.columns + column
		return names[index]
	}
	
	var body: some View {
		NavigationView {
		ZStack {
			bgColor
				.opacity(50.0)
				.edgesIgnoringSafeArea(.all)

			FlowStack(columns: Self.columns, numItems: numberOfPlayers, alignment: .center) { index, colWidth in
				PlayerView(name: self.names[index])
					.frame(width: colWidth, height: colWidth! * CGFloat(2.0))
			}

		}
		}
	}
}

struct BoardUI_Previews: PreviewProvider {
	static var names = ["Alexander", "Lili"]
	static var previews: some View {
		BoardUI(game: Game())
	}
}
