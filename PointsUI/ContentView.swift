//
//  ContentView.swift
//  PointsUI
//
//  Created by Alexander Völz on 30.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @State var gameStarted = false

    var body: some View {
        let tapGesture = TapGesture()
            .onEnded {
                gameStarted = true
            }
        
        return ZStack {
            TitleView()
                .edgesIgnoringSafeArea(.all)
            
            if gameStarted {
                MainGameView()
            }
        }
        .simultaneousGesture(tapGesture)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
