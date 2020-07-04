//
//  PlayerUI.swift
//  Points
//
//  Created by Alexander Völz on 20.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct PlayerView: View, Identifiable {
    @EnvironmentObject var settings: GameSettings
    @ObservedObject var player : Player
    
    var id : PlayerData.ID { player.id }
    var score: Score { player.score }
    
    var body: some View {
        
        VStack {
            
            Text(player.name)
                .font(.title)
            
            if showScore {
                ScoreRow(score: score)
            }
            
            RoundedRectangle(cornerRadius: cornerRadius)
                .overlay(Emphasize(theme: .light) {
                    ScoreBoxUI(score: player.score)
                })
                .onTapGesture(perform: {
                    player.add(score: 1)
                    settings.startTimer()
                })
                .aspectRatio(scoreBoardRatio, contentMode: .fit)
                .padding(.horizontal)
            
            Spacer()
        }
        .gesture(longPress)
        .transition(.opacity)
    }

    // MARK: -- the local variables
    let scoreBoardRatio: CGFloat = 0.7
//    var scoreBoardRatio : CGFloat { CGFloat ( (settings.maxPoints / Int(Box.maxLength) / 2) / 2
//    ) }

    // MARK: -- show the score details
    @GestureState var showScore = false
    
    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 3)
            .updating($showScore) { currentstate, gestureState, transaction in
                gestureState = currentstate
            }
    }

    // MARK: -- private variables
    private let offsetPoint = CGSize(width: 1000, height: 200)
    private let cornerRadius : CGFloat = 16.0
    private let lineWidth : CGFloat = 1.5
}

struct ScoreRow: View {
    @State var editMode: EditMode = .inactive

    let score: Score
    
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
    }
}
