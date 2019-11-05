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
		NavigationView {
            BoardUI(game: game)
                .navigationBarTitle(Text("Truco Venezolano").font(.caption))
                .navigationBarItems(
                    leading: NavigationLink(destination:
                        Text("This is the game history")) {
                            Text("Show Detail")
                        },
                    trailing: HStack {
                        Button("Undo") {
                            self.game.undo()
                        }
                        EditButton()
                    }
            )
        }
    }
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
