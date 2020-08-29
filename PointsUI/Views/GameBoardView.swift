//
//  GameBoardView.swift
//  PointsUI
//
//  Created by Alexander Völz on 25.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

enum GameBoardViewType {
    case currentState, diffHistory, sumHistory
}

struct GameBoardView: View {
    @EnvironmentObject var settings: GameSettings
    var activeView: GameBoardViewType { viewTypes[viewIndex % viewTypes.count] }
    let viewTypes : [GameBoardViewType] =  [ .currentState,
                                             .diffHistory,
    ]
    
    @State var viewIndex = 0
    
    var body: some View {
        ZStack {
            Color.background.opacity(almostInvisible)
                .gesture(
                    dragGesture)

            switch activeView {
            case .currentState:
                BoardUI()
            case .diffHistory:
                ScoreTableView(viewMode: .diff)
            case .sumHistory:
                ScoreTableView(viewMode: .total)
            }
        }
        .environmentObject(settings)
//        .offset(dragAmount)
//        .rotation3DEffect(
//            .degrees(min(Double(dragAmount.width)/4,maxRotation)),
//            axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/,
//            anchor: .center,
//            anchorZ: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/,
//            perspective: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/
//        )
//        .animation(.default)
    }
    
    // MARK: - constants
    let almostInvisible : Double = 0.01
    let distanceToSwipe : CGFloat = 120
    let maxRotation : Double = 80
    
    // MARK: - gestures
    var dragAmount: CGSize {
        let start = startLocation?.x ?? 0
        let end = endLocation?.x ?? 0
        let distance = (end - start) * 1.5
        return CGSize(width: distance,
                      height: 0)
    }

    @State var startLocation: CGPoint?
    @State var endLocation: CGPoint?

    var dragGesture : some Gesture {
        DragGesture()
        .onChanged() { value in
            startLocation = startLocation ?? value.location
            endLocation = value.location
        }
        .onEnded() { value in
            if dragAmount.width > distanceToSwipe {
                viewIndex = (viewIndex + 1) % viewTypes.count
            } else if  dragAmount.width < -distanceToSwipe {
                viewIndex = (viewIndex - 1 + viewTypes.count) % viewTypes.count
            }
            startLocation = nil
            endLocation = nil
        }
    }
}

struct GameBoardView_Previews: PreviewProvider {
    static var previews: some View {
        GameBoardView()
            .environmentObject(GameSettings())
    }
}
