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

class ScoreBox: UIView {

	static var maxScore: Int { get { return corners.count - 1 } }

	static let lines = [[ CGPoint(x:0,y:0), CGPoint(x:0,y:1)],
						[ CGPoint(x:0,y:1), CGPoint(x:1,y:1)],
						[ CGPoint(x:1,y:1), CGPoint(x:1,y:0)],
						[ CGPoint(x:0,y:0), CGPoint(x:1,y:0)],
						[ CGPoint(x:0,y:0), CGPoint(x:1,y:1)],
						[ CGPoint(x:0,y:1), CGPoint(x:1,y:0)]]
	
	static let corners = [ CGPoint(x:0,y:0), CGPoint(x:0,y:1), CGPoint(x:1,y:1), CGPoint(x:1,y:0), CGPoint(x:0,y:0), CGPoint(x:1,y:1) ]
	
	var score: Int = 0 { didSet { setNeedsDisplay() } }

	override func draw(_ rect: CGRect) {
		let context = UIGraphicsGetCurrentContext()!
		
		// Draw a black line
		context.setLineWidth(lineWidth[.normal]!)
		context.setStrokeColor(UIColor.black.cgColor)
		
		context.move(to: ScoreBox.corners[0])
		let minScore = score > ScoreBox.maxScore ? ScoreBox.maxScore : score
		if score > 0 {
			var oldCorner: CGPoint?
			for count in 1 ... minScore {
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
