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
    
    @State var lastOrientation = UIDevice.current.orientation
    
//    var body: some View {
//        ZStack {
//            VStack {
//                if lastOrientation.isLandscape {
//                        playerViews
//                            .asGrid(columns: objects)
//                            .frame(minHeight: 400, maxHeight: 400)
//                } else if lastOrientation.isPortrait {
//                    // can't get it to work with LazyVGrid
//                        playerViews
//                            .asGrid(columns: 2)
//                }
//            }
//        }
//        .onRotate(perform: {
//                    orientation in
//            if orientation == .landscapeLeft || orientation == .landscapeRight || orientation == .portrait {
//                lastOrientation = orientation
//            }
//            withAnimation() { settings.objectWillChange.send() }
//        })
//        .ignoresSafeArea(edges: .all)
//    }


    var body: some View {
        GeometryReader { geom in
            VStack {
                ForEach(0 ..< PlayerGrid.rows) { rowIndex in
                    HStack {
                        ForEach(0 ..< PlayerGrid.cols) { colIndex in
                            let index = PlayerGrid(row: rowIndex, col: colIndex).index
                            if  index < objects {
                                let player = settings.players.items[index]
                                VStack {
                                    CounterView(counter: player.games)
                                        .padding(.horizontal)
                                    playerView(for: player)
                                        .frame(width: geom.size.width / 2,
                                               height: geom.size.height / 2)
                                }
                            }
                        }
                    }
                }
            }
        }
        .ignoresSafeArea(edges: .all)
    }
    
    private let showBufferContents = true
    
    let bufferViewSize : CGFloat = 144.0
    
    /// a player accepting a text-to number convertible onDrop for the buffer
    /// starts a timer
    func playerView(for player: Player) -> some View {
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
    
    @ViewBuilder private var playerViews : some View {
        ForEach(settings.players.items) { player in
            playerView(for: player)
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
