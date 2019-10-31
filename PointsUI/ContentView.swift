//
//  ContentView.swift
//  PointsUI
//
//  Created by Alexander Völz on 23.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@ObservedObject var game = Game()
	var names : [String] { get {
		return game.names
		}
	}
	
	var body: some View {
		BoardUI(game: game)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		BoardUI(game: Game())
	}
}
