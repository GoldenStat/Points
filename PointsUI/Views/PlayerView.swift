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
	
	@State private var UIs = [ScoreBoxUI(score: 0)]
	
	var body: some View {
			VStack {
				Text(self.name).font(.title)
				ScoreBoxUI(score: 0)				
			}
			.overlay(
				RoundedRectangle(cornerRadius: 16).stroke(Color.black, lineWidth: 4))
				.padding()
	}
}

struct PlayerUI_Previews: PreviewProvider {
	static var previews: some View {
			PlayerView(name: "Alexander")
	}
}
