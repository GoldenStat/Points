//
//  Game.swift
//  PointsUI
//
//  Created by Alexander Völz on 30.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//
import SwiftUI

/// Player
struct Player : Codable {
	var name: String
	var points: Int = 0
}

/// Default values
struct Default {
	static let names = [ "Alexander", "Lili", "Villa" ]
}

/// GameState: a list of the current players and their scores
struct GameState : Codable {
	var players = Default.names.map { Player(name: $0) }
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
	
	var players: [Player] {
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


