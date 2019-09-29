//
//  GameScoreArea.swift
//  Points
//
//  Created by Alexander Völz on 16.07.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import UIKit

class GameScoreArea: UIStackView {

	let textSize : CGFloat = Constant.TextSize.gameScore

	var resetButton: UIButton!
	var gameScoresLabel: UILabel!
	
	func setup() {
		
		axis = .vertical
		alignment = .fill
		distribution = .equalSpacing
		spacing = 5
		
		resetButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 80))
		resetButton.setTitle("reset score", for: .normal)
		resetButton.setTitleColor(.red, for: .normal)
		
		let gameFrame = CGRect(x: 0.0, y: 0, width: 100, height: 0)
		gameScoresLabel = UILabel(frame: gameFrame)
		gameScoresLabel.textAlignment = .center
		gameScoresLabel.font = UIFont(name: "Verdana", size: textSize)
		gameScoresLabel.adjustsFontSizeToFitWidth = true		
		
		addArrangedSubview(resetButton)
		addArrangedSubview(gameScoresLabel)

	}
	
	func set(score: String) {
		gameScoresLabel.text = score
	}
	
	func set(scores: [Int]) {
		let strings = scores.map {String($0)}
		gameScoresLabel.text = strings.joined(separator: " x ")
	}
	
	func buttonAction(from sender: Any, action: Selector) {
		resetButton.addTarget(sender, action: action, for: .touchUpInside)
	}
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
