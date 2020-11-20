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
    
    @State private var showMenu = false
    @State private var showHistory: Bool = false
        
    /// these views are all on top of another
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // MARK: Board
                BoardUI()
                    .blur(radius: blurRadius)
                    .padding()
                    .gesture(showHistoryGesture)
                    .environmentObject(settings)
                    .popover(isPresented: $showInfo) {
                        InfoView()
                    }
                
                // MARK: History View
                if showHistory {
                    historyView(sized: geo.size)
                }
                
                // MARK: EditView
                if showEditView {
                    EditView()
                        .transition(.opacity)
                        .onAppear {
                            showMenu = false
                        }
                }

                // MARK: Won Round
                if settings.playerWonRound != nil {
                    PlayerWonRound()
                        .onAppear {
                            showMenu = false
                        }
                }
                
                // MARK: Won Game
                if settings.playerWonGame != nil {
                    PlayerWonGame()
                        .onAppear {
                            showMenu = false
                        }
                }
            }
            
            .toolbar() {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    HStack {
                        historyButtons
                        Spacer()
                        Button() {
                            withAnimation() {
                                showEditView.toggle()
                            }
                        } label: {
                            Text(.init(systemName: "gear"))
                        }
                        
                        Spacer()
                        InfoButton(showInfo: $showInfo)
                    }
                }
            }
        }
    }
    
    @State private var showEditView = false
    @State private var showToolbar = true
    @State private var hideNavigationBar = true
    
    private func selectRule(rule: Rule) {
        settings.rule = rule
    }
    
    private  var showHistoryGesture : some Gesture { LongPressGesture(minimumDuration: 1.0, maximumDistance: 50)
        .onEnded() {_ in
            withAnimation() {
                showHistory = true                
            }
        }
    }
    
    private var blurRadius : CGFloat { blurBackground ? 4.0 : 0.0 }
    private  var blurBackground: Bool { showMenu && showHistory }
    
    // MARK: History View
    func historyView(sized geometrySize: CGSize) -> some View {
        let widthFactor: CGFloat = 0.9
        let heightFactor: CGFloat = 0.95

        let width = geometrySize.width * widthFactor
        let height = geometrySize.height * heightFactor

        return ScoreHistoryView()
            .frame(width: width,
                   height: height)
            .emphasizeShape()
            .environmentObject(settings)
            .onTapGesture() {
                withAnimation() {
                    showHistory = false
                }
            }
            .transition(.opacity)
            .padding()
    }
    
    // MARK: - Buttons
    @State private var showInfo: Bool = false
    
    // MARK: info
    @ViewBuilder private var infoButton: some View {
        Button() {
            showInfo.toggle()
        } label: {
            Image(systemName:
                    "info")
        }
    }
    
    // MARK: history
    @ViewBuilder private var historyButtons: some View {
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
    
    
    var undoSymbol: some View { Image(systemName: "arrow.left") }
    var redoSymbol: some View { Image(systemName: "arrow.right") }
}

struct InfoButton: View {
    @Binding var showInfo: Bool
    var body: some View {
        Button() {
            showInfo.toggle()
        } label: {
            Image(systemName:
                    "info")
        }
    }
}

// MARK: - previews

struct MainGameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView() {
            MainGameView()
        }
        .environmentObject(GameSettings())
    }
}

