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
                            showInfo: $showInfo,
                            showHistory: $showHistory,
                            steps: modifyHistory)
                        .padding([.horizontal, .top])
                        .offset(x: 0, y: menuBarPosition == .hidden ? -500 : 0)
                        .zIndex(1) // needs to be in front for buttons to work...
                        .drawingGroup()
                        .shadow(color: .black, radius: 10, x: 8, y: 8)
                    
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
        
    @GestureState var modifyHistory: Int = 0
    
    var dragGesture : some Gesture {
        DragGesture(minimumDistance: 30)
            .updating($modifyHistory) { value, state, _ in
                let dir : Direction = Direction
                    .move(from: value.startLocation,
                          to: value.location)

                state = Int((value
                                .startLocation
                                .xDelta(value.location) / 30)
                                .rounded(.towardZero))

                switch dir {
                case .left:
                    withAnimation() {
                        settings.previewHistorySteps(steps: -state)
                    }
                case .right:
                    withAnimation() {
                        settings.previewHistorySteps(steps: state)
                    }
                default:
                    break
                }
            }
            .onEnded() { value in
                let dir : Direction = Direction.move(from: value.startLocation,
                                                     to: value.location)
                switch dir {
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
    
    func xDelta(_ point: CGPoint) -> CGFloat {
        abs(point.x - x)
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
