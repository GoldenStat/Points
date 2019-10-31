//
//  Game.swift
//  PointsUI
//
//  Created by Alexander Völz on 30.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//
import SwiftUI

/// Player, as data and as object
class Player: ObservableObject {
	var name: String
	var points: Int
	
	init(name: String, points: Int = 0) {
		self.name = name
		self.points = points
	}
	
	func encode() -> PlayerData {
		return PlayerData(name: name, points: points)
	}
}

struct PlayerData : Codable {
	var name: String
	var points: Int = 0
	
	func object() -> Player {
		return Player(name: name, points: points)
	}
}

/// Default values
struct Default {
	static let names = [ "Alexander", "Lili", "Villa" ]
}

/// GameState: a list of the current players and their scores
struct GameState : Codable {
	var players = Default.names.map { Player(name: $0).encode() }
}

/// a list of game States
struct History : Codable {
	var states = [GameState]()
}

/// where we save the data in userdefaults
enum SettingsVariables : String {
	case saveData = "saveData"
}

/// what we save
struct SaveData : Codable {
	var maxGames = 3
	var pointsPerGame = 24
	var history = History()
	var state = GameState()
}

/// Game has all the data that should be saved
class Game : ObservableObject {
	
//	var scores: [Int] {
//		get {
//			return saveData.state.players.map { $0.points }
//		}
//	}
	
	var players: [PlayerData] {
		get {
			return saveData.state.players
		}
		set {
			saveData.state.players = newValue
		}
	}
	
	var names : [String] {
		get {
			return players.map {$0.name}
		}
	}
	
	@Published var saveData = SaveData() {
		didSet {
			let encoder = JSONEncoder()
			if let encoded = try? encoder.encode(saveData) {
				UserDefaults.standard.set(encoded, forKey: SettingsVariables.saveData.rawValue)
			}
		}
	}
	
	init() {
		let decoder = JSONDecoder()
		if let data = UserDefaults.standard.data(forKey: SettingsVariables.saveData.rawValue) {
			if let decodedData = try? decoder.decode(SaveData.self, from: data) {
				self.saveData = decodedData
			}
			return
		}
	}
}


