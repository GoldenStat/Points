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
            if gameStarted {
                NavigationView {
                    // TODO: improve this!
                    // insert an EmptyView so we don't see the splitviewController??
//                    if UIDevice.current.orientation.isLandscape {
//                        EmptyView()
//                    }
                    MainGameView()
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                }
                .navigationViewStyle(StackNavigationViewStyle())
            } else {
                TitleView(animatedState: .background)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .gesture(startGameGesture)
        .simultaneousGesture(toggleNavigationBar)
        .environmentObject(settings)
    }

    var startGameGesture : some Gesture {
        TapGesture()
        .onEnded {
            gameStarted = true
        }
    }
    
    @State var hideStatusBar = false
    var toggleNavigationBar : some Gesture {
        TapGesture(count: 2)
            .onEnded() {
                hideStatusBar.toggle()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(gameStarted: true)
    }
}
