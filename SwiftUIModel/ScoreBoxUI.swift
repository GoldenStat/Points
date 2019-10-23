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
	static let columns = 2
	static let linesPerBox = Box.maxNumberOfLines
	
	static var numberOfBoxes : Int { get {
		let overlay = Self.maxScore % Self.linesPerBox
			let ratio = Self.maxScore / Self.linesPerBox
			return ratio + (overlay > 0 ? 1 : 0)
		} }
	
	var rows : Int { get {
			let overlay = Self.numberOfBoxes % Self.columns
			let ratio = Self.numberOfBoxes / Self.columns
			return ratio + (overlay > 0 ? 1 : 0)
		} }
	
	var lastRowColums : Int { get {
		return Self.numberOfBoxes % Self.columns
		} }

	var body: some View {
		Button(action:  {
			self.score += 1
			if self.score > Self.maxScore {
				self.score = Self.maxScore
			}
		}) {
			GeometryReader { geometry in
				VStack {
					Text("points: \(self.score)")
					VStack(alignment: .leading) {
					ForEach(0 ..< self.rows - 1) { row in
						HStack {
							ForEach(0 ..< Self.columns) { col in
								Text("\(Self.columns * row + col)") .background(Color.green)
									.frame(width: geometry.size.width/CGFloat(Self.columns))
							}
						}
					}
					ForEach(0 ..< self.lastRowColums) { col in
						Text("\((Self.columns * (self.rows - 1) + col))")
							.background(Color.green)
							.frame(width: geometry.size.width/CGFloat(Self.columns))
					}
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
