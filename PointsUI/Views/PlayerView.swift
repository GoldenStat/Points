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

	var id = UUID()
	var name: String { get {
		return player.name
		}}
	var score: Int { get {
		return player.points
		}}
		
	var body: some View {
			VStack {
				Text(self.name).font(.title)
				ScoreBoxUI(player: player)
			}
			.overlay(
				RoundedRectangle(cornerRadius: 16).stroke(Color.black, lineWidth: 0.5))
	}
}

struct PlayerUI_Previews: PreviewProvider {
	static var previews: some View {
		PlayerView(player: Player(name: "Alexander")).padding(.horizontal)
	}
}
