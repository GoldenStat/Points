//
//  PlayerUI.swift
//  Points
//
//  Created by Alexander Völz on 20.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

enum PlayerViewTitleStyle {
    case normal, inline
}

struct PlayerView: View {
    
    @EnvironmentObject var settings: GameSettings
    @ObservedObject var player : Player
    var currentRule : Rule { settings.rule }
    var playerUI: PlayerUIType { currentRule.playerUI }
    var titleStyle : PlayerViewTitleStyle = .inline
    var scoreStep: Int = 1
    
    var body: some View {
        
        VStack {
            
            if titleStyle == .normal {
                PlayerHeadline(player: player)
            }
            
            ZStack() {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .overlay(Emphasize() {
                        
                        VStack {
                            if titleStyle == .inline {
                                PlayerHeadline(player: player)
                                    .padding(.top)
                            }

                            ScoreRepresentationView(
                                score: player.score,
                                uiType: playerUI
                            )
                            
                            Spacer()
                        }
                    })
                    .aspectRatio(scoreBoardRatio, contentMode: .fit)
                    .padding(.horizontal)
                
                BufferView(score: player.score)
            }
            .onTapGesture(perform: {
                player.add(score: scoreStep)
                settings.startTimer()
            })

            Spacer()
        }
        .transition(.opacity)
    }

    // MARK: -- the local variables
    let scoreBoardRatio: CGFloat = 3/4

    // MARK: -- private variables
    private let cornerRadius : CGFloat = 16.0
}

struct BufferView: View {

    var score: Score

    var scoreOpacity: Double { score.buffer > 0 ? 0.3 : 0.0 }
    var body: some View {
        Text(score.buffer.description)
            .font(.system(size: 144, weight: .semibold, design: .rounded))
            .opacity(scoreOpacity)
    }
}

struct PlayerHeadline: View {
    @ObservedObject var player : Player

    var body: some View {
        ZStack {
            Text("\(player.name)")
                .font(.title)
            HStack(spacing: 20) {
                Spacer()
                MatchBox(score: Score(player.games))
                    .frame(width: 100, height: 60)
            }
            .background(Color.white
                            .opacity(0.1)
                            .blur(radius: /*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/))
        }
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
    static var player = Player(from: PlayerData(name: "Alexander", points: 9, games: 1))
    static var settings = GameSettings()
    
    static var previews: some View {
        PlayerView(player: player)
            .environmentObject(settings)
    }
}
