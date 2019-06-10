//
//  GameState.swift
//  Points
//
//  Created by Alexander Völz on 10.06.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import Foundation

/// Game State:
/// a struct to keep the current game position and some methods to restore them
struct GameState {
	
	var player1: Player
	var player2: Player
	
	init(with player1: Player, and player2: Player) {
		self.player1 = Player(name: player1.name)
		self.player1.score = player1.score
		self.player1.gamesWon = player1.gamesWon
		self.player2 = Player(name: player2.name)
		self.player1.score = player2.score
		self.player1.gamesWon = player2.gamesWon
	}
	
	func copy(player: Player) -> Player {
		let playerCopy = Player(name: player.name)
		playerCopy.score = player.score
		playerCopy.gamesWon = player.gamesWon
		return playerCopy
	}
	
	func copy1() -> Player {
		return self.copy(player: player1)
	}
	
	func copy2() -> Player {
		return self.copy(player: player2)
	}
	
}
