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
    var activeView: GameBoardViewType { viewTypes[viewIndex % viewTypes.count]}
    let viewTypes : [GameBoardViewType] =  [ .currentState, .diffHistory, .sumHistory ]
    @State var viewIndex = 0
    
    var body: some View {
        ZStack {
            Color.background.opacity(almostInvisible)
                .gesture(dragGesture, including: .all)

            switch activeView {
            case .currentState:
                BoardUI()
                    .gesture(historyGesture)
            case .diffHistory:
                ScoreTableView(viewMode: .diff)
            case .sumHistory:
                ScoreTableView(viewMode: .total)
            }
            
            if showHistorySymbols {
                if settings.canUndo || settings.canRedo {
                    HistorySymbolRow(activeSide: historySymbol, animationState: historySymbolAnimationState)
                }
            }
        }
        .environmentObject(settings)
        .offset(dragAmount)
    }
    
    @State var historySymbolAnimationState = OverlayHistorySymbol.initial
    
    // MARK: - constants
    let almostInvisible : Double = 0.01
    let distanceToSwipe : CGFloat = 120
    
    // MARK: - gestures
    var dragAmount: CGSize {
        if let startX = startingSwipePosition?.x {
            return CGSize(width: (endingSwipePosition?.x ?? 0 - startX),
                          height: 0)
        } else {
            return CGSize.zero
        }
    }
    
    @State var startingSwipePosition : CGPoint?
    @State var endingSwipePosition : CGPoint?
    
    var dragGesture : some Gesture {
        DragGesture()
            .onChanged() { value in
                guard !longPress else { return }
                startingSwipePosition = value.location
            }
            .onEnded() { value in
                guard !longPress else { return }
                endingSwipePosition = value.location
                if dragAmount.width > distanceToSwipe {
                    viewIndex = (viewIndex + 1) % viewTypes.count
                } else if  dragAmount.width < -distanceToSwipe {
                    viewIndex = (viewIndex - 1 + viewTypes.count) % viewTypes.count
                }
                startingSwipePosition = nil
                endingSwipePosition = nil
            }
    }
    
    let distanceForHistory: CGFloat = 10
    
    @State var showHistorySymbols = false
    @State var historySymbol : OverlayHistorySymbol.Side?
    @GestureState var longPress : Bool = false

    var historyGesture : some Gesture {
        let longPress = LongPressGesture(minimumDuration: 2.0)
            .updating($longPress) { _, _, _ in
                showHistorySymbols = true
            }
//            .onEnded { _ in
//                showHistorySymbols = false
//            }
        
        let dragGesture = DragGesture(minimumDistance: 20)
            .onChanged() { value in
                if value.translation.width < 0 {
                    historySymbol = .left
                } else {
                    historySymbol = .right
                }
                historySymbolAnimationState = OverlayHistorySymbol.selected
            }
            .onEnded() { value in
                if value.translation.width < 0 {
                    settings.undo()
                    
                } else {
                    settings.redo()
                }
                historySymbolAnimationState = OverlayHistorySymbol.final
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
