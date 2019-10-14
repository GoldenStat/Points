//
//  Settings.swift
//  Points
//
//  Created by Alexander Völz on 11.07.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import Foundation

struct Settings: Codable {
	var gamePoints: Int = 24
	var selectedPointsIndex: Int = 0
	var maxGames: Int = 3
	var playerNames: [String] = []

	func save() {
		UserDefaults.standard.set(encode(), forKey: "Settings")
	}
	
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

