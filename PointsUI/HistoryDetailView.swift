//
//  HistoryDetailView.swift
//  PointsUI
//
//  Created by Alexander Völz on 24.11.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct HistoryDetailView: View {
    @ObservedObject var history: History
    @ObservedObject var players: Players
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    ForEach(players.items) { player in
                        Text(player.name)
                    }
                }
                List {
                    ForEach(history.states) { state in
                        HStack {
                            ForEach(state.players) { player in
                                Text("\(player.points)")
                            }
                        }
                    }
                }
                Button("Dismiss") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        .navigationBarTitle(Text("Game History"))
        }
    }
}


struct HistoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryDetailView(history: History(), players: Players())
    }
}
