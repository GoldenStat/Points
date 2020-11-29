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
    var isActive: Bool { settings.activePlayer == player }
    
    @Binding var activePoint: CGPoint?
    
    var body: some View {
            VStack() {
                
                if titleStyle == .normal {
                    PlayerHeadline(player: player)
                }
                
                VStack() {
                    
                    if titleStyle == .inline {
                        PlayerHeadline(player: player)
                    }
                    
                    ScoreRepresentationView(
                        score: player.score,
                        uiType: playerUI
                    )
                }
                .emphasizeShape(cornerRadius: cornerRadius)
                .padding()
                .onTapGesture(perform: {
                    player.add(score: scoreStep)
                    settings.startTimer()
                })
            }
            .transition(.opacity)
    }
        
    @State var isTargeted: Bool = false
    // NOTE: - delete if .onDrop works
    func isTargetedByDrop(with geo: GeometryProxy) -> Bool {
        guard let point = activePoint else { return false }
        let answer = viewContains(point: point, proxy: geo)
        return answer
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
    
    var body: some View {
        ZStack {
            Text("\(player.name)")
                .font(.largeTitle)
            HStack(spacing: 20) {
                Spacer()
                
                MatchBox(score: Score(player.games))
                    .colorMultiply(.boardbgColor)
                    .frame(maxWidth: 120, maxHeight: 100)
            }
        }
    }
}

struct PlayerUI_Previews: PreviewProvider {
    static var player = Player(from: PlayerData(name: "Alexander", points: 10, games: 2))
    static var settings = GameSettings()
    
    static var previews: some View {
        PlayerView(player: player, activePoint: .constant(CGPoint(x: 100, y: 100)))
            .environmentObject(settings)
    }
}
