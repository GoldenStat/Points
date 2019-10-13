//
//  PlayerUI.swift
//  Points
//
//  Created by Alexander Völz on 07.07.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import UIKit

fileprivate extension Selector {
	static let changeName = #selector(PlayerUI.changeName(_:))
}

/// this view consists of a textfield and a ScoreButton
class PlayerUI: UIView {

	var nameTextField: UITextField?
	var scoreButton: ScoreButton?
	var totalHeight: CGFloat { get { return frame.height } }
	let buttonAreaHeight : CGFloat = 20
	var nameHeight: CGFloat!
	var gameMode = ControlMode.play
	
	var player: Player! {
		didSet {
				nameTextField?.text = player.name
				scoreButton?.score = player.score
		}
	}
	
	override init(frame: CGRect) {
		
		super.init(frame: frame)
		
		layer.borderColor = UIColor.black.cgColor
		layer.borderWidth = 2.0
		layer.cornerRadius = 10.0

		let nameFrame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: Constant.PlayerUI.nameSize)
		let nameTextField = UITextField(frame: nameFrame)
		nameTextField.textAlignment = .center
		nameTextField.font = UIFont(name: "New York", size: Constant.PlayerUI.nameSize)
		nameTextField.text = "Player"
		nameTextField.addTarget(self, action: .changeName, for: .editingDidEnd)
		nameTextField.autocorrectionType = .no
		nameHeight = nameTextField.frame.height
		
		self.nameTextField = nameTextField
		addSubview(nameTextField)
	}
		
	func setup(with points: Int) {
		let _ = subviews.map { if let view = $0 as? ScoreButton { view.removeFromSuperview()} } // delete former ScoreButtons
		
		let topSpace = nameHeight + Constant.PlayerUI.margin
		let buttonFrame = CGRect(x: 0.0, y: topSpace, width: frame.width, height: frame.height - topSpace)
		
		let button = ScoreButton(frame: buttonFrame)
		button.setup(with: points)
		button.backgroundColor = Constant.Button.bgColor
	
		self.scoreButton = button
		
		addSubview(button)
	}

	func setTextFieldDelegate(_ textFieldDelegate: UITextFieldDelegate) {
		nameTextField?.delegate = textFieldDelegate
	}
	
	@objc func changeName(_ textfield: UITextField) {
		if let newName = textfield.text {
			player.name = newName
		}
	}
	
	func set(tag: Int) {
		nameTextField?.tag = tag
	}
	
	func reload(with maxScore: Int) {
		for button in subviews.compactMap({ $0 as? ScoreButton }) {
			button.setup(with: maxScore)
		}
	}
	
	func setup(with player: Player) {
		self.player = player
	}
	
	func add(points: Int) {
		player.add(points: points)
		scoreButton?.score += points
	}

	func removeTarget() {
		scoreButton?.removeTarget(self, action: nil, for: .allEvents)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	/*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
