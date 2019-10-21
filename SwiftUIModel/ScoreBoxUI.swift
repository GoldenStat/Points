//
//  PlayerView.swift
//  Points
//
//  Created by Alexander Völz on 18.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ScoreBoxUI: View {
	@State private var score : Int = 0
	static let maxScore = 24
	static var numberOfBoxes : Int {
		get {
			let ratio: Double = Double(ScoreBoxUI.maxScore) / Double(Box.maxNumberOfLines)
			return Int(ratio.rounded(.up))
		} }

	var body: some View {
		Button(action:  {
			self.score += 1
			if self.score > ScoreBoxUI.maxScore {
				self.score = ScoreBoxUI.maxScore
			}
		}) {
			VStack() {
				Text("points: \(self.score)")
				
				Group {
					ForEach(0 ..< ScoreBoxUI.numberOfBoxes / 2) { i in
						BoxHStack(index: i*2, score: self.score)
					}
				}
			}
		}
	}
}




struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreBoxUI()
    }
}

struct BoxHStack: View {
	let index: Int
	let score: Int
	var body: some View {
		HStack() {
			Box(score: score - Box.maxNumberOfLines * index).padding()
			if index + 1 < ScoreBoxUI.numberOfBoxes {
				Box(score: score - Box.maxNumberOfLines * (index + 1)).padding()
			}
		}.scaledToFit()
	}
}
