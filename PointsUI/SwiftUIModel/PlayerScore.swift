//
//  PlayerUI.swift
//  Points
//
//  Created by Alexander Völz on 20.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct PlayerScore: View, Identifiable {
	var id = UUID()
	var name: String
	
	@State private var score: Int = 20
	@State private var UIs = [ScoreBoxUI(score: 0)]
	
	var body: some View {
		VStack {
			VStack {
				ForEach(UIs) { UI in
					Text(self.name).font(.largeTitle)
					UI
				}
			}
			.overlay(
				RoundedRectangle(cornerRadius: 16).stroke(Color.black, lineWidth: 4))
				.padding()
			Button("reset score") {
				self.UIs = [ScoreBoxUI(score: 0)]
			}
		}
	}
}

//struct PlayerButton: View {
//	var name: String
//	@State private var score: Int = 0
//
//	var body: some View {
//		VStack {
//			PlayerScore(name: self.name, score: self.score)
//		}
//	}
//}

struct PlayerUI_Previews: PreviewProvider {
	static var previews: some View {
			PlayerScore(name: "Alexander")
	}
}
