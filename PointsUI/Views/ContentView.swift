//
//  ContentView.swift
//  PointsUI
//
//  Created by Alexander Völz on 23.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @StateObject var settings : GameSettings = GameSettings()
    @State var showMenuBar = false
    @State var isEditing = false
    
    let bgColor = Color.darkNoon
    
    var body: some View {
        
        ZStack {
            bgColor
                .edgesIgnoringSafeArea(.all)
            
            ZStack {
                GameBoardView()
                    .blur(radius: isEditing ? 4.0 : 0.0 )
                    .background(bgColor)

                if showMenuBar {
                    MenuBar(presentEditView: $isEditing)
                        .transition(.move(edge: .top))
                }
                
            }
        }
        .onTapGesture(count: 2) {
            showMenuBar.toggle()
        }
        .animation(.default)
        .environmentObject(settings)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(settings: GameSettings())
    }
}
