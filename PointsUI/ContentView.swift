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
        settings.history.undoBuffer.count
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.boardbgColor
                    .edgesIgnoringSafeArea(.all)
                
                ZStack {
                    
                    VStack {
                        if menuBarPosition == .top {
                            menu
                        }

                        MainGameView()
                            .blur(radius: blurRadius)

                        
                        if menuBarPosition == .bottom {
                            menu
                        }
                    }
                    
                    // MARK: History Views
                    if showHistory {
                        GeometryReader { geo in
                            historyView(sized: geo.size)
                                .scaleEffect(0.9)
                                .offset(x: 0, y: 100)
                        }
                    }
                }
                .popover(isPresented: $showInfo) {
                    NavigationView {
                        InfoView()
                    }
                }

            }
            .popover(isPresented: $showSettings) {
                NavigationView {
                    SettingsView()
                }
                .environmentObject(settings)
            }

            .statusBar(hidden: true)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .navigationTitle(settings.rule.description)
            // MARK: Gestures
            .onTapGesture() {
                withAnimation() {
                    showHistory = false
                    settings.editingPlayer = nil
                }
            }
            .simultaneousGesture(dragHistoryGesture)
            
            // MARK: Popovers
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(settings)
    }
    
    var menu: some View {
        MenuBar(showSettings: $showSettings,
                showInfo: $showInfo,
                showHistory: $showHistory,
                tokenState: $settings.players.token.state,
                steps: stepsToUndo
                )
            .padding(.horizontal)
            .zIndex(1) // needs to be in front for buttons to work...
//            .drawingGroup()
//            .offset(x: 0, y: menuBarPosition.rawValue)
            .shadow(color: .black, radius: 10, x: 8, y: 8)
    }
    
    // MARK: - overlay View triggers
    @State var showInfo: Bool = false
    @State var showSettings: Bool = false
        
    // MARK: - History View
    @State private var showHistory: Bool = false
    
    private var blurRadius : CGFloat { blurBackground ? 4.0 : 0.0 }
    private var blurBackground: Bool { showHistory || showInfo || showSettings }
    
    func historyView(sized geometrySize: CGSize) -> some View {
        let heightFactor: CGFloat = 0.7
        let height = geometrySize.height * heightFactor
        
        // NOTE: use @ScaledMetric for height? Use maxHeight, instead? ScaleFactor?
        return ScoreHistoryView(showBuffer: modifyHistory.steps != 0)
            .frame(height: height)
            .emphasizeShape(cornerRadius: 16.0)
            .transition(.opacity)
            .padding()
    }
    
    // MARK: - Status Bar
    enum BarPosition : CGFloat {
        case hidden = -100, top = 0.0, center = 0.1, bottom = 800
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
                self = .bottom
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
                    settings?.undoHistory()
                }
            } else if steps > valueSteps {
                if settings!.history.canRedo {
                    steps = valueSteps
                    settings?.redoHistory()
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
        DragGesture(minimumDistance: 800)

            .updating($modifyHistory) { value, historyControl, _ in
                
                switch value.dir {
                case .up: // is handled only once
                    if historyControl.verticalDragHandled { return }
                    withAnimation() { menuBarPosition.moveUp() }
                    historyControl.verticalDragHandled = true
                    break
                case .down: // is handled only once
                    if historyControl.verticalDragHandled { return }
                    withAnimation() { menuBarPosition.moveDown() }
                    historyControl.verticalDragHandled = true
                    break
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
    
    /// determines how many steps where taken. WARNING: step length is a global constant (60) (Magic Number!)
    var steps: Int {
        Int((location.xDelta(startLocation) / 60).rounded(.towardZero))
    }

    /// return in which direction the drag was done
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
