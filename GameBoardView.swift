//
//  gameBoardView.swift
//  Points
//
//  Created by Alexander Völz on 06.08.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import UIKit

class GameBoardView: UIView {

	var players: [ Player ] = [] { didSet { initalizePlayerUIs() } }
	private var playerUIs: [ PlayerUI ] = []
	var maxPoints = 0 { didSet { initalizePlayerUIs() } }
	private var intTextDelegate : UITextFieldDelegate? = nil
	
	func setup(for players: [Player] ) {
		maxPoints = Player.maxPoints
		self.players = players
	}
	
	fileprivate func removePlayerUIs() {
		_ = playerUIs.map { $0.removeFromSuperview() }
		playerUIs = []
	}
	
	fileprivate func createOneUI(frame: CGRect, player: Player, number tag: Int) {
		let playerUI = PlayerUI(frame: frame.insetBy(dx: 5.0, dy: 5.0))
		playerUI.setup(with: player)
		playerUI.setup(with: maxPoints)
		playerUI.set(tag: tag)
		playerUI.nameTextField?.delegate = textDelegate()
		addSubview(playerUI)
		playerUIs.append(playerUI)
	}
	
	func textDelegate() -> UITextFieldDelegate? {
		return intTextDelegate
	}
	
	fileprivate func initalizePlayerUIs() {
		
		removePlayerUIs()
		
		for (index,player) in players.enumerated() {
			let playerFrame = create(frame: index)
			createOneUI(frame: playerFrame, player: player, number: index)
		}
	}
	
	func set(delegate: UITextFieldDelegate?) {
		intTextDelegate = delegate
	}
	
	func create(frame index: Int) -> CGRect {

		let height = Constant.PlayerUI.height
		//		let topMargin : CGFloat = 90
		var width, startX, startY: CGFloat

		switch players.count {
		case 2:
			width = frame.width / 2.0
			startX = width * CGFloat(index)
			startY = 0
		case 3:
			width = frame.width / 2.0
			startX = width * CGFloat(index)
			startY = 0
			if index > 1 {
				startY += height
				startX = width * ( CGFloat(index-2) + 0.5 )
			}
		case 4:
			width = frame.width / 2.0
			
			if index > 1 {
				startY = height
				startX = width * CGFloat(index-2)
			} else {
				startY = 0
				startX = width * CGFloat(index)
			}
		case 5:
			width = frame.width / 3.0
			startX = width * CGFloat(index)
			startY = 0
			if index > 2 {
				startY += height
				startX = width * ( CGFloat(index-3) + 0.5 )
			}
		case 6:
			width = frame.width / 3.0
			startX = width * CGFloat(index)
			startY = 0
			if index > 2 {
				startX = width * CGFloat(index-3)
				startY += height
			}
		default:
			startX = 0.0
			startY = 0
			width = frame.width
		}
		
		return CGRect(x: startX,
					  y: startY,
					  width: width,
					  height: height)
	}

	func update(with world: GameWorld) {
		
	}
	
	func reset() {
		
	}

	
	func ui(for index: Int) -> PlayerUI? {
		guard index < playerUIs.count else { return nil }
		return playerUIs[index]
	}
	
	func player(for index: Int) -> Player? {
		guard index < players.count else { return nil }
		return players[index]
	}
	
	func updatePlayerUIs() {
		for index in 0 ..< players.count {
			if let ui = ui(for: index) {
				if let player = player(for: index) {
					ui.player = player
					ui.removeTarget()
				}
			}
		}
	}

	func activate() {
		gameMode = ControlMode.play
	}
	
	func deactivate() {
		gameMode = ControlMode.edit
	}
	
	var gameMode = ControlMode.play

	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		switch gameMode {
		case .play:
			return self
		case .edit:
			return nil
		}
	}

}
