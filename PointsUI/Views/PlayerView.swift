//
//  PlayerUI.swift
//  Points
//
//  Created by Alexander Völz on 20.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct PlayerView: View, Identifiable {
    @ObservedObject var settings : GameSettings
    
    var players : Players {
        return settings.players
    }
    
    var player: Player
    
    var id : Player.ID { player.id }
    var name: String { player.name }
    var score: Int { player.score }
    
    func saveScore() {
        boxUI.saveScore()
    }
    
    let boxUI : ScoreBoxUI
    
    init(settings: GameSettings, player: Player) {
        self.settings = settings
        self.player = player
        boxUI = ScoreBoxUI(settings: settings, player: player)
    }
    
    var body: some View {
        VStack {
            Text(self.name).font(.title)
            boxUI
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16).stroke(Color.black, lineWidth: 0.5))
    }
}

struct PlayerUI_Previews: PreviewProvider {
    
    static var playerView = PlayerView(settings: GameSettings(), player: Player(name: "Alexander"))
    
    static var previews: some View {
        VStack {
            playerView
            Button("Save") {
                Self.playerView.saveScore()
            }
            .padding(.horizontal)
        }
    }
}
