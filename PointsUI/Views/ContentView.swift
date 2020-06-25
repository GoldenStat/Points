//
//  ContentView.swift
//  PointsUI
//
//  Created by Alexander Völz on 23.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI
//import Combine

struct ContentView: View {
    
    @ObservedObject var settings = GameSettings()
    
    var players : Players {
        return settings.players
    }
    
    @State private var isPresented = false
        
    func undo() {
        settings.history.undo()
    }
    
    var body: some View {
        ZStack {
            TabView {

                BoardUI()
                    .tabItem({ Image(systemName: "rectangle.grid.2x2")})
                    .tag(0)
                    .onTapGesture {
                        settings.resetTimer()
                    }

                ScoreTableView(viewMode: .diff)
                    .tabItem({ Image(systemName: "table") })
                    .tag(1)

                ScoreTableView(viewMode: .total)
                    .tabItem({ Image(systemName: "table.fill") })
                    .tag(2)
            }
            .background(Color.boardbgColor)
        }
        .environmentObject(settings)
        .navigationBarTitle(GameSettings.name)
        .navigationBarHidden(true)
        .onTapGesture(count: 2) {
            navigationBarIsHidden.toggle()
        }
    }
    
    
    // MARK: Local variables
    @State var navigationBarIsHidden = true
}
    


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
