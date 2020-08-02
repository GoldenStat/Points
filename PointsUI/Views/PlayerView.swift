//
//  PlayerUI.swift
//  Points
//
//  Created by Alexander Völz on 20.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct PlayerView: View {
    @EnvironmentObject var settings: GameSettings
    @ObservedObject var player : Player
    
    var body: some View {
        
        VStack {
            
            PlayerHeadline(player: player)
            
            if showScore {
                ScoreRow(player: player)
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .overlay(Emphasize() {
                        ScoreBoardView(player: player)
                    })
                    .aspectRatio(scoreBoardRatio, contentMode: .fit)
                    .padding(.horizontal)
                
                if player.score.buffer > 0 {
                    PlayerViewCount(number: player.score.buffer)
                }
            }
            .onTapGesture(perform: {
                player.add(score: 1)
                settings.startTimer()
            })

            Spacer()
        }
//        .gesture(longPress)
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

struct PlayerViewCount: View {
    var number: Int
    var body: some View {
        Text(number.description)
            .font(.system(size: 128, weight: .semibold, design: .rounded))
            .opacity(0.3)
    }
}
struct PlayerHeadline: View {
    @ObservedObject var player : Player

    var body: some View {
        Text("\(player.name)\(player.games == 0 ? "" : "(\(player.games))")")
            .font(.title)
    }
}

struct ScoreRow: View {
    @State var editMode: EditMode = .inactive

    let player: Player
    var score: Score { player.score }
    
    var body: some View {
        HStack {
            Text("Puntos: \(score.value)" +
                    (score.buffer > 0 ? " + \(score.buffer)" : "")
            )
            .fontWeight(.bold)
        }
        .fixedSize()
    }
}

struct PlayerUI_Previews: PreviewProvider {
    static var player = Player(name: "Alexander")
    
    static var previews: some View {
        PlayerView(player: player)
            .environmentObject(GameSettings())
    }
}
