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

                infoButton
                
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
        .onTapGesture(count: 2) {
            showMenuBar.toggle()
            settings.updateSettings()
        }
        .environmentObject(settings)
        .popover(isPresented: $showInfo) {
            InfoView()
        }
    }
    
    // MARK: info button
    @State var showInfo: Bool = false

    var infoButton: some View {
        VStack {
            HStack {
                Spacer()
                Button() {
                    showInfo.toggle()
                } label: {
                    Image(systemName:
                            "info")
                        .padding()
                }
            }
            Spacer()
        }
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
