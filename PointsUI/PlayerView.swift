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
    var isActive: Bool { settings.activePlayer == player }
    var isTargetedForDrop: Bool = false
        
    var body: some View {
            VStack() {
                
                if titleStyle == .normal {
                    PlayerHeadline(player: player, isActive: isTargetedForDrop)
                        .padding(.horizontal)
                }
                
                VStack() {
                    
                    if titleStyle == .inline {
                        PlayerHeadline(player: player, isActive: isTargetedForDrop)
                            .padding(.horizontal)
                            
                    }
                    
                    ScoreRepresentationView(
                        score: player.score,
                        uiType: playerUI
                    )
                }
                .emphasizeShape(cornerRadius: cornerRadius)
                .padding()
                .onTapGesture(perform: {
                    settings.startTimer()
                    player.add(score: currentRule.scoreStep.defaultValue)
                })
            }
    }
            
    // MARK: -- private variables
    private let cornerRadius : CGFloat = 12.0
    private let scoreBoardRatio: CGFloat = 3/4
    
    func viewContains(point: CGPoint, proxy: GeometryProxy) -> Bool {
        // transform frame and point
        let frame = proxy.frame(in: .local)
        return frame.contains(point)
    }
}

struct PlayerHeadline: View {
    @ObservedObject var player : Player
    
    var isActive: Bool = false
    
    var body: some View {
        ZStack {
            Text("\(player.name)")
                .font(.largeTitle)
                .fontWeight(isActive ? .bold : .regular)
                .fixedSize()
            HStack(spacing: 0) {
                Spacer()
                PlayerGamesCounterView(games: player.games)
            }
            .offset(x: 0, y: 30)
        }
    }
}

struct PlayerGamesCounterView: View {
    let games: Int
    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<games, id: \.self) { num in
                Circle()
                    .fill(Color.pointbuffer)
                    .frame(width: 10, height: 10)
                    .offset(x: 0, y: -10)
            }
        }
    }
}

struct PlayerUI_Previews: PreviewProvider {
    static var player = Player(from: Player.Data(name: "Alexander", score: Score(21), games: 8))
    static var settings = GameSettings()
    
    static var previews: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
            PlayerView(player: player)
            PlayerView(player: player)
            PlayerView(player: player)
        }
            .environmentObject(settings)
    }
}
