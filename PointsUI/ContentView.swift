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

    var stepsToUndo: Int {
        if settings.history.isBuffered {
            return 0
        } else {
            return settings.history.buffer.count
        }
    }
    
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
                            steps: stepsToUndo
                            )
                        .padding(.horizontal)
                        .zIndex(1) // needs to be in front for buttons to work...
                        .drawingGroup()
                        .offset(x: 0, y: menuBarPosition.rawValue)
                        .shadow(color: .black, radius: 10, x: 8, y: 8)
                    
                    if menuBarPosition != .center {
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
            .gesture(dragHistoryGesture)
            
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
    private var blurBackground: Bool { showHistory || showInfo || showSettings }
    
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
    enum BarPosition : CGFloat {
        case hidden = -100, top = 0.0, center = 0.1
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
        var settings: GameSettings?
        var steps: Int = 0
        var verticalDragHandled = false
        private(set) var storedSteps: Int = 0
        var valueChanged: Bool { storedSteps != steps }
        mutating func compareSteps(to valueSteps: Int) {
            if steps < valueSteps {
                if settings!.history.canUndo {
                    steps = valueSteps
                    settings!.previewUndoHistory()
                }
            } else if steps > valueSteps {
                if settings!.history.canRedo {
                    steps = valueSteps
                    settings!.previewRedoHistory()
                }
            }
        }
        mutating func set(settings: GameSettings) {
            self.settings = settings
        }
    }
    
    // has a link to history
    @GestureState var modifyHistory = HistoryControl()
    
    var dragHistoryGesture : some Gesture {
        DragGesture(minimumDistance: 60)

            .updating($modifyHistory) { value, historyControl, _ in
                
                switch value.dir {
                case .up: // is handled only once
                    if historyControl.verticalDragHandled { return }
                    withAnimation() { menuBarPosition.moveUp() }
                    historyControl.verticalDragHandled = true
                case .down: // is handled only once
                    if historyControl.verticalDragHandled { return }
                    withAnimation() { menuBarPosition.moveDown() }
                    historyControl.verticalDragHandled = true
                default:
                    historyControl.verticalDragHandled = true
                    historyControl.set(settings: settings)
                    withAnimation() {
                        historyControl.compareSteps(to: value.steps)
                    }
                }
            }
            .onEnded() { value in
                // update history changes
                withAnimation() {
                    settings.updateHistory()
                }
            }
    }
}

/// an extension to measure steps and direction of movement
extension DragGesture.Value {
    var steps: Int {
        Int((location.xDelta(startLocation) / 60).rounded(.towardZero))
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
        if to.above(from) { return .up }
        if to.below(from) { return .down }
        if to.left(from) { return .left }
        if to.right(from) { return .right }
        return .none
    }
}

extension CGPoint {
    func xDeltaRelevant(_ point: CGPoint) -> Bool {
        abs(x  - point.x) > abs(y - point.y)
    }
    
    /// x.xDelta(point)
    func xDelta(_ point: CGPoint) -> CGFloat {
        xDeltaRelevant(point) ?
            point.x - x : 0
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
