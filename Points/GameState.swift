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
	
	var points: [ Int ]
	var players: Int { get { return points.count }}
	
	init(with players: [Player] ) {
		points = players.map{ $0.score}
	}
	
}
