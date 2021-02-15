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
                    MenuBar(showSettings: $showSettings,
                            showInfo: $showInfo,
                            showHistory: $showHistory,
                            steps: modifyHistory.steps)
                        .padding([.horizontal, .top])
                        .zIndex(1) // needs to be in front for buttons to work...
                        .drawingGroup()
                        .offset(x: 0, y: menuBarPosition == .hidden ? -500 : 30)
                        .shadow(color: .black, radius: 10, x: 8, y: 8)
                    
                    if menuBarPosition == .top {
                        Spacer()
                    }
                }
                
                if (modifyHistory.dragStarted) {
                    HistorySymbolRow()
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
            .gesture(dragGesture)
            .onLongPressGesture {
                withAnimation() {
                    showHistory = true
                }
            }
            
            // MARK: Popovers
            .popover(isPresented: $showInfo) {
                NavigationView {
                    InfoView()
                }
            }
            .popover(isPresented: $showSettings) {
                NavigationView {
                    SettingsView()
                }
                .environmentObject(settings)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(settings)
    }
    
    // MARK: - overlay View triggers
    @State var showInfo: Bool = false
    @State var showSettings: Bool = false
        
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
    
    struct HistoryControl {
        var steps: Int = 0
        var dragStarted: Bool = false
    }
    
    // has a link to history
    @GestureState var modifyHistory = HistoryControl()
    var dragGesture : some Gesture {
        DragGesture(minimumDistance: 30)
            .updating($modifyHistory) { value, historyControl, _ in
                
                historyControl = HistoryControl(
                    steps: value.steps,
                    dragStarted: true
                )
                
                switch value.dir {
                case .left:
                    fallthrough
                case .right:
                    withAnimation() {
                        settings.previewHistorySteps(steps: value.steps)
                    }
                default:
                    break
                }
            }
            .onEnded() { value in
                switch value.dir {
                case .up:
                    withAnimation() { menuBarPosition.moveUp() }
                case .down:
                    withAnimation() { menuBarPosition.moveDown() }
                case .left:
                    fallthrough
                case .right:
                    settings.performHistoryChange()
                default:
                    break
                }
            }
    }
}

/// an extension to measure steps and direction of movement
extension DragGesture.Value {
    var steps: Int {
        Int((startLocation.xDelta(location) / 80).rounded(.towardZero))
    }
    var dir: Direction {
        .move(from: startLocation,
              to: location)
    }
}

/// a new enum to reflect movement
enum Direction {
    case left, up, right, down, none
    
    static func move(from: CGPoint, to: CGPoint) -> Direction {
        if from.above(to) { return .down }
        if from.below(to) { return .up }
        if from.left(to) { return .right }
        if from.right(to) { return .left }
        return .none
    }
}

extension CGPoint {
    func xDeltaRelevant(_ point: CGPoint) -> Bool {
        abs(x  - point.x) > abs(y - point.y)
    }
    
    /// x.xDelta(point)
    func xDelta(_ point: CGPoint) -> CGFloat {
        point.x - x
    }
    
    func above(_ point: CGPoint) -> Bool {
        !xDeltaRelevant(point) && y < point.y
    }
    
    func below(_ point: CGPoint) -> Bool {
        !xDeltaRelevant(point) && y > point.y
    }
    
    func left(_ point: CGPoint) -> Bool {
        xDeltaRelevant(point) && x < point.x
    }
    
    func right(_ point: CGPoint) -> Bool {
        xDeltaRelevant(point) && x > point.x
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
