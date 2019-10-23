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
	var names: [ String ] = [ "Alexander", "Lili", "Villa" ]

	private let bgColor = Color(red: 200 / 255.0, green: 200 / 255.0, blue: 255 / 255.0)

	
	private var players : [ PlayerScore ] { get { return names.map { PlayerScore(name: $0) } } }
		
	static let maxGames = 3
	static let columns = 2
	
	var numberOfPlayers : Int { get {
		players.count
		} }
	
	var rows : Int { get {
		let ratio = numberOfPlayers / Self.columns
		return ratio + (self.lastRowColumns > 0 ? 1 : 0)
		} }
	
	private var lastRowColumns : Int { get {
		return numberOfPlayers % Self.columns
		} }
		

	private func name(at row: Int, column: Int) -> String {
		let index = row * Self.columns + column
		return names[index]
	}
	
	var body: some View {
		VStack {
		FlowStack(columns: Self.columns, numItems: players.count, alignment: .center) { index, colWidth in
			self.players[index]				//				.padding()
				.frame(width: colWidth, height: colWidth! * CGFloat(2.0))
		}
		.background(bgColor)
		.opacity(50.0)
		//		.edgesIgnoringSafeArea(.all)
			
			Button("resetScores") {
				_ = self.players.map { $0.resetScore() }
			}
			
		}
	}
}

struct BoardUI_Previews: PreviewProvider {
	static var previews: some View {
		BoardUI(names: ["Alexander", "Lili"] )
    }
}
