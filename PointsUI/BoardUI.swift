//
//  BoardUI.swift
//  Points
//
//  Created by Alexander Völz on 20.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

/// the whole board, all player's points are seen here
/// here it all comes together:
struct BoardUI: View {
    @EnvironmentObject var settings: GameSettings
    
    var objects : Int {
        settings.players.count
    }
    
    @State var lastOrientation = UIDevice.current.orientation

    // MARK: - main view
    var body: some View {
        // MARK: the player views arranged in a grid
        GeometryReader { geom in
            ZStack { // use all the space
                Color.clear
                // vertical layout
                if geom.size.width < geom.size.height {
                    VStack {
                        ForEach(0 ..< PlayerGrid.rows) { rowIndex in
                            HStack {
                                ForEach(0 ..< PlayerGrid.cols) { colIndex in
                                    let index = PlayerGrid(row: rowIndex, col: colIndex).index
                                    if  index < objects {
                                        let player = settings.players.items[index]
                                        
                                        activePlayerView(for: player)
                                            .frame(width: geom.size.width * 0.5,
                                                   height: geom.size.height * 0.39)
                                            
                                            // MARK: preference data for the views
                                            .anchorPreference(key: TokenAnchorPreferenceKey.self,
                                                              value: .bounds,
                                                              transform: { bounds in
                                                                [TokenAnchor(viewIdx: index, bounds: bounds)]
                                                              })
                                    }
                                }
                            }
                        }
                    }
                } else {
                        // horizontal layout
                        HStack {
                            ForEach(settings.players.items) { player in
                                activePlayerView(for: player)
                                    .frame(width: geom.size.width * 0.9 / CGFloat(objects),
                                           height: geom.size.height * 0.9)

//                                    // MARK: preference data for the views
//                                    .anchorPreference(key: TokenAnchorPreferenceKey.self,
//                                                      value: .bounds,
//                                                      transform: { bounds in
//                                                        [TokenAnchor(viewIdx: index, bounds: bounds)]
//                                                      })
//
                            }
                        }
                }
            }
        }
        .ignoresSafeArea(edges: .all)

        // update the Token with the Player rects
        .overlayPreferenceValue(TokenAnchorPreferenceKey.self) {
            preferences in
            GeometryReader { geometry in
                updateRects(geometry, preferences)
            }
        }
        
        // actions when the view appears:
        // reset players
        // connect settings with token instance
        .onAppear() {
            settings.players.reset()
            token.resetPosition()
            settings.players.token = token
        }
    }
            
    // MARK: - token code
    // manage visual representation and controls active Player
    @State var token : Token = Token()
    @State var tokenLocation = Token().location
    
    var activeIndex: Int? { settings.players.activePlayerIndex }
    
    /// this function is triggered by .overlayPreferenceValue when the geometries change
    /// it creates a token View, this view needs all the preferences of the player's views to calcluate
    /// the token's position
    func updateRects(_ geometry: GeometryProxy,
                     _ preferences: [TokenAnchor]) -> some View {

        token.rects = preferences.map { geometry[$0.bounds] }
        
        // update the rects in the token structure to calculate the active Index
        // base on the token's position
        token.update(rects: token.rects)
        
        return ActivePlayerMarkerView(size: token.size,
                                      animate: isDraggingToken)
            // not animated
            .position(tokenLocation)
            .offset(tokenDelta)
            .gesture(dragGesture)
            .animation(nil)
 
    }
                    
    @GestureState var tokenDelta: CGSize = .zero
    var isDraggingToken: Bool { tokenDelta != .zero }

    // MARK: handle token position
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 10)
            .updating($tokenDelta) { dragValue, state, _ in
                token.location = dragValue.location
                state = dragValue.translation
                
                settings.players.activePlayerIndex =
                    token.findIndexOfNearestRect()
                
            }
            .onEnded() { value in
                token.moveToActiveRect()
                tokenLocation = token.location
            }
    }
    
    /// emphasize the active Player a little
    func activePlayerView(for player: Player) -> some View {
        func shadowColor(for player: Player) -> Color {
            player == settings.players.activePlayer ? .green : .clear
        }

        return playerView(for: player)
            .shadow(color: shadowColor(for: player),
                    radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
    }

    
    
    // MARK: - show the buffer
    
    private let showBufferContents = true
    
    let bufferViewSize : CGFloat = 144.0
    
    /// a player accepting a text-to number convertible onDrop for the buffer
    ///
    /// starts a timer. Modified to be a VStack with a GameCounter
    ///
    func playerView(for player: Player) -> some View {
        
        VStack {
            
            CounterView(counter: player.games)
                .padding(.horizontal)
            
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
                } // the onDrop modifier
        }
    }
}

// MARK: - extensions for distance
extension CGRect {
    var center: CGPoint { CGPoint(x: midX, y: midY) }
}

extension CGPoint {
    func squareDistance(to point: CGPoint) -> CGFloat {
        return (point.x - x) * (point.x - x) +
            (point.y - y) * (point.y - y)
    }
}

// MARK: - previews
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
