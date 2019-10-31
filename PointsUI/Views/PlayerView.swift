//
//  PlayerUI.swift
//  Points
//
//  Created by Alexander Völz on 20.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct PlayerView: View, Identifiable {
	var id = UUID()
	var name: String
	
	@State private var score: Int = 20
	@State private var UIs = [ScoreBoxUI(score: 0)]
	
	var body: some View {
//		VStack {
			VStack {
				ForEach(UIs) { UI in
					Text(self.name).font(.title)
					UI
				}
			}
			.overlay(
				RoundedRectangle(cornerRadius: 16).stroke(Color.black, lineWidth: 4))
				.padding()
//			Button("reset score") {
//				self.UIs = [ScoreBoxUI(score: 0)]
//			}
//		}
	}
}

struct PlayerUI_Previews: PreviewProvider {
	static var previews: some View {
			PlayerView(name: "Alexander")
	}
}
