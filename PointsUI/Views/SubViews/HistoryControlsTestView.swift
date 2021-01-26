//
//  HistoryControlView.swift
//  PointsUI
//
//  Created by Alexander Völz on 25.01.21.
//  Copyright © 2021 Alexander Völz. All rights reserved.
//

import SwiftUI

struct HistoryControlsTestView: View {
    
    @State private var isActivated = false

    var body: some View {
        ZStack {
            Color.blue
                .cornerRadius(24.0)
                .padding()
            
            VStack {
                
                if isActivated {
                    HistoryButtonView(rotation: discreteRotation)
                        .animation(.easeInOut)
                        .transition(.opacity)
                }
            }
        }
        .gesture(rotationGesture)
        .onTapGesture {
            withAnimation(.linear(duration: 1.0)) {
                isActivated.toggle()
            }
        }
    }
    
    var discreteRotation: Angle { .degrees(discreteMargin * Double(steps)) }
    let discreteMargin: Double = 30
    @GestureState private var steps: Int = 0

    /// the rotation to control history updates:
    /// ever 30 degrees mean one step
    /// translate rotation gesture to a discrete value and avoid "jumps"
    var rotationGesture: some Gesture {
        RotationGesture()
            .onEnded() { (_) in
                updateHistory()
            }
            .updating($steps) { rotationValue, steps, transaction in
                
                let newSteps = Int((rotationValue.degrees / discreteMargin).rounded(.towardZero))
                if abs(newSteps - steps) <= 1 {
                    steps = newSteps
                }
            }
    }
    
    func updateHistory() {
        // update the History with so many steps
    }
    
    func previewHistoryUpdate() {
        // check what an update of so many steps would do to history
    }
        
    
}

struct HistoryButtonView: View {
    var rotation: Angle
    
    var body: some View {
        ZStack {
            Circle()
                .animation(nil)
            Circle()
                .fill(Color.white)
                .opacity(0.9)
                .offset(x: 0, y: -60)
                .shadow(color: .white, radius: 4, x: 0, y: 2)
                .frame(width: 20, height: 20)
                .animation(nil)
        }
        .rotationEffect(rotation)
        .shadow(color: Color/*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 10, y: 10)
        .frame(width: 200, height: 200)
    }
}

struct HistoryControlsTestView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryControlsTestView()
    }
}
