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
//                                             .sumHistory
    ]
    
    @State var viewIndex = 0
    
    var body: some View {
        ZStack {
            Color.background.opacity(almostInvisible)
                .gesture(
//                    historyGesture
//                            .exclusively(before:
                    dragGesture)
//            )

            switch activeView {
            case .currentState:
                BoardUI()
            case .diffHistory:
                ScoreTableView(viewMode: .diff)
            case .sumHistory:
                ScoreTableView(viewMode: .total)
            }
            
//            if showHistorySymbols {
//                if settings.canUndo || settings.canRedo {
//                    HistorySymbolRow(activeSide: historySymbol, animationStateLeft: historySymbolAnimationStateLeft,
//                                     animationStateRight: historySymbolAnimationStateRight)
//                        .transition(.scale)
//                }
//            }
        }
        .environmentObject(settings)
        .offset(dragAmount)
        .rotation3DEffect(
            .degrees(min(Double(dragAmount.width)/4,maxRotation)),
            axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/,
            anchor: .center,
            anchorZ: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/,
            perspective: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/
        )
        .animation(.default)
    }
    
    @State var historySymbolAnimationStateLeft = OverlayHistorySymbol.initial
    @State var historySymbolAnimationStateRight = OverlayHistorySymbol.initial

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
    
    let distanceForHistory: CGFloat = 10

    @State var showHistorySymbols = false
    @State var historySymbol : OverlayHistorySymbol.Side?
    @GestureState var longPress : Bool = false

    var historyGesture : some Gesture {
        let longPress = LongPressGesture(minimumDuration: 2.0)
            .onChanged() { value in
                showHistorySymbols = true
            }

        let dragGesture = DragGesture(minimumDistance: 20)
            .onChanged() { value in
                if value.translation.width < 20 {
                    historySymbol = .left
                    historySymbolAnimationStateLeft = OverlayHistorySymbol.selected
                    historySymbolAnimationStateRight = OverlayHistorySymbol.initial
                } else if value.translation.width > 20{
                    historySymbol = .right
                    historySymbolAnimationStateLeft = OverlayHistorySymbol.selected
                    historySymbolAnimationStateRight = OverlayHistorySymbol.initial
                } else {
                    historySymbol = nil
                    historySymbolAnimationStateLeft = OverlayHistorySymbol.initial
                    historySymbolAnimationStateRight = OverlayHistorySymbol.initial
                }
            }
            .onEnded() { value in
                if value.translation.width < 0 {
                    settings.undo()
                    historySymbolAnimationStateLeft = OverlayHistorySymbol.final
                } else {
                    settings.redo()
                    historySymbolAnimationStateRight = OverlayHistorySymbol.final
                }
                showHistorySymbols = false
            }

        return longPress
            .sequenced(before: dragGesture )
    }
}

struct GameBoardView_Previews: PreviewProvider {
    static var previews: some View {
        GameBoardView()
    }
}
