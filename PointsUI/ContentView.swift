//
//  ContentView.swift
//  PointsUI
//
//  Created by Alexander Völz on 30.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @State var gameStarted = true
    @StateObject var settings : GameSettings = GameSettings()

    var body: some View {
        ZStack {
            
            if gameStarted {
                NavigationView {
                    MainGameView()
//                        .navigationBarHidden(true)
                }
            } else {
                TitleView(animatedState: .background)
            }
        
        }
        .edgesIgnoringSafeArea(.all)
        .simultaneousGesture(tapGesture)
        .environmentObject(settings)
    }

    var tapGesture : some Gesture {
        TapGesture()
        .onEnded {
            gameStarted = true
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
