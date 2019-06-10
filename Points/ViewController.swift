//
//  ViewController.swift
//  Points
//
//  Created by Alexander Völz on 09.06.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

	let maxPoints = 24
	let maxGames = 3
	
	var gameStateHistory: [ GameState ]!
	
	@IBOutlet var name1: UILabel!
	@IBOutlet var name2: UILabel!
	
	@IBOutlet var score1: UIButton!
	@IBOutlet var score2: UIButton!
	
	@IBOutlet var labelGames1: UILabel?
	@IBOutlet var labelGames2: UILabel?
	
	var player1 : Player!
	var player2 : Player!

	struct GameCounter {
		var player1 = 0
		var player2 = 0
	}
	
	func updateUI() {
		name1.text = player1.name
		name2.text = player2.name
		score1.setTitle(String(player1.score), for: .normal)
		score2.setTitle(String(player2.score), for: .normal)
		labelGames1?.text = String(player1.gamesWon)
		labelGames2?.text = String(player2.gamesWon)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		setup()
		updateUI()
	}
	
	var currentGameState: GameState!
	
	func setup() {
		player1 = Player(name: "Yo")
		player2 = Player(name: "Tu")
		currentGameState = GameState(with: player1, and: player2)
		gameStateHistory = []
	}
	
	func resetScores() {
		player1.score = 0
		player2.score = 0
	}
	
	func gameEnded(winningTeam: Player) {
		
		var ac : UIAlertController
		
		winningTeam.won()
		
		if winningTeam.name == player1.name {
			ac = UIAlertController(title: "we won! 😃", message: "continue?", preferredStyle: .alert)
		} else {
			ac = UIAlertController(title: "we lost! 😭", message: "revanche?", preferredStyle: .alert)
		}
		
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true) {
			[ weak self ] in
			self?.resetScores()
			self?.updateUI()
		}

	}
	
	func checkIfWon() {
		if player1.score >= maxPoints {
			gameEnded(winningTeam: player1)
		} else if player2.score >= maxPoints {
			gameEnded(winningTeam: player2)
		}
	}
	
	@IBAction func resetAll(_ sender: Any) {
		setup()
		updateUI()
	}

	@IBAction func addPoint(_ sender: UIButton) {
		gameStateHistory.append(currentGameState)
		
		if sender == score1 {
			player1.addPoint()
		} else if sender == score2 {
			player2.addPoint()
		}
		
		checkIfWon()
		updateUI()
	}

	@IBAction func undo(_ sender: Any) {
		guard gameStateHistory.count > 0 else { return }

		let lastState = gameStateHistory.removeLast()
		currentGameState = lastState
		player1 = lastState.copy1()
		player2 = lastState.copy2()
		
		updateUI()
	}
	
	
}

// setup
// currentGameState = [player1.score = 0, player2.score = 0]
// gameStateHistory = []

