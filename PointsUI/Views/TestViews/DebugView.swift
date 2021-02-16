//
//  DebugView.swift
//  PointsUI
//
//  Created by Alexander Völz on 29.01.21.
//  Copyright © 2021 Alexander Völz. All rights reserved.
//
/// Debug View

/// add data to the log, use as overlay or in ZStack

import SwiftUI

struct Message: Identifiable {
    var id = UUID()
    private(set) var content: String
    
    init(_ msg: String) {
        self.content = msg
    }
    
    var description: String { content }
}

class DebugLog: ObservableObject {
    @Published var messages: [Message] = []
    @Published var error: [Message] = []
    
    func log(msg: String) {
        messages.append(Message(msg))
    }
    
    func err(msg: String) {
        error.append(Message(msg))
    }
}

struct DebugView: View {
    
    @EnvironmentObject var debugLog: DebugLog
    
    var body: some View {
        HStack {
            ScrollView {
                ForEach(debugLog.messages) { line in
                    Text(line.description)
                }
            }
            .background(Color.white.opacity(0.5))

            Divider()
            
            ScrollView {
                ForEach(debugLog.error) { line in
                    Text(line.description)
                }
            }
            .background(Color.white.opacity(0.5))
            .foregroundColor(.red)
        }
        .padding()
        .background(Color.black.opacity(0.1))
        .cornerRadius(10.0)
        .offset(offsetSize)
        .gesture(dragGesture)
    }
    
    var offsetSize: CGSize { moveStore + movedDistance.delta }
    @State var moveStore: CGSize = .zero
    @GestureState var movedDistance = MovingObject()
    
    struct MovingObject {
        var start: CGPoint = .zero
        var end: CGPoint = .zero
        
        var delta: CGSize {
            CGSize(width: end.x - start.x,
                   height: end.y - start.y)
        }
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onEnded() { _ in
                moveStore += movedDistance.delta
            }
            .updating($movedDistance) { gestureValue, gestureState, transaction in
                gestureState = MovingObject(start: gestureValue.startLocation,
                                            end: gestureValue.location)
                moveStore += movedDistance.delta
            }
    }
    
}

func +(lhs: CGSize, rhs: CGSize) -> CGSize {
    CGSize(width: lhs.width + rhs.width,
           height: lhs.height + rhs.height)
}

func +=(lhs: inout CGSize, rhs: CGSize) {
    lhs = lhs + rhs
}

struct DebugTestView: View {
    @StateObject var logger = DebugLog()
    
    var body: some View {
        VStack {
            HStack {
                Button("Create Log Entry") {
                    logger.log(msg: "another log Item")
                }
                Button("Create Error Entry") {
                    logger.err(msg: "another error Item")
                }
            }
            
            DebugView()                .frame(width: 400,height: 400)
        }
        .environmentObject(logger)
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugTestView()
    }
}
