//
//  History.swift
//  Points
//
//  Created by Alexander Völz on 10.06.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import Foundation

struct History {
	
	var states = [GameState]()
	
	mutating func add(state: GameState) {
		states.append(state)
	}
	
	mutating func restoreLast() -> GameState? {
		guard let lastState = states.popLast() else { return nil }
		return lastState
	}
}
