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
    
    @EnvironmentObject var settings : GameSettings
    
    @State var showMenu = false
    
    var body: some View {
        
        ZStack {
            
            Color.invisible
            
            BoardUI()
                .blur(radius: blurRadius)
                .padding()
            
            
            if showHistory {
                ScoreHistoryView()
                    .background(Color.invisible)
                    .frame(minHeight: 600)
                    .emphasizeShape()
                    .padding()
                    .onTapGesture() {
                        withAnimation() {
                            showHistory = false
                        }
                    }
                    .transition(.opacity)
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
        .gesture(showHistoryGesture)
        .environmentObject(settings)
        .popover(isPresented: $showInfo) {
            InfoView()
        }
        .toolbar() {
            ToolbarItemGroup(placement: .bottomBar) {
                HStack {
                    historyButtons
                    EditButton()
                    Button() {
                        showInfo.toggle()
                    } label: {
                        Image(systemName:
                                "info")
                    }
                }
            }
        }
    }
    
    func selectRule(rule: Rule) {
        settings.rule = rule
    }
    
    @State var showHistory: Bool = false
    var showHistoryGesture : some Gesture { LongPressGesture(minimumDuration: 1.0, maximumDistance: 50)
        .onEnded() {_ in
            withAnimation(.linear(duration: 0.5)) {
                showHistory = true                
            }
        }
    }
    
    var blurRadius : CGFloat { blurBackground ? 4.0 : 0.0 }
    var blurBackground: Bool { showMenu && showHistory }
    
    // MARK: - Buttons
    @State var showInfo: Bool = false
    
    @ViewBuilder var infoButton: some View {
        Button() {
            showInfo.toggle()
        } label: {
            Image(systemName:
                    "info")
        }
    }
    
    // MARK: - history buttons
    @ViewBuilder var historyButtons: some View {
        HStack {
            historyUndoButton
            historyRedoButton
        }
    }
    
    @ViewBuilder var historyUndoButton: some View {
        Button() { settings.redo() }
            label: {
                undoSymbol
            }
            .disabled(!settings.canRedo)
    }
    
    @ViewBuilder var historyRedoButton: some View {
        Button() { settings.redo() }
            label: {
                redoSymbol
            }
            .disabled(!settings.canRedo)
    }
    
    
    var undoSymbol: some View { Image(systemName: "arrow.left")}
    var redoSymbol: some View { Image(systemName: "arrow.right")}
}

// MARK: - previews

struct MainGameView_Previews: PreviewProvider {
    static var previews: some View {
        MainGameView()
            .environmentObject(GameSettings())
    }
}

