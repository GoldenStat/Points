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
    
    func historyFrame(for size: CGSize) -> CGSize {
        let widthFactor: CGFloat = 0.9
        let heightFactor: CGFloat = 0.95
        
        return CGSize(width: size.width * widthFactor,
                      height: size.height * heightFactor)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                BoardUI()
                    .blur(radius: blurRadius)
                    .padding()
                    .gesture(showHistoryGesture)
                    .environmentObject(settings)
                    .popover(isPresented: $showInfo) {
                        InfoView()
                    }
                
                if showHistory {
                    ScoreHistoryView()
                        .frame(width: historyFrame(for: geo.size).width,
                               height: historyFrame(for: geo.size).height)
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
                
                if showEditView {
                    EditView()
                        .transition(.opacity)
                        .onAppear {
                            showMenu = false
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
            
            .toolbar() {
                ToolbarItemGroup(placement: .bottomBar) {
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
    
    @State var showEditView = false
    @State var showToolbar = true
    
    func selectRule(rule: Rule) {
        settings.rule = rule
    }
    
    var showHistoryGesture : some Gesture { LongPressGesture(minimumDuration: 1.0, maximumDistance: 50)
        .onEnded() {_ in
            withAnimation() {
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

