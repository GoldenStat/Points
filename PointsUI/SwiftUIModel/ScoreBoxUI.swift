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
	var publicScore : Int { get { return self.score } }
	
	static let maxScore = 24
	static let columns = 2
	static let linesPerBox = Box.maxNumberOfLines
	
	static var numberOfBoxes : Int { get {
		let overlay = Self.maxScore % Self.linesPerBox
		let ratio = Self.maxScore / Self.linesPerBox
		return ratio + (overlay > 0 ? 1 : 0)
		} }

	private func box(at index: Int) -> Box {
		return Box(score: score - Self.linesPerBox * index)
	}
	
	var body: some View {
		Button(action:  {
			if self.score < Self.maxScore {
				self.score += 1
			}
		}) {
			FlowStack(columns: Self.columns, numItems: Self.numberOfBoxes) { index, colWidth in
				self.box(at: index)
					.padding()
					.frame(width: colWidth, height: colWidth)
			}
		}
	}
}

struct PlayerView_Previews: PreviewProvider {
	static var previews: some View {
		ScoreBoxUI()
	}
}
