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
    
    @State var dragAmount: CGSize = .zero
    @State var startingLocation: CGPoint?
    
    var dragGesture : some Gesture {
        DragGesture()
        .onChanged() { value in
            if let startLocation = startingLocation {
                let distance = value.location.x - startLocation.x
                dragAmount = CGSize(width: distance * 2.0,
                                    height: 0)
            } else {
                startingLocation = value.location
            }
        }
        .onEnded() { value in
            if dragAmount.width > distanceToSwipe {
                viewIndex = (viewIndex + 1) % viewTypes.count
            } else if  dragAmount.width < -distanceToSwipe {
                viewIndex = (viewIndex - 1 + viewTypes.count) % viewTypes.count
            }
            startingLocation = nil
            dragAmount = .zero
        }
    }
    
    var body: some View {
        ZStack {
            Color.white.opacity(almostInvisible)
            
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
        .offset(dragAmount)
        .gesture(dragGesture)
    }
    
    let almostInvisible : Double = 0.01
    let distanceToSwipe : CGFloat = 120
}

struct GameBoardView_Previews: PreviewProvider {
    static var previews: some View {
        GameBoardView()
    }
}
