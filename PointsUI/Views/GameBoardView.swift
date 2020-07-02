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
    @State var rotation: Double = 0.0
    
    var dragGesture : some Gesture {
        DragGesture()
        .onChanged() { value in
            if let startLocation = startingLocation {
                let distance = value.location.x - startLocation.x
                dragAmount = CGSize(width: distance,
                                    height: 0)
                rotation = Double(distance / 5)
            } else {
                startingLocation = value.location
            }
        }
        .onEnded() { value in
            if dragAmount.width > 100.0 {
                viewIndex = (viewIndex + 1) % viewTypes.count
            } else if  dragAmount.width < -100.0 {
                viewIndex = (viewIndex - 1 + viewTypes.count) % viewTypes.count
            }
            startingLocation = nil
            dragAmount = .zero
            rotation = 0.0
        }
    }
    
    var body: some View {
        ZStack {
            switch activeView {
            case .currentState:
                BoardUI(players: settings.players)
            case .diffHistory:
                ScoreTableView(history: settings.history, viewMode: .diff)
            case .sumHistory:
                ScoreTableView(history: settings.history, viewMode: .total)
            }
        }
        .rotationEffect(Angle(degrees: rotation), anchor: .bottom)
        .transition(.slide)
        .offset(dragAmount)
        .environmentObject(settings)
        .gesture(dragGesture)
    }
}

struct GameBoardView_Old: View {
    @EnvironmentObject var settings: GameSettings
    
    var body: some View {
        TabView {
            BoardUI(players: settings.players)
                .tabItem({ Image(systemName: "rectangle.grid.2x2")})
                .tag(0)
            
            ScoreTableView(history: settings.history, viewMode: .diff)
                .tabItem({ Image(systemName: "table") })
                .tag(1)
            
            ScoreTableView(history: settings.history, viewMode: .total)
                .tabItem({ Image(systemName: "table.fill") })
                .tag(2)
        }
        .environmentObject(settings)

    }
}


struct GameBoardView_Previews: PreviewProvider {
    static var previews: some View {
        GameBoardView()
    }
}
