//
//  PlayerUI.swift
//  Points
//
//  Created by Alexander Völz on 20.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct PlayerScore: View {
	var name: String
	var body: some View {
		VStack {
			Text(name).font(.largeTitle)
			ScoreBoxUI()
			}
		.overlay(
			RoundedRectangle(cornerRadius: 16)
				.stroke(Color.black, lineWidth: 4))
		.padding()
	}
}

struct PlayerUI_Previews: PreviewProvider {
    static var previews: some View {
		PlayerScore(name: "Alexander")
    }
}
