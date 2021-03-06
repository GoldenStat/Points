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
    
    var objects : Int { players.count }
    var players: Players { settings.players }

    // manage visual representation and controls active Player
    var token : Token { players.token }

    @State var lastOrientation = UIDevice.current.orientation

    // MARK: - main view
    var body: some View {
        // MARK: the player views arranged in a grid
        GeometryReader { geom in
            ZStack {
                
                Color.clear // to use all the space
                
                // vertical layout
                if geom.size.width < geom.size.height {
                    VStack {
                        ForEach(0 ..< PlayerGrid.rows) { rowIndex in
                            HStack {
                                ForEach(0 ..< PlayerGrid.cols) { colIndex in
                                    let index = PlayerGrid(row: rowIndex, col: colIndex).index
                                    if  index < objects {
                                        let player = players.items[index]
                                        
                                        activePlayerView(for: player, with: geom.size)
                                            
                                            // preference data for the views
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
                        ForEach(players.items) { player in
                            activePlayerView(for: player, with: geom.size)
                            
                            //                                    // preference data for the views
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
//        .padding(.horizontal,2)
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
            players.reset()
            withAnimation(.default.delay(1.0)) {
                players.enableActivePlayer()
            }
        }
    }
    
    struct idRect : Identifiable{
        let id=UUID()
        let rect : CGRect
    }
    
    // MARK: - token code
    
    
    /// this function is triggered by .overlayPreferenceValue when the geometries change
    /// it creates a token View, this view needs all the preferences of the player's views to calcluate
    /// the token's position
    func updateRects(_ geometry: GeometryProxy,
                     _ preferences: [TokenAnchor]) -> some View {
        
        token.update(bounds: preferences.map { geometry[$0.bounds] })
        
        return ActivePlayerMarkerView(token: token,
                                      animate: isDraggingToken)
            .opacity(tokenopacity)
            .animation(.default)
            // not animated
            .gesture(dragGesture)
            .animation(nil)
        
        
    }
    
    var tokenopacity : Double {
        if token.state == .inactive {
            return 0.01
        } else {
            return 1.0
        }
    }
    
    @GestureState var draggingToken: Bool = false
    var isDraggingToken : Bool {
        if token.state == .inactive {
            return false
        } else {
            return draggingToken
        }
    }
    
    // MARK: handle token position
    var dragGesture: some Gesture {
        DragGesture()
            .updating($draggingToken) { dragValue, state, _ in
                // animate token
                guard token.state != .inactive else { return }
                state = true
                
                players.updateToken(location: dragValue.location)                
            }
            .onEnded() { value in
                guard token.state != .inactive else { return }
                token.moveToActiveRect()
            }
    }
    
    // MARK: - border for active Player
    /// emphasize the active Player - handled over the players object
    func activePlayerView(for player: Player, with size: CGSize) -> some View {

        func shadowColor(for player: Player) -> Color {
            player == players.activePlayer ? .green : .clear
        }
        
        func height(for size: CGSize) -> CGFloat {
            if size.width < size.height {
                return size.height * 0.43 // 2 players could be taller
            } else {
                return size.height * 0.9
            }
        }
        
        func width(for size: CGSize) -> CGFloat {
            if size.width < size.height {
                return size.width * 0.5 // 2 - 4 players
            } else {
                return size.width * 0.9 / CGFloat(objects)
            }
        }

        return playerView(for: player)
            .frame(width: width(for: size),
                   height: height(for: size))
            // a shadow shows the active player
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
