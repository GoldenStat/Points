//
//  HistoryControlTestView.swift
//  PointsUI
//
//  Created by Alexander Völz on 25.01.21.
//  Copyright © 2021 Alexander Völz. All rights reserved.
//

import SwiftUI

struct HistoryControlsTestView: View {
    @EnvironmentObject var settings: GameSettings
    var history : History { settings.history }
    @State private var isActivated = true
    @StateObject var logger = DebugLog()
    
    @State private var selecting = false
    
    var body: some View {
        ZStack {

            VStack {
                ScoreHistoryView()
                HistoryScoreGeneratorButton()
            }
            
            HistoryControlKnob(selecting: $selecting)
                .opacity(selecting ? 1.0 : 0.3)
                .animation(.easeInOut)
                .offset(x: 0, y: 180)
        }
        .overlay(
            DebugView()                .frame(width: 400,height: 400)
        )
        .environmentObject(logger)
    }
}


/// a knob that controls history undo/redo functions
struct HistoryControlKnob: View {
    @Binding var selecting: Bool
    
    @EnvironmentObject var settings: GameSettings
    var history: History { settings.history }
    
    var body: some View {
        ZStack {
            ZStack {
                // big knob
                Circle()
                    .animation(nil)
                
                // smaler knob for orientation
                Circle()
                    .fill(Color.white)
                    .opacity(0.9)
                    .shadow(color: .white, radius: 4, x: 0, y: 2)
                    .offset(x: 0, y: -60)
                    .frame(width: 20, height: 20)
                    .animation(nil)
            }
            .rotationEffect(discreteRotation)
            // add animation effect for the rotation
            .animation(.easeInOut)
            .shadow(color: Color/*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 10, y: 10)
            
            if steps != 0 {
                BufferView(score: Score(0, buffer: historySteps))
                    .foregroundColor(Color.white.opacity(0.8))
                    .animation(nil)
            }

        }
        .frame(width: 200, height: 200)
        .gesture(LongPressGesture(minimumDuration: 0.5).onEnded {_ in
            selecting = true
        }
        .sequenced(before: (rotationGesture)))
    }
    
    var discreteRotation: Angle { .degrees(discreteMargin * Double(steps)) }
    let discreteMargin: Double = 30
    @GestureState private var steps: Int = 0

    @State private var startGestureLocation: CGPoint? = nil
    
    /// the rotation to control history updates:
    /// ever 30 degrees mean one step
    /// translate rotation gesture to a discrete value and avoid "jumps"
    var rotationGesture: some Gesture {
        DragGesture()
            .onEnded() { (_) in
                updateHistory()
                selecting = false
                startGestureLocation = nil
            }
            .updating($steps) { value, steps, transaction in
                selecting = true
                if let start = startGestureLocation {
//                let reference = value.degrees
                    let referenceValue = Double(start.x - value.location.x)
                let newSteps = Int((referenceValue / discreteMargin).rounded(.towardZero))
                if abs(newSteps - steps) <= 1 {
                    steps = newSteps
                }
                } else {
                    startGestureLocation = value.location
                }
            }
    }
    
    /// show the redo-stack? only while the knob is turning. This is like a preview of what would happen
    var showPreview: Bool { steps != 0 }
    
    var historyFunction: ()->() {
        steps < 0 ? history.undo : history.redo }
    
    var maxHistorySteps: Int { steps == 0 ? 0 : steps < 0 ? history.maxUndoSteps : history.maxRedoSteps }

    var historySteps: Int { min(abs(steps), maxHistorySteps) }

    func updateHistory() {
        // update the History with so many steps
        for _ in 0 ..< historySteps {
            historyFunction()
        }
    }
        
}

struct HistoryControlsTestView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryControlsTestView()
            .environmentObject(GameSettings())
    }
}
