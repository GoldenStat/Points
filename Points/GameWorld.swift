//
//  GameWorld.swift
//  Points
//
//  Created by Alexander Völz on 07.07.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import Foundation

struct GameWorld {
	
	var players : [Player] = []

	var initialNames = [ "Alexander", "Lili", "Villa", "Sebastian", "Lucas", "Maria" ]
	var maxPoints : Int { get { return Player.maxPoints } set { Player.maxPoints = newValue } }
	var maxGames = 3

	init(count: Int) {
		for playerNo in 1 ... count {
			players.append(Player(name: initialNames[playerNo-1]))
		}
	}
	
	var names : [ String ] {
		get {
			return players.map{ $0.name }
		}
	}
	var scores : [ Int ] {
		get {
			return players.map{ $0.score }
		}
	}
	var games : [ Int ] {
		get {
			return players.map{ $0.gamesWon }
		}
	}
	
	mutating func resetPlayers(with names: [String]) {
		players = []
		_ = names.map { addPlayer(name: $0) }
	}
	
	mutating func addPlayer(name: String) {
		players.append(Player(name: name))
	}
	
	func resetScores() {
		for player in players {
			player.resetScore()
		}
	}
}
