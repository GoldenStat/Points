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
        
    var vGridItems : [GridItem] {[
        GridItem(.flexible()),
        GridItem(.flexible())
    ]}
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.invisible
                if UIDevice.current.orientation.isLandscape {
                    // in landscape we put all players in a row -- there is always enough space
                    HStack() { playerViews }
                        .frame(maxHeight: geo.size.height)
                } else {
                    // not landscape
                    // can't get it to work with LazyVGrid
                    Group {
                        if objects == 2 {
                            VStack {
                                playerViews
                            }
                        } else {
                            LazyVGrid(columns: vGridItems, alignment: .center) {
                                playerViews
                            }
                        }
                    }
                    .frame(height: geo.size.width * 3.0 / 2.0)
                }
                
                if let bufferPosition = bufferPosition, let bufferScore = settings.pointBuffer {
                    BufferView(score: Score(0, buffer: bufferScore))
                        .position(bufferPosition)
                }
            }
            .padding()
        }
    }
        
    @ViewBuilder private var playerViews : some View {
        ForEach(settings.players.items, id: \.id) { player in
            PlayerView(player: player)
                .gesture(buildDragGesture(forPlayer: player))
                
                // MARK: for drag'n drop
//                .onDrag { return NSItemProvider(object: player.score.buffer.description) }
//                .onDrop(of: [String], isTargeted: $isTargetedByDrop) {
//                    values in
//                    if let value = values.first {
//                        if let number = Int(value) {
//                            player.score.buffer = number
//                            return true
//                        }
//                    }
//                    return false
//                }
        }
    }
    
    // MARK: - DragGesture
    
    /// bufferDragGesture
    /// - when we start dragging from a view, we fill the gameState's buffer with that view's players buffer points
    @State private var bufferPosition : CGPoint? = nil
    private func buildDragGesture(forPlayer player: Player) -> some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .global)
                    .onChanged() { value in
                        bufferPosition = value.location
                        let buffer = player.score.buffer
                        if buffer > 0 {
                            settings.pointBuffer = player.score.buffer
                        }
                    }
                    .onEnded() { value in
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
