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
                        .transition(
                            .move(edge: .top))
                } else {
                        ScoreHistoryView()
                            .background(Color.invisible)
                            .frame(minHeight: 600)
                            .emphasizeShape()
                            .padding()
                            .opacity(historyOpacity)
                }
            }
//            .toolbar() {
//                ToolbarItemGroup(id: "Menu Bar", placement: ToolbarItemPlacement.automatic, showsByDefault: true) {
//                    topBar
//                }
//            }
//            .toolbar() {
//                ToolbarItemGroup(placement: ToolbarItemPlacement.bottomBar) {
//                    NavigationLink("Juegos", destination: JuegosPicker())
//                }
//            }
            
            
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
                if !showMenu {
                    historyOpacity = 1.0
                }
            }
        }
        .simultaneousGesture(openEditMenu)
        .environmentObject(settings)
        .popover(isPresented: $showInfo) {
            InfoView()
        }
    }
    
    func selectRule(rule: Rule) {
        settings.rule = rule
    }
    
    var showHistoryOverlay : Bool { historyOpacity == 1.0 }
    // sets the opacity of the history view which is always on, but invisible unless you summon it
    @State var historyOpacity: Double = 0.0
    
    @State var firstTouch: CGPoint?
    let minDistanceForEditMenu : CGFloat = 40
    var openEditMenu : some Gesture {
        DragGesture(minimumDistance: minDistanceForEditMenu)
            .onChanged { value in
                if let firstTouch = firstTouch {
                    withAnimation {
                        if value.location.y > firstTouch.y + minDistanceForEditMenu  {
                            showMenu = true
                        } else if value.location.y + minDistanceForEditMenu < firstTouch.y {
                            showMenu = false
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
        showMenu && showHistoryOverlay
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
