//
//  PlayerUI.swift
//  Points
//
//  Created by Alexander Völz on 20.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct DoppelkopfPlayerView: View {
    
    @EnvironmentObject var settings: GameSettings
    @ObservedObject var player : Player
    
    var body: some View {
        ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white)
                    .overlay(
                        Emphasize() {
                        VStack {
                            
                            PlayerHeadline(player: player)
                            
                            if showScore {
                                ScoreRow(player: player)
                            } else {
                                Spacer()
                            }
                            
                            if player.score.buffer > 0 {
                                BufferView(score: player.score)
                            }
                        }
                        .padding()
                        }
                    )
                    .aspectRatio(3/2, contentMode: .fit)
                    .padding(.horizontal)
            }
            .onTapGesture(perform: {
                player.add(score: 10)
                settings.startTimer()
            })
            
            Spacer()
    
        .gesture(longPress)
        .transition(.opacity)
    }
    
    // MARK: -- the local variables
    let scoreBoardRatio: CGFloat = 3/4

    // MARK: -- show the score details
    @GestureState var showScore = false
    
    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 2)
            .updating($showScore) { currentstate, gestureState, transaction in
                gestureState = currentstate
            }
    }

    // MARK: -- private variables
    private let cornerRadius : CGFloat = 16.0
}



struct DoppelkopfPlayerView_Previews: PreviewProvider {
    static var player = Player(name: "Alexander")
    
    static var previews: some View {
        DoppelkopfPlayerView(player: player)
            .environmentObject(GameSettings())
    }
}
