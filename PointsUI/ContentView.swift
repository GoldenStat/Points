//
//  ContentView.swift
//  PointsUI
//
//  Created by Alexander Völz on 30.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var settings : GameSettings = GameSettings()
    @State var gameStarted : Bool
    
    @State private var hideNavigationBar = true
    
    var body: some View {
        if gameStarted {
            NavigationView {
                ZStack {
                    Color.boardbgColor
                    
                    MainGameView(hideToolBar: $hideStatusBar)
                    
                }
                .statusBar(hidden: true)
                .navigationBarHidden(hideNavigationBar)
                .navigationBarBackButtonHidden(true)
                .navigationTitle(settings.rule.description)
                .gesture(toggleStatusBar)
                
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(settings)
        } else {
            ZStack {
                Background()
                TitleView(animatedState: .background)
                    .gesture(startGameGesture)
            }
            .environmentObject(settings)
        }
    }

    var startGameGesture : some Gesture {
        TapGesture()
            .onEnded {
                gameStarted = true
            }
    }
    
    @State private var hideStatusBar = true
    var toggleStatusBar : some Gesture {
        DragGesture(minimumDistance: 30)
            .onChanged() { value in
                if value.location.y < value.startLocation.y {
                    withAnimation(.easeIn) {
                        hideStatusBar = false
                    }
                } else if value.location.y > value.startLocation.y {
                    withAnimation(.easeIn) {
                        hideStatusBar = true
                    }
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(gameStarted: false)
    }
}
