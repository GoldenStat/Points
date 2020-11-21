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
    
    var objects : [Player] {
        settings.players.items
    }
        
    var oneColumn : [GridItem]  { [
        GridItem(.flexible())
    ] }
    
    var twoColumns : [GridItem]  { [
        GridItem(.flexible()),
        GridItem(.flexible())
    ] }
    
    var vGridItems : [GridItem] {
        objects.count == 2 ? oneColumn : twoColumns
    }
    
    var body: some View {
        ZStack {
            Color.invisible
            if UIDevice.current.orientation.isLandscape {
                // in landscape we put all players in a row -- there is always enough space
                HStack() {
                    playerViews
                }
            } else {
                // not landscape
                LazyVGrid(columns: vGridItems
                ) {
                    playerViews
                }
            }
            
            if let bufferPosition = bufferPosition, let bufferScore = settings.pointBuffer {
                BufferView(score: Score(0, buffer: bufferScore))
                    .position(bufferPosition)
            }
        }
    }
    
    @State var bufferPosition : CGPoint? = nil
    @ViewBuilder var playerViews : some View {
        let variableRatio : CGFloat = objects.count == 2 ? 1.0 : 0.5
        ForEach(settings.players.items) { player in
            PlayerView(player: player)
                .aspectRatio(variableRatio, contentMode: .fill)
                .gesture(buildDragGesture(forPlayer: player))
        }
    }
    
    // MARK: - DragGesture
    
    /// bufferDragGesture
    /// - when we start dragging from a view, we fill the gameState's buffer with that view's players buffer points
    private func buildDragGesture(forPlayer player: Player) -> some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .global)
                    .onChanged() { value in
                        bufferPosition = value.location
                        settings.pointBuffer = player.score.buffer
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
