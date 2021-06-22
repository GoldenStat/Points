//
//  ContentView.swift
//  PointsUI
//
//  Created by Alexander Völz on 30.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var settings : GameSettings

    var stepsToUndo: Int {
        settings.history.undoBuffer.count
    }
    
    var body: some View {
            ZStack {
                
                ZStack {
                    
                    VStack {
                        if menuBarPosition == .top {
                            menu
                        }

                        MainGameView()
                            .blur(radius: blurRadius)

                        
//                        if menuBarPosition == .bottom {
//                            menu
//                        }
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
            .background(Color.boardbgColor, ignoresSafeAreaEdges: .all)
        
    }
    
    var menu: some View {
        MenuBar(showSettings: $showSettings,
                showInfo: $showInfo,
                showHistory: $showHistory,
                tokenState: $settings.players.token.state,
                steps: stepsToUndo
                )
            .drawingGroup()
            .padding(.horizontal)
            .zIndex(1) // needs to be in front for buttons to work...
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
            self = .hidden
        }
        
        mutating func moveDown() {
            self = .top
        }
    }

    @State var menuBarPosition = BarPosition.top
    
    struct HistoryControl {
        var steps: Int = 0
        var verticalDragHandled = false
    }
    
    // has a link to history
    @GestureState var modifyHistory = HistoryControl()
    
    var dragHistoryGesture : some Gesture {
        DragGesture(minimumDistance: 80)

            .updating($modifyHistory) { value, historyControl, _ in
                // abort if it was already handled during the gesture
                guard !historyControl.verticalDragHandled else { return }
                
                withAnimation() {
                    switch value.dir {
                    case .up: // is handled only once
                        menuBarPosition.moveUp()
                        break
                    case .down: // is handled only once
                        menuBarPosition.moveDown()
                        break
                    case .left:
                        settings.history.undo()
                    case .right:
                        settings.history.redo()
                    case .none:
                        break
                    }
                historyControl.verticalDragHandled = true
                }
                /// start timer, then update History?
            }
            .onEnded() { value in
                // update history changes - timer, first?
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
