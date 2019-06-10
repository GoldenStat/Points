//
//  Player.swift
//  Points
//
//  Created by Alexander Völz on 09.06.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import Foundation

class Player {
	var name: String
	var score = 0
	var gamesWon = 0
	
	init(name: String) {
		self.name = name
	}
	
	func addPoint() {
		score += 1
	}
	
	func won() {
		gamesWon += 1
	}
}

struct PlayerStruct {
	var name: String
	var score = 0
	var gamesWon = 0	
}

