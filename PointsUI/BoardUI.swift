//
//  BoardUI.swift
//  Points
//
//  Created by Alexander Völz on 20.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

/// the whole board, all player's points are seen here
struct BoardUI: View {
    @EnvironmentObject var settings: GameSettings
    
    var objects : Int {
        settings.players.count
    }
        
    var vGridItems : [GridItem] { [
        GridItem(.flexible()),
        GridItem(.flexible())
    ] }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.invisible
                if UIDevice.current.orientation.isLandscape {
                    // in landscape we put all players in a row -- there is always enough space
                    HStack() { playerViews }
                        .frame(maxHeight: geo.size.height)
                        .padding(.vertical)
                } else {
                    // not landscape
                    // can't get it to work with LazyVGrid
                    Group {
                        if objects == 2 {
                            VStack { playerViews }
                        } else {
                            LazyVGrid(columns: vGridItems, alignment: .center) {
                                playerViews
                            }
                        }
                    }
                }
                
                if let bufferPosition = bufferPosition, let bufferScore = settings.pointBuffer {
                    let centeredPosition = CGPoint(x: bufferPosition.x - bufferViewSize / 2.0,
                                                   y: bufferPosition.y - bufferViewSize / 2.0)
                    BufferView(score: Score(0, buffer: bufferScore))
                        .position(centeredPosition)
                }
            }
            .ignoresSafeArea(edges: .all)
        }
    }
    
    let bufferViewSize : CGFloat = 144.0
        
    @ViewBuilder private var playerViews : some View {
        ForEach(settings.players.items, id: \.id) { player in
            PlayerView(player: player, activePoint: $dragEndedLocation)
                .frame(minHeight: 200)
                .aspectRatio(contentMode: .fit)
                .gesture(buildDragGesture(forPlayer: player))
                .coordinateSpace(name: player.name)
        }
    }
    
    // MARK: - DragGesture
    
    /// bufferDragGesture
    /// - when we start dragging from a view, we fill the gameState's buffer with that view's players buffer points
    @State private var bufferPosition : CGPoint? = nil
    @State var dragEndedLocation: CGPoint?
    private func buildDragGesture(forPlayer player: Player) -> some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .global)
                    .onChanged() { value in
                        bufferPosition = value.location
                        let buffer = player.score.buffer
                        if buffer > 0 {
                            settings.cancelTimer()
                            settings.pointBuffer = player.score.buffer
                        }
                    }
                    .onEnded() { value in
                        // find in which view we are and apply the buffer to that view's player's gesture
//                        guard let targetPlayer = player(for: value.location),
//                              targetPlayer != player else { return }
//
//                        guard let targetView = playerView(for: value.location) else { return }
//
//                        targetPlayer.score.buffer += player.score.buffer
                        dragEndedLocation = value.location
                        
                        settings.fireTimer()
                        settings.pointBuffer = nil
                    }
    }
}

struct BoardUI_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BoardUI()
                .environmentObject(GameSettings())
            BoardUI()
                .preferredColorScheme(.dark)
                .environmentObject(GameSettings())
        }
    }
}
