//
//  ScoreBox.swift
//  Points
//
//  Created by Alexander Völz on 01.08.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import UIKit

enum LineType { case normal, diagonal }
let lineWidth : [ LineType: CGFloat ] = [ .normal: 8.0, .diagonal: 5.0 ]


/// add a new line: tmpScore
/// draw corners until score, then draw tmpScore lines
class ScoreBox: UIView {

	static var maxScore: Int { get { return corners.count - 1 } }
	var score: Int = 0 { didSet { setNeedsDisplay() } }
	var tmpScore: Int = 0 { didSet { setNeedsDisplay() } }

	static let lines = [[ CGPoint(x:0,y:0), CGPoint(x:0,y:1)],
						[ CGPoint(x:0,y:1), CGPoint(x:1,y:1)],
						[ CGPoint(x:1,y:1), CGPoint(x:1,y:0)],
						[ CGPoint(x:0,y:0), CGPoint(x:1,y:0)],
						[ CGPoint(x:0,y:0), CGPoint(x:1,y:1)],
						[ CGPoint(x:0,y:1), CGPoint(x:1,y:0)]]
	
	static let corners = [ CGPoint(x:0,y:0), CGPoint(x:0,y:1), CGPoint(x:1,y:1), CGPoint(x:1,y:0), CGPoint(x:0,y:0), CGPoint(x:1,y:1) ]
	

	/// add tmpScore to score
	func updateScore() {
		score += tmpScore
		tmpScore = 0
	}
	
	enum LineColor {
		case black, red
	}
	
	/// returns remaining empty fields
	func fill(with score: Int, color: LineColor) -> Int? {
		guard score > 0 else { return nil }
		
		switch color {
		case .red:
			if score > Self.maxScore {
				self.tmpScore = Self.maxScore
				return score - Self.maxScore
			} else {
				self.tmpScore = score
				return 0
			}
		case .black:
			if score > Self.maxScore {
				self.score = Self.maxScore
				return score - Self.maxScore
			} else {
				self.score = score
				return 0
			}
		}
	}
	
	/// draw boxes: score in black, tmpScore in red
	override func draw(_ rect: CGRect) {
		let context = UIGraphicsGetCurrentContext()!
		
		// Draw a black line
		context.setLineWidth(lineWidth[.normal]!)
		context.setStrokeColor(Constant.Box.lineColor.cgColor)
		
		context.move(to: ScoreBox.corners[0])
		let totalScore = score + tmpScore
		let minScore = totalScore > ScoreBox.maxScore ? ScoreBox.maxScore : totalScore
		if totalScore > 0 {
			var oldCorner: CGPoint?
			for count in 1 ... minScore {
				if count > score {
					context.setStrokeColor(Constant.Box.tmpColor.cgColor)
				}
				let newCorner = CGPoint(x: ScoreBox.corners[count].x * frame.width, y: ScoreBox.corners[count].y * frame.height)
				if count == ScoreBox.maxScore {
					if let corner = oldCorner {
						context.strokePath()
						context.move(to: corner)
						context.setLineWidth(lineWidth[.diagonal]!)
					}
				}
				oldCorner = newCorner
				context.addLine(to: newCorner)
			}
		}
		context.strokePath()
	}
	
}
