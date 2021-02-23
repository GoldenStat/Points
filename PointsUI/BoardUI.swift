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
            VStack {

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
            }
        }
        .onRotate(perform: {_ in print()})
        .ignoresSafeArea(edges: .all)
    }
    
    private let showBufferContents = true
    
    let bufferViewSize : CGFloat = 144.0
        
    @ViewBuilder private var playerViews : some View {
        ForEach(settings.players.items) { player in
            PlayerView(player: player)
                // to receive drop values, the .onDrag must be called in the correspondent subview
                .onDrop(of: ["public.utf8-plain-text"], isTargeted: nil) { provider in
                    guard let pkg = provider.first, pkg.canLoadObject(ofClass: NSString.self) else {
                        // just to make sure we have the buffer
                        return false
                    }
                    _ = pkg.loadObject(ofClass: NSString.self) { reading, error in
                        if let string = reading as? String {
                            if let buffer = Int(string) {
                                DispatchQueue.main.async {
                                    withAnimation(.easeInOut(duration: 2.0)) {
                                        // overwrite what's in the buffer
                                        player.store(score: buffer)
                                        settings.storeInHistory()
                                    }
                                    settings.startTimer()
                                }
                            }
                        }
                    }
                    return true
                }
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
