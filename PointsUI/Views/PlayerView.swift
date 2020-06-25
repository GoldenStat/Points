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
    var name: String { player.name }
    var score: Score { player.score }
    
    var body: some View {
        VStack {
            Text(name).font(.title)
            
            ScoreRow(score: score)

            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.black, lineWidth: lineWidth)
                    .overlay( Emphasize(theme: .light) {
                        ScoreBoxUI(score: player.score)
                    })
                    .onTapGesture(perform: {
                        player.add(score: 1)
                        settings.startTimer()
                    }
                    )
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
    private let cornerRadius : CGFloat = 16.0
    private let lineWidth : CGFloat = 1.5
}

struct PlayerUI_Previews: PreviewProvider {
    
    static var player = Player(name: "Alexander")
    
    static var previews: some View {
            PlayerView(player: player)
    }
}


struct ScoreRow: View {
    let score: Score
    
    var body: some View {
        HStack {
            Text("Puntos: \(score.value)")
            if score.buffer > 0 {
                Text(" + ")
                Text("\(score.buffer)")
            }
        }
    }
}
