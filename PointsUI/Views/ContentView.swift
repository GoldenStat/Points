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
        
    // MARK: Change Appearance
    @State var navigationBarIsHidden = true
    @State private var settingsEditorIsShown = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.lightMidnight
                    .edgesIgnoringSafeArea(.all)
                
                GameBoardView()
            }
            .environmentObject(settings)
            .navigationBarTitle(GameSettings.name)
            .navigationBarHidden(true)
            .onTapGesture(count: 2) {
                navigationBarIsHidden.toggle()
            }
        }
    }
    
}
    


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct GameBoardView: View {
    @EnvironmentObject var settings: GameSettings
    
    var body: some View {
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
    }
}
