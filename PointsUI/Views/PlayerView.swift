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
    var playerUI: PlayerUIType =
        .matches
//        .checkbox(5)
//        .numberBox
//        .selectionBox([3,4])
//    { currentRule.playerUI }
    
    var titleStyle : PlayerViewTitleStyle = .inline
    var scoreStep: Int = 1
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            if titleStyle == .normal {
                PlayerHeadline(player: player)
            }
            
            VStack (spacing: 0) {
                if titleStyle == .inline {
                    PlayerHeadline(player: player)
                        .padding(.top)
                }
                
                ScoreRepresentationView(
                    score: player.score,
                    uiType: playerUI
                )
            }
            .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: 0.5))
            .emphasizeShape()
            .padding(.horizontal)
            .onTapGesture(perform: {
                player.add(score: scoreStep)
                settings.startTimer()
            })
        }
        .transition(.opacity)
    }
    
    // MARK: -- private variables
    private let cornerRadius : CGFloat = 12.0
    private let scoreBoardRatio: CGFloat = 3/4
    
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
                    .frame(maxWidth: 100, maxHeight: 60)
            }
            .background(Color.white
                            .opacity(0.1)
                            .blur(radius: /*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/))
        }
    }
}

struct PlayerUI_Previews: PreviewProvider {
    static var player = Player(from: PlayerData(name: "Alexander", points: 10, games: 1))
    static var settings = GameSettings()
    
    static var previews: some View {
        PlayerView(player: player)
            .environmentObject(settings)
    }
}
