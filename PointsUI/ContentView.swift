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
        ZStack {
            Color.background
            if gameStarted {
                NavigationView {
                    MainGameView(hideToolBar: $hideStatusBar)
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                        .highPriorityGesture(toggleStatusBar)
                }
                .navigationViewStyle(StackNavigationViewStyle())
            } else {
                TitleView(animatedState: .background)
                    .gesture(startGameGesture)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .environmentObject(settings)
    }

    var startGameGesture : some Gesture {
        TapGesture()
        .onEnded {
            gameStarted = true
        }
    }
    
    @State private var hideStatusBar = false
    var toggleStatusBar : some Gesture {
        DragGesture(minimumDistance: 30)
            .onChanged() { value in
                if value.location.y < value.startLocation.y {
                    withAnimation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/) {
                        hideStatusBar = false
                    }
                } else if value.location.y > value.startLocation.y {
                    withAnimation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/) {
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
