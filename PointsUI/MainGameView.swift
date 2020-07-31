//
//  ContentView.swift
//  PointsUI
//
//  Created by Alexander Völz on 23.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct MainGameView: View {
    @StateObject var settings : GameSettings = GameSettings()

    @State var showMenuBar = false { didSet {
        if !showMenuBar {
            isEditing = false
        }
    }}
    
    @State var isEditing = false
        
    var body: some View {
        
        ZStack {
            
            ZStack {
                GameBoardView()
                    .blur(radius: isEditing ? 4.0 : 0.0 )
                    .padding()

                if showMenuBar {
                    MenuBar(presentEditView: $isEditing)
                        .transition(
                            .move(edge: .top))
                }
                
            }
            
            if settings.playerWonRound != nil {
                PlayerWonRound()
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        showMenuBar = false
                    }
            }
            
            if settings.playerWonGame != nil {
                PlayerWonGame()
                    .transition(.opacity)
                    .onAppear {
                        showMenuBar = false
                    }
            }
        }
        .animation(.default)
        .onTapGesture(count: 2) {
            showMenuBar.toggle()
            settings.updateSettings()
        }
        .animation(.spring(response: 1.0, dampingFraction: 0.85, blendDuration: 0))
        .environmentObject(settings)
    }
}


struct MainGameView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainGameView(settings: GameSettings())
            MainGameView(settings: GameSettings())
                .preferredColorScheme(.dark)
        }
    }
}
