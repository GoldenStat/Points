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
                
                ZStack {
                    MainGameView()
                        .blur(radius: blurRadius)
                    
                    
                    // MARK: History Views
                    if showHistory {
                        GeometryReader { geo in
                            historyView(sized: geo.size)
                                .offset(x: 0, y: 100)
                        }
                    }
                    
                }
                
                VStack {
                    MenuBar(showEditView: $showEditView,
                            showInfo: $showInfo)
                        .padding([.horizontal, .top])
                        .offset(x: 0, y: menuBarPosition == .hidden ? -500 : 0)
                        .zIndex(1) // needs to be in front for buttons to work...
                    
                    if menuBarPosition == .top {
                        Spacer()
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
        
    // MARK: - History View
    @State private var showHistory: Bool = false
    
    private var blurRadius : CGFloat { blurBackground ? 4.0 : 0.0 }
    private var blurBackground: Bool { showHistory }
    
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
    enum BarPosition {
        case hidden, top, center
        mutating func moveUp() {
            if self == .center {
                self = .top
            } else {
                self = .hidden
            }
        }
        
        mutating func moveDown() {
            if self == .hidden {
                self = .top
            } else {
                self = .center
            }
        }
    }

    @State var menuBarPosition = BarPosition.top
    
    var dragStatusBarGesture : some Gesture {
        DragGesture(minimumDistance: 30)
            .onEnded() { value in
                if value.location.above(value.startLocation) {
                    // go up
                    withAnimation() {
                        menuBarPosition.moveUp()
                    }
                } else {
                    withAnimation() {
                        menuBarPosition.moveDown()
                    }
                }
            }
    }
}

extension CGPoint {
    func above(_ point: CGPoint) -> Bool {
        self.y < point.y
    }
    func below(_ point: CGPoint) -> Bool {
        !above(point)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
