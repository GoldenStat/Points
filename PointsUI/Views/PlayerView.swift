//
//  PlayerUI.swift
//  Points
//
//  Created by Alexander Völz on 20.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct PlayerView: View, Identifiable {
    @ObservedObject var player : Player
    
    var id : PlayerData.ID { player.id }
    var name: String { player.name }
    var score: Int { player.score }
    var tmpScore: Score { player.tmpScore }
    
    var body: some View {
        
        VStack {
            Text(self.name).font(.title)
            
            HStack {
                Text("Puntos: \(score)")
                if tmpScore > 0 {
                    Text(" + ")
                    Text("\(tmpScore)")
                }
            }

            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.black, lineWidth: 1.5)
                
                Button(action: {
                self.player.add(score: 1)
                }) {
                    ScoreBoxUI(score: player.score, tmpScore: player.tmpScore)
                    }
            }
            .padding(.horizontal)
                    
            Spacer()
        }
    }
}

struct PlayerUI_Previews: PreviewProvider {
    
    static var player = Player(name: "Alexander")
    
    static var previews: some View {
        VStack {
            PlayerView(player: player)
            Button("Save") {
                player.saveScore()
            }
//            .padding(.horizontal)
        }
    }
}
