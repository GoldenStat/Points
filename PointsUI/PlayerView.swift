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
                    .animation(.default)
                }
                .emphasizeShape(cornerRadius: cornerRadius)
                .padding()
                .onTapGesture(perform: {
                    withAnimation(.easeInOut(duration: 2.0)) {
                        // add score for this player
                        player.add(score: settings.scoreStep)
                        // modify current history buffer
                        settings.storeInHistory()
                    }
                    settings.startTimer()
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
        VStack(spacing: 0) {
            Text("\(player.name)")
                .font(.largeTitle)
                .fontWeight(isActive ? .bold : .regular)
                .fixedSize()
                
            CounterView(counter: player.games)
        }
    }
}

struct CounterView: View {

    let counter: Int

    var counterImage: some View {
        Image(systemName: "circle.fill")
            .font(.caption)
            .foregroundColor(.pointbuffer)
    }
    
    var body: some View {
        HStack(spacing: 10) {
            Spacer()
            ForEach(0..<counter, id: \.self) { num in
                counterImage
            }
        }
    }
}

struct PlayerUI_Previews: PreviewProvider {
    static var player = Player(from: Player.Data(name: "Alexander", score: Score(21), games: 3))
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
