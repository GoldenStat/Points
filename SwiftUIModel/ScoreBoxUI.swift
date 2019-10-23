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
	
	private var lastRowColums : Int { get {
		return Self.numberOfBoxes % Self.columns
		} }
	
	private func value(at row: Int, column: Int) -> Int {
		return self.score - Self.linesPerBox * (Self.columns * row + column)
	}
	
	private func box(at row: Int, column: Int) -> Box {
		return Box(score: value(at: row, column: column))
	}
	
	private func width(for geometrySize: CGSize) -> CGFloat {
		return geometrySize.width / CGFloat(Self.columns)
	}
	
	private func height (for geometrySize: CGSize) -> CGFloat {
		return geometrySize.height / CGFloat(self.rows)
	}
		
	var body: some View {
		Button(action:  {
			if self.score < Self.maxScore {
				self.score += 1
			}
		}) {
			GeometryReader { geometry in
				VStack {
					Text("points: \(self.score)")
					VStack(alignment: .leading) {
						ForEach(0 ..< self.rows - 1) { row in
							HStack {
								ForEach(0 ..< Self.columns) { col in
									self.box(at: row, column: col)
										.padding()
										.frame(width: self.width(for: geometry.size),
											   height: self.height(for: geometry.size))
								}
							}
						}
						ForEach(0 ..< self.lastRowColums) { col in
							self.box(at: self.lastRowColums, column: col)
								.padding()
								.frame(width: self.width(for: geometry.size),
									   height: self.height(for: geometry.size))
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
