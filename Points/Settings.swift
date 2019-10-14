//
//  Settings.swift
//  Points
//
//  Created by Alexander Völz on 11.07.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import Foundation
/// Settings:
/// save and load settings.
/// Game Defaults are set here
struct Settings: Codable {

		/// maximum Points a player can achieve
	var gamePoints: Int = 24
	
		/// remember the index of the segmented control
	var selectedPointsIndex: Int = 0
	
		/// how many games does one need to win
	var maxGames: Int = 3
	
		/// store the player's names
	var playerNames: [String] = []

	/// save the settings into UserDefaults
	func save() {
		UserDefaults.standard.set(encode(), forKey: "Settings")
	}
	
	/// create a new Settings object from UserDefaults
	static func load() -> Settings {
		if let data = UserDefaults.standard.data(forKey: "Settings") {
			return decode(from: data) ?? Settings()
		}
		return Settings()
	}

	fileprivate func encode() -> Data? {
		return try? JSONEncoder().encode(self)
	}
	
	fileprivate static func decode(from data: Data) -> Settings? {
		return try? JSONDecoder().decode(Settings.self, from: data)
	}
	
}

