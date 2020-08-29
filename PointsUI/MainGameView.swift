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
    
    @State var showMenuBar = false
    
    var body: some View {
        
        ZStack {
            
            ZStack {
                BoardUI()
                    .blur(radius: blurRadius)
                    .padding()
                
                topBar
                
                if showMenuBar {
                    MenuBar(presentEditView: $showMenuBar)
                        .transition(
                            .move(edge: .top))
                } else {
                    if showHistoryOverlay {
                        ScoreHistoryView()
                            .background(Color.init(white: 1.0, opacity: 0.01))
                    }
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
        .onTapGesture() { showHistoryOverlay = false }
        .onLongPressGesture {
            showHistoryOverlay = true
        }
        .gesture(openEditMenu)
        .environmentObject(settings)
        .popover(isPresented: $showInfo) {
            InfoView()
        }
    }
    
    @State var showHistoryOverlay = false

    var showHistory: some Gesture {
        LongPressGesture(minimumDuration: 3, maximumDistance: 10)
            .onChanged() { _ in
                showHistoryOverlay = true
            }
    }
    
    
    @State var firstTouch: CGPoint?
    let minDistanceForEditMenu : CGFloat = 40
    var openEditMenu : some Gesture {
        DragGesture(minimumDistance: minDistanceForEditMenu)
            .onChanged { value in
                if let firstTouch = firstTouch {
                    withAnimation {
                        if value.location.y > firstTouch.y + minDistanceForEditMenu  {
                            showMenuBar = true
                        } else if value.location.y + minDistanceForEditMenu < firstTouch.y {
                            showMenuBar = false
                        }
                    }
                } else {
                    firstTouch = value.location
                }
            }
            .onEnded { _ in 
                firstTouch = nil
            }
    }
    
    var blurRadius : CGFloat {
        blurBackground ? 4.0 : 0.0
    }
    
    var blurBackground: Bool {
        showMenuBar && showHistoryOverlay
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
