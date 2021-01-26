//
//  HistoryControlView.swift
//  PointsUI
//
//  Created by Alexander Völz on 25.01.21.
//  Copyright © 2021 Alexander Völz. All rights reserved.
//

import SwiftUI

struct HistoryControlsTestView: View {
    
    var body: some View {
        ZStack {
            Color.blue
                .cornerRadius(24.0)
                .padding()
            
            VStack {
                
                if showSymbol {
                    Image(systemName: systemImageName)
                        .resizable()
                        .rotationEffect(rotation)
                        .frame(width: 78, height: 78)
                        .transition(.opacity)
                        .scaleEffect(scaleEffect)
                        .animation(animation)
                    
                }
                if steps > 0 {
                    Text("Steps to redo: \(abs(steps))")
                } else if steps < 0 {
                    Text("Steps to undo: \(abs(steps))")
                }
            }
            if let start = startDraggingLocation {
                Circle()
                    .fill(Color.white)
                    .opacity(0.2)
                    .frame(width: 10, height: 10)
                    .position(start)
            }
            
            if let end = endDraggingLocation {
                Circle()
                    .fill(Color.white)
                    .opacity(0.3)
                    .frame(width: 10, height: 10)
                    .position(end)
            }
        }
        .gesture(firstGesture.sequenced(before: secondGesture))
    }
    
    var systemImageName: String {
        animateImage ? "arrow.up.circle" : "circle"
    }
    
    let animation: Animation = .spring(response: 0.4, dampingFraction: 0.4, blendDuration: 1.0)
    
    var rotation: Angle {
        if animateImage {
            if dragLength < 0 {
                return .degrees(-90)
            }
            return .degrees(90)
        }
        return .zero
    }
    
    var steps: Int { Int((dragLength / minMovement).rounded(.towardZero)) }
    
    var scaleEffect: CGFloat { animateImage ? 1.3 : 1 }
    
    let minMovement : Double = 50
    
    var showSymbol: Bool { isActivated }
    
    var animateImage: Bool {
        abs(dragLength) > minMovement
    }
    
    @State var startDraggingLocation: CGPoint?
    @State var endDraggingLocation: CGPoint?
    
    var dragLength: Double {
        Double(endDraggingLocation?.x ?? startDraggingLocation?.x ?? 0) - Double(startDraggingLocation?.x ?? 0)
    }
    
    @GestureState var longPressDetected: Bool = false
    var firstGesture: some Gesture {
        LongPressGesture(minimumDuration: 1)
            .updating($longPressDetected) { currentstate, gestureState,
                                            transaction in
                gestureState = currentstate
            }
            .onEnded() { didEnd in
                isActivated = true
            }
    }
    
    @State var isActivated = false
    @State var gesturesStarted = false
    
    @GestureState var isDraging: Bool = false
    @State var isDragging: Bool = false
    var secondGesture: some Gesture {
        
        DragGesture()
            .onChanged() { changed in
                if !isDragging {
                    startDraggingLocation = changed.location
                    isDragging = true
                } else {
                    endDraggingLocation = changed.location
                }
            }
            .onEnded() { changed in
                startDraggingLocation = nil
                endDraggingLocation = nil
                isDragging = false
                gesturesStarted = false
                isActivated = false
            }
        
    }
}

struct HistoryControlsTestView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryControlsTestView()
    }
}
