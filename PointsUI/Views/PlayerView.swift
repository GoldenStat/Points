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
        let box = ScoreBoxUI(settings: settings, player: player)
        box.saveScore()
    }
    
	var body: some View {
			VStack {
				Text(self.name).font(.title)
                ScoreBoxUI(settings: settings, player: player)
			}
			.overlay(
				RoundedRectangle(cornerRadius: 16).stroke(Color.black, lineWidth: 0.5))
	}
}

struct PlayerUI_Previews: PreviewProvider {
	static var previews: some View {
        PlayerView(settings: GameSettings(), player: Player(name: "Alexander")).padding(.horizontal)
	}
}
