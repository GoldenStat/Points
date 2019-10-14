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

	var score: Int = 0 { didSet { updateScore() } }
	var tmpScore: Int = 0 { didSet { updateScore() } }

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
	
	@objc func addPoint() {
		score += 1
	}
	
	func removePoint() {
		score -= 1
	}

	func finalizeScore() {
		score += tmpScore
		tmpScore = 0
	}
	
	func updateScore() {
		var black = self.score
		var red = self.tmpScore
		
		for box in boxes {
			if black > 0 {
				let thisScore = min(ScoreBox.maxScore, black)
				box.score = thisScore
				black -= thisScore
				if black == 0 { // we finished the black lines, continue with red
					let tmpScore = min(ScoreBox.maxScore - black, red)
					box.tmpScore = tmpScore
					red -= tmpScore
				} else {
					box.tmpScore = 0 // don't count red lines down
				}
			} else {
				let tmpScore = min(ScoreBox.maxScore, red)
				box.tmpScore = tmpScore
				red -= tmpScore
			}
		}
	}
	
}
