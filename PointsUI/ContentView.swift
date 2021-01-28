//
//  ContentView.swift
//  PointsUI
//
//  Created by Alexander Völz on 30.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var settings : GameSettings = GameSettings()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.boardbgColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    MenuBar(showEditView: $showEditView,
                            showInfo: $showInfo)
                        .zIndex(1) // needs to be in front for buttons to work...
                        .offset(x: 0, y: hideStatusBar ? -200 : 60)
                    
                    ZStack {
                        MainGameView()
                            .blur(radius: blurRadius)
                        
                        
                        // MARK: History Views
//                        if showHistoryControls {
//                            HistoryControlView(showHistory: $showHistory)
//                        }
                        
                        if showHistory {
                            GeometryReader { geo in
                                historyView(sized: geo.size)
                                    .offset(x: 0, y: 100)
                            }
                        }
                        
                        if showHistoryControls {
                            historyControlView()
                        }
                    }
                }
            }
            .statusBar(hidden: true)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .navigationTitle(settings.rule.description)
            // MARK: Gestures
            .onTapGesture() {
                withAnimation() {
                    showHistory = false
                }
            }
            .gesture(dragStatusBarGesture)
            .onLongPressGesture {
                withAnimation() {
                    showHistory = true
                }
            }
            
            // MARK: Popovers
            .popover(isPresented: $showInfo) {
                InfoView()
            }
            .popover(isPresented: $showEditView) {
                NavigationView {
                    EditView()
                }
                .environmentObject(settings)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(settings)
    }
    
    // MARK: - overlay View triggers
    @State var showInfo: Bool = false
    @State var showEditView: Bool = false
//    @State private var showHistoryControls: Bool = false
    
    @State private var hideStatusBar = false
    // MARK: - History Controls (undo/redo)
    @State private var showHistoryControls = true
    func historyControlView() -> some View {
        OverlayHistorySymbol(side: .both, state: OverlayHistorySymbol.initial)
    }
    
    // MARK: - History View
    @State private var showHistory: Bool = false
    
    private var blurRadius : CGFloat { blurBackground ? 4.0 : 0.0 }
    private var blurBackground: Bool { showHistory || showHistoryControls }
    
    func historyView(sized geometrySize: CGSize) -> some View {
        let heightFactor: CGFloat = 0.6
        let height = geometrySize.height * heightFactor
        
        // NOTE: use @ScaledMetric for height? Use maxHeight, instead?
        return ScoreHistoryView()
            .frame(height: height)
            .emphasizeShape(cornerRadius: 16.0)
            .transition(.opacity)
            .padding()
    }
    
    // MARK: - Status Bar
    var dragStatusBarGesture : some Gesture {
        DragGesture(minimumDistance: 30)
            .onChanged() { value in
                if value.location.y < value.startLocation.y && !hideStatusBar {
                    withAnimation() {
                        hideStatusBar = true
                    }
                } else if value.location.y > value.startLocation.y && hideStatusBar {
                    withAnimation() {
                        hideStatusBar = false
                    }
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
