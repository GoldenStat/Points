//
//  Player.swift
//  Points
//
//  Created by Alexander Völz on 09.06.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import Foundation

class Player {
	
	static var maxPoints: Int = 24
	
	var name: String
	var score = 0
	var gamesWon = 0
	
	init(name: String) {
		self.name = name
	}
	
	func add(points: Int) {
		score += points
	}
	
	func won() {
		gamesWon += 1
	}
	
	func resetScore() {
		score = 0
	}
	
	func encode() -> PlayerStruct {
		return PlayerStruct(name: name, score: score, gamesWon: gamesWon)
	}
}

struct PlayerStruct : Codable {
	var name: String
	var score = 0
	var gamesWon = 0
	
	func decode() -> Player {
		let player = Player(name: name)
		player.score = score
		player.gamesWon = gamesWon
		return player
	}
}

