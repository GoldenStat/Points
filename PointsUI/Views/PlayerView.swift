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
    @State var deleteMe = false
    
    var id : PlayerData.ID { player.id }
    var score: Score { player.score }
    var showScore = false
    
    var body: some View {
        VStack {
            
            Text(player.name).font(.largeTitle).fontWeight(.bold)
//            HeaderView(name: $player.name)
            
            if showScore {
                ScoreRow(score: score)
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.black, lineWidth: lineWidth)
                    .overlay(Emphasize(theme: .light) {
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
        .transition(.offset(offsetPoint))
    }
    
    // MARK: -- private variables
    private let offsetPoint = CGSize(width: 1000, height: 200)
    private let cornerRadius : CGFloat = 16.0
    private let lineWidth : CGFloat = 1.5
}

struct HeaderView: View {
    @Binding var name: String
    @State var editMode : EditMode = .inactive
    
    var body: some View {
        
        if editMode == .inactive {
            return AnyView{ Text(name).font(.largeTitle).fontWeight(.bold) }
        } else {
            return AnyView{TextField("New Player", text: $name)}
        }
    }
}


struct PlayerUI_Previews: PreviewProvider {
    
    static var player = Player(name: "Alexander")
    
    static var previews: some View {
        PlayerView(player: player)
    }
}


struct ScoreRow: View {
    @State var editMode: EditMode = .inactive

    let score: Score
    
    var body: some View {
        HStack {
            Text("Puntos: \(score.value)" +
                    (score.buffer > 0 ? " + \(score.buffer)" : "")
            )
        }
        .fixedSize()
    }
}
