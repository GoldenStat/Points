//
//  ContentView.swift
//  PointsUI
//
//  Created by Alexander Völz on 23.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

extension Color {
    static let invisible = Color.init(white: 1.0, opacity: 0.01)
}

struct MainGameView: View {
    
    @StateObject var settings : GameSettings = GameSettings()
    
    @State var showMenu = false
    
    var body: some View {
        
        ZStack {
            
            ZStack {
                
                Color.invisible
                
                BoardUI()
                    .blur(radius: blurRadius)
                    .padding()
                
                topBar
                
                
                if showMenu {
                    MenuBar(presentEditView: $showMenu)
                        .emphasizeShape()
                        .padding()
                        .transition(.opacity)
                    
                }

                if showHistory {
                    ScoreHistoryView()
                        .background(Color.invisible)
                        .frame(minHeight: 600)
                        .emphasizeShape()
                        .padding()
                        .onTapGesture() {
                            showHistory = false
                        }
                        .transition(.opacity)
                }
                
            }
            
            if settings.playerWonRound != nil {
                PlayerWonRound()
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        showMenu = false
                    }
            }
            
            if settings.playerWonGame != nil {
                PlayerWonGame()
                    .transition(.opacity)
                    .onAppear {
                        showMenu = false
                    }
            }
        }
        .onLongPressGesture {
            withAnimation(.linear(duration: 0.5)) {
                    showHistory = true
            }
        }
        .environmentObject(settings)
        .popover(isPresented: $showInfo) {
            InfoView()
        }
    }
    
    func selectRule(rule: Rule) {
        settings.rule = rule
    }
    
    @State var showHistory: Bool = false
    
    
    var blurRadius : CGFloat { blurBackground ? 4.0 : 0.0 }
    var blurBackground: Bool { showMenu && showHistory }
    
    // MARK: - Top Bar
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
    
    // MARK: - history buttons
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

// MARK: - previews

struct MainGameView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainGameView(settings: GameSettings())
            MainGameView(settings: GameSettings())
                .preferredColorScheme(.dark)
        }
    }
}
