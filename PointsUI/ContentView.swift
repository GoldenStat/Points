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
