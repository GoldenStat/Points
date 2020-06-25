//
//  ContentView.swift
//  PointsUI
//
//  Created by Alexander Völz on 23.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var settings = GameSettings()
    
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
                BoardUI(settings: $settings)
                    .tabItem({ Image(systemName: "rectangle.grid.2x2")})
                    .tag(0)

                ScoreTableView(settings: $settings, viewMode: .diff)
                    .tabItem({ Image(systemName: "table") })
                    .tag(1)
                ScoreTableView(settings: $settings, viewMode: .total)
                    .tabItem({ Image(systemName: "table.fill") })
                    .tag(2)
            }
            .background(Color.boardbgColor)
            .onTapGesture {
                settings.resetTimer()
            }

        }
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
