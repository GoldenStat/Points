//
//  ContentView.swift
//  PointsUI
//
//  Created by Alexander Völz on 23.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var players = Players(names: Default.names)
    @ObservedObject var history = History()
    	
    @State private var isPresented = false
    
	var body: some View {
		NavigationView {
            BoardUI(players: players, history: history)
                .navigationBarTitle(Text("Truco Venezolano").font(.caption))
                .navigationBarItems(
                    leading: Button("History") {
                        self.isPresented.toggle()
                        },
                    trailing: HStack {
                        Button("Undo") {
                            self.history.undo()
                            print("%d steps saved", self.history.states.count)
                        }
                        EditButton()
                    }
            )
                .sheet(isPresented: $isPresented) {
                    HistoryDetailView(history: self.history, players: self.players)
                    
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
