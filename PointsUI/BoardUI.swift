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
            ZStack {
                Color.invisible
                if UIDevice.current.orientation.isLandscape {
                    // in landscape we put all players in a row -- there must be enough space
                    HStack() {
                        playerViews
                    }
                } else {
                    // not landscape
                    // can't get it to work with LazyVGrid
                    LazyVGrid(columns: vGridItems, alignment: .center, spacing: 0) {
                        playerViews
                    }
                }

                if let buffer = settings.pointBuffer {
                    let centeredPosition = CGPoint(x: buffer.position.x - bufferViewSize / 2.0,
                                                   y: buffer.position.y - bufferViewSize)
                    BufferView(score: Score(0, buffer: buffer.points))
                        .position(centeredPosition)
                    
                    if showBufferContents {
                    BufferSpaceDebugView(bufferSpace: settings.pointBuffer)
                        .padding(.bottom)
                    }
                }
        }
        .ignoresSafeArea(edges: .all)
    }
    
    private let showBufferContents = false
    
    let bufferViewSize : CGFloat = 144.0
        
    @ViewBuilder private var playerViews : some View {
        ForEach(settings.players.items) { player in
            PlayerView(player: player)
                .onDrag() {
                    settings.cancelTimers()
                    settings.pointBuffer = BufferSpace(position: CGPoint.zero, points: player.score.buffer)
                    return NSItemProvider(object: "\(player.score.buffer)" as NSString)
                }
                .onDrop(of: ["public.utf8-plain-text"], isTargeted: nil) { provider in
                    guard let pkg = provider.first, pkg.canLoadObject(ofClass: NSString.self) else {
                        return false
                    }
                    _ = pkg.loadObject(ofClass: NSString.self) { reading, error in
                        if let string = reading as? String {
                            if let buffer = Int(string) {
                                player.add(score: buffer)
                                DispatchQueue.main.async {
                                    settings.startCountDown()
                                }
                            }
                        }
                    }

                    return true
                }
                .simultaneousGesture(buildDragGesture(forPlayer: player))
                .coordinateSpace(name: player.name)
        }
    }
    
    // MARK: - DragGesture
    
    /// bufferDragGesture
    /// - when we start dragging from a view, we fill the gameState's buffer with that view's players buffer points
    private func buildDragGesture(forPlayer player: Player) -> some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .global)
                    .onChanged() { value in
                        let buffer = player.score.buffer
                        if buffer != 0 {
                            settings.cancelTimers()
                            let location = value.location.applying(.init(translationX: 60, y: 60))
                            settings.pointBuffer = BufferSpace(position: location, points: buffer)
                        }
                    }
                    .onEnded() { value in
                        if let pointBuffer = settings.pointBuffer {
                            pointBuffer.wasDropped = true
                        }
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
