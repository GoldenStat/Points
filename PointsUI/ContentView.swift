//
//  ContentView.swift
//  PointsUI
//
//  Created by Alexander Völz on 30.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var gameStarted : Bool
    @StateObject var settings : GameSettings = GameSettings()
    
    var body: some View {
        if gameStarted {
            NavigationView {
                ZStack {
                    Color.background
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Text(settings.rule.description)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    MainGameView(hideToolBar: $hideStatusBar)
                        .statusBar(hidden: true)
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                        .gesture(toggleStatusBar)
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(settings)
        } else {
            ZStack {
                Color.background
                TitleView(animatedState: .background)
                    .gesture(startGameGesture)
            }
            .edgesIgnoringSafeArea(.all)
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
        ContentView(gameStarted: true)
    }
}
