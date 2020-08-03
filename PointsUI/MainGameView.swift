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
                    .blur(radius: blurRadius)
                    .padding()
                
                topBar
                
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
        .highPriorityGesture(openEditMenu)
        .environmentObject(settings)
        .popover(isPresented: $showInfo) {
            InfoView()
        }
    }
    
    var openEditMenu : some Gesture { TapGesture(count: 2)
        .onEnded {
            showMenuBar.toggle()
            settings.updateSettings()
        }
    }
    
    var blurRadius : CGFloat {
        isEditing ? 4.0 : 0.0
    }
    
    // MARK: Top Bar
    @State var showInfo: Bool = false
    
    var topBar: some View {
        VStack {
            HStack {
                historyButtons
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
    
    // MARK: history buttons
    var historyButtons: some View {
        HStack {
            Button() { settings.undo() }
                label: {
                    undoSymbol
                        .padding()
                }
                .disabled(!settings.canUndo)
            Button() { settings.redo() }
                label: {
                    redoSymbol
                        .padding()
                }
                .disabled(!settings.canRedo)
        }
    }
    
    var undoSymbol: some View { Image(systemName: "arrow.left")}
    var redoSymbol: some View { Image(systemName: "arrow.right")}
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
