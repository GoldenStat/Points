//
//  ScoreView.swift
//  Points
//
//  Created by Alexander Völz on 29.07.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import UIKit

//extension Selector {
//	static let addPoint = #selector(ScoreButton.addPoint)
//}

/// a button has three boxes, each responsible for its own drawing
class ScoreButton: UIButton {

	var score: Int = 0
	var tmpScore: Int = 0

	var totalScore: Int { get { return score + tmpScore }}
	
	var boxes = [ScoreBox]()
	let margin : CGFloat = 10
	var step : Int = 1
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		clipsToBounds = true
	}
	
	func setup(with maxPoints: Int) {
		
		_ = subviews.map { $0.removeFromSuperview() }
		
		let numberOfScoreBoxes = (maxPoints - 1) / ScoreBox.maxScore + 1
		let boxHeight : CGFloat = frame.height / CGFloat(((numberOfScoreBoxes+1)/2) * 2) * 2.0
		let boxWidth = frame.width / 2.0
		
		let boxFrame = CGRect(x: 0, y: 0, width: boxWidth, height: boxHeight)
		for index in 1 ... numberOfScoreBoxes {
			let newBox : ScoreBox!
			let dy = boxHeight * CGFloat((index - 1) / 2)
			
			if index % 2 == 1 {
				newBox = ScoreBox(frame: boxFrame.offsetBy(dx: 0, dy: dy)
					.insetBy(dx: margin, dy: margin / 2.0))
			} else {
				newBox = ScoreBox(frame: boxFrame.offsetBy(dx: boxWidth, dy: dy)
					.insetBy(dx: margin, dy: margin / 2.0))
			}
			newBox.isUserInteractionEnabled = false
			newBox.backgroundColor = Constant.ScoreButton.bgColor
			boxes.append(newBox)
			addSubview(newBox)
		}
		updateScore()
	}
		
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func finalizeScore() {
		score += tmpScore
		tmpScore = 0
		updateScore()
	}
	
	func updateScore() {
		var blackLines = score
		var redLines = tmpScore

		// fill boxes with score, then change to self.tmpScore
		for box in boxes {
			let lines = box.fill(with: blackLines, color: .black)
			if let lines = lines {
				blackLines = lines
			}
			if blackLines == 0 {
				if let lines = box.fill(with: redLines, color: .red) {
				redLines = lines
				}
			}
		}
	}
	
}
